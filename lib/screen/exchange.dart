import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constant/colours.dart';
import '../theme/app_colors.dart';
import '../core/network/dio_client.dart';
import '../features/exchange/data/datasources/exchange_remote_data_source.dart';
import '../features/exchange/data/repositories/exchange_repository_impl.dart';
import '../features/exchange/domain/usecases/get_exchange_rate.dart';
import '../features/exchange/presentation/bloc/exchange_bloc.dart';
import '../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../features/wallet/domain/entities/wallet.dart';
import '../features/wallet/domain/usecases/get_wallets.dart';
import '../features/wallet/presentation/bloc/wallet_bloc.dart';

class Exchange extends StatelessWidget {
  const Exchange({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.create();
    final walletRepo = WalletRepositoryImpl(WalletRemoteDataSource(dio));
    final exchangeRepo =
        ExchangeRepositoryImpl(ExchangeRemoteDataSource(dio));

    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletBloc>(
          create: (_) => WalletBloc(getWallets: GetWallets(walletRepo))
            ..add(const WalletsRequested()),
        ),
        BlocProvider<ExchangeBloc>(
          create: (_) => ExchangeBloc(
            getExchangeRates: GetExchangeRates(exchangeRepo),
          )..add(const RatesRequested()),
        ),
      ],
      child: const _ExchangeView(),
    );
  }
}

class _ExchangeView extends StatefulWidget {
  const _ExchangeView();

  @override
  State<_ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<_ExchangeView> {
  final TextEditingController _sourceCtrl = TextEditingController();
  final TextEditingController _destCtrl = TextEditingController();

  @override
  void dispose() {
    _sourceCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  void _onExchangePressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, walletState) {
                if (walletState.isLoading && walletState.wallets.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  );
                }
                if (walletState.isFailure && walletState.wallets.isEmpty) {
                  return _WalletErrorView(
                    message: walletState.errorMessage ??
                        'Failed to load wallets.',
                    onRetry: () => context
                        .read<WalletBloc>()
                        .add(const WalletsRequested()),
                  );
                }
                final wallets = walletState.wallets;
                if (wallets.isEmpty) {
                  return _WalletErrorView(
                    message: 'No wallets available.',
                    onRetry: () => context
                        .read<WalletBloc>()
                        .add(const WalletsRequested()),
                  );
                }
                return MultiBlocListener(
                  listeners: [
                    BlocListener<ExchangeBloc, ExchangeState>(
                      listenWhen: (p, c) =>
                          p.destinationAmount != c.destinationAmount,
                      listener: (ctx, state) {
                        if (state.lastEditedSide == AmountEditedSide.source &&
                            _destCtrl.text != state.destinationAmount) {
                          _destCtrl.text = state.destinationAmount;
                        }
                      },
                    ),
                    BlocListener<ExchangeBloc, ExchangeState>(
                      listenWhen: (p, c) => p.sourceAmount != c.sourceAmount,
                      listener: (ctx, state) {
                        if (state.lastEditedSide ==
                                AmountEditedSide.destination &&
                            _sourceCtrl.text != state.sourceAmount) {
                          _sourceCtrl.text = state.sourceAmount;
                        }
                      },
                    ),
                    BlocListener<ExchangeBloc, ExchangeState>(
                      listenWhen: (p, c) =>
                          p.sourceWallet != c.sourceWallet ||
                          p.destinationWallet != c.destinationWallet,
                      listener: (ctx, state) {
                        if (_sourceCtrl.text != state.sourceAmount) {
                          _sourceCtrl.text = state.sourceAmount;
                        }
                        if (_destCtrl.text != state.destinationAmount) {
                          _destCtrl.text = state.destinationAmount;
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<ExchangeBloc, ExchangeState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _WalletDropdown(
                              label: 'From',
                              hint: 'Select source wallet',
                              wallets: wallets,
                              selected: state.sourceWallet,
                              excluded: state.destinationWallet,
                              onChanged: (w) => context
                                  .read<ExchangeBloc>()
                                  .add(SourceWalletSelected(w)),
                            ),
                            const SizedBox(height: 12),
                            _AmountField(
                              controller: _sourceCtrl,
                              suffix: _assetLabel(state.sourceWallet),
                              onChanged: (v) => context
                                  .read<ExchangeBloc>()
                                  .add(SourceAmountChanged(v)),
                            ),
                            const SizedBox(height: 24),
                            _SwapButton(
                              onPressed: () => context
                                  .read<ExchangeBloc>()
                                  .add(const WalletsSwapped()),
                            ),
                            const SizedBox(height: 24),
                            _WalletDropdown(
                              label: 'To',
                              hint: 'Select destination wallet',
                              wallets: wallets,
                              selected: state.destinationWallet,
                              excluded: state.sourceWallet,
                              onChanged: (w) => context
                                  .read<ExchangeBloc>()
                                  .add(DestinationWalletSelected(w)),
                            ),
                            const SizedBox(height: 12),
                            _AmountField(
                              controller: _destCtrl,
                              suffix: _assetLabel(state.destinationWallet),
                              onChanged: (v) => context
                                  .read<ExchangeBloc>()
                                  .add(DestinationAmountChanged(v)),
                            ),
                            const SizedBox(height: 20),
                            _RateRow(state: state),
                            const SizedBox(height: 32),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _onExchangePressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                child: const Text('Exchange Assets'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _assetLabel(Wallet? w) {
    if (w == null) return '';
    return (w.symbol?.trim().isNotEmpty == true
            ? w.symbol!
            : (w.asset?.trim().isNotEmpty == true ? w.asset! : ''))
        .trim();
  }
}

class _WalletDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<Wallet> wallets;
  final Wallet? selected;
  final Wallet? excluded;
  final ValueChanged<Wallet> onChanged;

  const _WalletDropdown({
    required this.label,
    required this.hint,
    required this.wallets,
    required this.selected,
    required this.excluded,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = wallets.where((w) => w != excluded).toList();
    final value = items.contains(selected) ? selected : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Flexible(
                child: Text(
                  _balanceHeader(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        DropdownButtonFormField<Wallet>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.panel2,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.muted, fontSize: 15),
          ),
          icon: const Icon(Icons.expand_more, color: AppColors.muted, size: 20),
          style: const TextStyle(fontSize: 16, color: AppColors.text, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.panel,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
          items: items
              .map((w) => DropdownMenuItem<Wallet>(
                    value: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _walletLabel(w),
                          style: const TextStyle(color: AppColors.text),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _balanceLabel(w),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ))
              .toList(),
          selectedItemBuilder: (context) => items
              .map((w) => Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                          _walletLabel(w),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ))
              .toList(),
          onChanged: (w) {
            if (w != null) onChanged(w);
          },
        ),
      ],
    );
  }

  String _walletLabel(Wallet w) {
    final name = w.name?.trim();
    final code = (w.asset?.trim().isNotEmpty == true
            ? w.asset!
            : (w.symbol ?? ''))
        .trim();
    if (name != null && name.isNotEmpty && code.isNotEmpty && name != code) {
      return '$name ($code)';
    }
    if (name != null && name.isNotEmpty) return name;
    if (code.isNotEmpty) return code;
    return w.id ?? 'Wallet';
  }

  String _balanceHeader() {
    final w = selected;
    if (w == null) return 'Balance: --';
    final balanceText = _balanceLabel(w);
    if (balanceText.isEmpty) return 'Balance: --';
    final code = (w.asset?.trim().isNotEmpty == true
            ? w.asset!
            : (w.symbol ?? ''))
        .trim();
    return code.isEmpty
        ? 'Balance: $balanceText'
        : 'Balance: $balanceText $code';
  }

  String _balanceLabel(Wallet w) {
    final balance = w.balance;
    if (balance == null) return '';
    final formatted = _formatBalance(balance);
    return formatted;
  }

  String _formatBalance(double v) {
    final s = v.toStringAsFixed(8);
    if (!s.contains('.')) return s;
    final trimmed = s.replaceFirst(RegExp(r'0+$'), '');
    final stripped = trimmed.endsWith('.')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
    if (!stripped.contains('.')) return '$stripped.00';
    final decimals = stripped.split('.').last.length;
    return decimals == 1 ? '${stripped}0' : stripped;
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String suffix;
  final ValueChanged<String> onChanged;

  const _AmountField({
    required this.controller,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: onChanged,
      cursorColor: AppColors.accent,
      style: const TextStyle(fontSize: 18, color: AppColors.text, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.panel,
        hintText: '0.00',
        hintStyle: const TextStyle(color: AppColors.muted),
        suffixIcon: suffix.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      suffix,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

class _WalletErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WalletErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.red, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.text, fontSize: 15),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SwapButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.panel2,
        shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.swap_vert, color: AppColors.text, size: 24),
          ),
        ),
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final ExchangeState state;
  const _RateRow({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isRateLoading) {
      return const Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Fetching live rates…',
            style: TextStyle(color: AppColors.muted, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      );
    }
    if (state.rateError != null) {
      return Text(
        state.rateError!,
        style: const TextStyle(color: AppColors.red, fontSize: 14, fontWeight: FontWeight.w500),
      );
    }
    if (state.sourceWallet == null || state.destinationWallet == null) {
      return const SizedBox.shrink();
    }
    if (state.hasRate) {
      final from = state.sourceWallet!.asset ??
          state.sourceWallet!.symbol ??
          '';
      final to = state.destinationWallet!.asset ??
          state.destinationWallet!.symbol ??
          '';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.panel2.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Text(
          '1 $from ≈ ${_fmt(state.rate!)} $to',
          style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _fmt(double v) {
    final s = v.toStringAsFixed(8);
    if (!s.contains('.')) return s;
    final trimmed = s.replaceFirst(RegExp(r'0+$'), '');
    return trimmed.endsWith('.')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }
}

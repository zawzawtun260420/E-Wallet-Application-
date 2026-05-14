import 'dart:math';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Design tokens — keep spacing, radii, and breakpoints consistent everywhere
// ---------------------------------------------------------------------------
class _T {
  // Spacing scale (4pt grid)
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;

  // Radii
  static const double rSm = 8;
  static const double rMd = 12;
  static const double rLg = 16;

  // Breakpoints
  static const double bpTablet = 600;
  static const double bpDesktop = 840;

  // Responsive page padding
  static double pagePadding(double width) {
    if (width < bpTablet) return s4; // mobile: 16
    if (width < bpDesktop) return s5; // tablet: 20
    return s6; // desktop: 24
  }
}

class WalletHistoryPage extends StatelessWidget {
  const WalletHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoldSilver Central - My Wallets',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.panel,
        ),
      ),
      home: const WalletPage(),
    );
  }
}

const double ozToGram = 31.1035;
const List<String> monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatNumber(
    double value, {
      int minDecimals = 2,
      int maxDecimals = 2,
    }) {
  final fixed = value.toStringAsFixed(maxDecimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();

  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }

  var decimals = parts.length > 1 ? parts[1] : '';
  if (maxDecimals > minDecimals) {
    while (decimals.length > minDecimals && decimals.endsWith('0')) {
      decimals = decimals.substring(0, decimals.length - 1);
    }
  }
  if (decimals.isEmpty && minDecimals == 0) return buffer.toString();
  return '${buffer.toString()}.$decimals';
}

String formatShortDate(DateTime date) {
  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}

String formatDateTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${formatShortDate(date)} $hour:$minute';
}

class WalletData {
  const WalletData({
    required this.keyName,
    required this.label,
    required this.amount,
    required this.unit,
    required this.type,
    required this.color,
    this.avgCost,
    this.metal,
    this.custom = false,
    this.verified = false,
  });

  final String keyName;
  final String label;
  final double amount;
  final String unit;
  final String type;
  final Color color;
  final double? avgCost;
  final String? metal;
  final bool custom;
  final bool verified;

  bool get isMetal => type == 'metal';
}

class WalletTransaction {
  const WalletTransaction({
    required this.date,
    required this.asset,
    required this.type,
    required this.typeLabel,
    required this.amount,
    required this.isCredit,
    required this.unit,
    required this.status,
    required this.isMetal,
  });

  final DateTime date;
  final String asset;
  final String type;
  final String typeLabel;
  final double amount;
  final bool isCredit;
  final String unit;
  final String status;
  final bool isMetal;
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final prices = const {
    'gold': 2345.80,
    'silver': 28.45,
    'platinum': 985.20,
  };
  final usdSgd = 1.3485;
  late final List<WalletData> wallets = [
    const WalletData(
      keyName: 'gold',
      label: 'Gold Wallet',
      amount: 3.25,
      unit: 'oz',
      type: 'metal',
      avgCost: 2280.50,
      color: AppColors.gold,
    ),
    const WalletData(
      keyName: 'silver',
      label: 'Silver Wallet',
      amount: 125.50,
      unit: 'oz',
      type: 'metal',
      avgCost: 26.80,
      color: AppColors.silver,
    ),
    const WalletData(
      keyName: 'platinum',
      label: 'Platinum Wallet',
      amount: 1.50,
      unit: 'oz',
      type: 'metal',
      avgCost: 945.00,
      color: AppColors.platinum,
    ),
    const WalletData(
      keyName: 'USD',
      label: 'USD Wallet',
      amount: 12450.00,
      unit: 'USD',
      type: 'fiat',
      color: AppColors.usd,
    ),
    const WalletData(
      keyName: 'SGD',
      label: 'SGD Wallet',
      amount: 8320.50,
      unit: 'SGD',
      type: 'fiat',
      color: AppColors.sgd,
    ),
    const WalletData(
      keyName: 'retirement',
      label: 'Retirement Fund',
      amount: 1.00,
      unit: 'oz',
      type: 'metal',
      avgCost: 2310.00,
      metal: 'gold',
      custom: true,
      verified: true,
      color: AppColors.accent,
    ),
  ];

  String selectedWalletKey = 'gold';
  String filterType = 'all';
  String filterTime = '30';
  DateTime? fromDate;
  DateTime? toDate;

  WalletData get selectedWallet =>
      wallets.firstWhere((w) => w.keyName == selectedWalletKey);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < _T.bpTablet;
    final isWide = width >= _T.bpDesktop;
    final pad = _T.pagePadding(width);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(pad),
          children: [
            _buildHeader(isMobile),
            SizedBox(height: _T.s4),
            _buildWalletCarousel(isMobile),
            SizedBox(height: _T.s4),
            WalletActions(onTap: _showSnack, isMobile: isMobile),
            SizedBox(height: _T.s4),
            AppPanel(
              padding: EdgeInsets.all(isMobile ? _T.s4 : _T.s5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: _T.s3),
                  _buildFilters(isWide, isMobile),
                  SizedBox(height: _T.s3),
                  TransactionList(
                    transactions: _filteredTransactions(),
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header: stack title + button vertically on mobile so the title isn't squeezed
  Widget _buildHeader(bool isMobile) {
    final title = Text(
      'My Wallets',
      style: TextStyle(
        fontSize: isMobile ? 20 : 22,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
      ),
    );

    final button = FilledButton.icon(
      onPressed: () => _showSnack('Create new wallet flow'),
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Create New Wallet'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: _T.s4,
          vertical: _T.s3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_T.rMd),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(alignment: Alignment.centerLeft, child: title),
          SizedBox(height: _T.s3),
          button,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: title),
        button,
      ],
    );
  }

  Widget _buildWalletCarousel(bool isMobile) {
    // Cards on mobile are slightly narrower than the viewport so a peek of the
    // next card is visible (clear scroll affordance). Taller to fit the larger icon.
    final cardWidth = isMobile ? 220.0 : 240.0;
    final cardHeight = isMobile ? 190.0 : 200.0;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: wallets.length,
        separatorBuilder: (_, __) => SizedBox(width: _T.s3),
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          return SizedBox(
            width: cardWidth,
            child: WalletCard(
              wallet: wallet,
              selected: wallet.keyName == selectedWalletKey,
              balance: _walletBalance(wallet),
              value: _walletValue(wallet),
              averageCost: _averageCost(wallet),
              onTap: () => setState(() {
                selectedWalletKey = wallet.keyName;
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(bool isWide, bool isMobile) {
    final typeDropdown = _SelectBox(
      value: filterType,
      items: const {
        'all': 'All Types',
        'deposit': 'Deposit',
        'withdraw': 'Withdraw',
        'exchange': 'Exchange',
        'storage': 'Storage Charge',
        'transfer': 'Transfer',
        'autosave': 'Auto Save Plan',
      },
      onChanged: (value) => setState(() => filterType = value),
    );

    final timeDropdown = _SelectBox(
      value: filterTime,
      items: const {
        '7': 'Past 7 days',
        '30': 'Past 30 days',
        '90': 'Past 90 days',
        'custom': 'Customized',
      },
      onChanged: (value) => setState(() => filterTime = value),
    );

    final dateButtons = filterTime == 'custom'
        ? [
      DateButton(
        label: fromDate == null ? 'From' : formatShortDate(fromDate!),
        onTap: () async {
          final picked = await _pickDate(fromDate);
          if (picked != null) setState(() => fromDate = picked);
        },
      ),
      DateButton(
        label: toDate == null ? 'To' : formatShortDate(toDate!),
        onTap: () async {
          final picked = await _pickDate(toDate);
          if (picked != null) setState(() => toDate = picked);
        },
      ),
    ]
        : <Widget>[];

    final resetBtn = OutlinedButton(
      onPressed: () => setState(() {
        filterType = 'all';
        filterTime = '30';
        fromDate = null;
        toDate = null;
      }),
      style: _filterButtonStyle(),
      child: const Text('Reset'),
    );

    final downloadBtn = OutlinedButton.icon(
      onPressed: () => _showSnack('Download CSV'),
      icon: const Icon(Icons.download, size: 16),
      label: const Text('Download'),
      style: _filterButtonStyle(accent: true),
    );

    // Mobile: dropdowns stretch full-width (one per row), buttons sit side-by-side
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          typeDropdown,
          SizedBox(height: _T.s2),
          timeDropdown,
          if (dateButtons.isNotEmpty) ...[
            SizedBox(height: _T.s2),
            Row(
              children: [
                Expanded(child: dateButtons[0]),
                SizedBox(width: _T.s2),
                Expanded(child: dateButtons[1]),
              ],
            ),
          ],
          SizedBox(height: _T.s3),
          Row(
            children: [
              Expanded(child: resetBtn),
              SizedBox(width: _T.s2),
              Expanded(child: downloadBtn),
            ],
          ),
        ],
      );
    }

    final filters = <Widget>[typeDropdown, timeDropdown, ...dateButtons];
    final buttons = <Widget>[resetBtn, downloadBtn];

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(spacing: _T.s2, runSpacing: _T.s2, children: filters),
          SizedBox(height: _T.s2),
          Wrap(spacing: _T.s2, runSpacing: _T.s2, children: buttons),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Wrap(spacing: _T.s2, runSpacing: _T.s2, children: filters),
        ),
        Wrap(spacing: _T.s2, runSpacing: _T.s2, children: buttons),
      ],
    );
  }

  ButtonStyle _filterButtonStyle({bool accent = false}) {
    return OutlinedButton.styleFrom(
      foregroundColor: accent ? AppColors.accent : AppColors.muted,
      side: BorderSide(
        color: accent ? AppColors.accent.withOpacity(0.35) : AppColors.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_T.rSm),
      ),
      padding: EdgeInsets.symmetric(horizontal: _T.s3, vertical: _T.s2),
    );
  }

  Future<DateTime?> _pickDate(DateTime? initialDate) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(useMaterial3: true), child: child!);
      },
    );
  }

  String _walletBalance(WalletData wallet) {
    if (wallet.isMetal) {
      return '${formatNumber(wallet.amount * ozToGram)} g';
    }
    return '${formatNumber(wallet.amount)} ${wallet.unit}';
  }

  String _walletValue(WalletData wallet) {
    if (wallet.isMetal) {
      final metal = wallet.metal ?? wallet.keyName;
      final value = wallet.amount * (prices[metal] ?? prices['gold']!);
      return '~ ${formatNumber(value, maxDecimals: 2)} USD';
    }
    if (wallet.unit == 'SGD') {
      return '~ ${formatNumber(wallet.amount / usdSgd, maxDecimals: 2)} USD';
    }
    return '';
  }

  String? _averageCost(WalletData wallet) {
    if (wallet.avgCost == null) return null;
    return 'Avg. cost: ${formatNumber(wallet.avgCost! / ozToGram)} USD';
  }

  List<WalletTransaction> _filteredTransactions() {
    final now = DateTime.now();
    Iterable<WalletTransaction> txs = _generateTransactions(selectedWallet);

    if (filterType != 'all') {
      txs = txs.where((tx) => tx.type == filterType);
    }

    if (filterTime == 'custom') {
      if (fromDate != null) {
        txs = txs.where((tx) => !tx.date.isBefore(fromDate!));
      }
      if (toDate != null) {
        final end = DateTime(toDate!.year, toDate!.month, toDate!.day + 1);
        txs = txs.where((tx) => tx.date.isBefore(end));
      }
    } else {
      final days = int.parse(filterTime);
      final cutoff = now.subtract(Duration(days: days));
      txs = txs.where((tx) => !tx.date.isBefore(cutoff));
    }

    return txs.toList();
  }

  List<WalletTransaction> _generateTransactions(WalletData wallet) {
    final seed = wallet.keyName.codeUnits.fold<int>(0, (sum, n) => sum + n);
    final rng = Random(seed);
    final now = DateTime.now();
    const types = ['deposit', 'withdraw', 'exchange', 'storage', 'transfer', 'autosave'];
    const labels = {
      'deposit': 'Deposit',
      'withdraw': 'Withdraw',
      'exchange': 'Exchange',
      'storage': 'Storage Charge',
      'transfer': 'Transfer',
      'autosave': 'Auto Save Plan',
    };
    final asset = wallet.custom
        ? _cap(wallet.metal ?? 'gold')
        : wallet.isMetal
        ? _cap(wallet.keyName)
        : wallet.keyName;

    final txs = List.generate(40, (index) {
      final daysAgo = rng.nextInt(90);
      final date = now
          .subtract(Duration(days: daysAgo))
          .copyWith(hour: 9 + rng.nextInt(8), minute: rng.nextInt(60));
      final type = types[rng.nextInt(types.length)];
      final isCredit = type == 'deposit' ||
          type == 'autosave' ||
          (type == 'exchange' && rng.nextBool()) ||
          (type == 'transfer' && rng.nextBool());
      final amount = wallet.isMetal
          ? double.parse((rng.nextDouble() * 2 + 0.01).toStringAsFixed(4))
          : double.parse((rng.nextDouble() * 500 + 10).toStringAsFixed(2));
      final failed = rng.nextDouble() < 0.06;
      return WalletTransaction(
        date: date,
        asset: asset,
        type: type,
        typeLabel: labels[type]!,
        amount: amount,
        isCredit: isCredit,
        unit: wallet.isMetal ? 'oz' : wallet.keyName == 'SGD' ? r'S$' : r'$',
        status: failed ? 'failed' : 'completed',
        isMetal: wallet.isMetal,
      );
    });
    txs.sort((a, b) => b.date.compareTo(a.date));
    return txs;
  }

  String _cap(String text) => text[0].toUpperCase() + text.substring(1);

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

// ---------------------------------------------------------------------------
// Wallet card — large icon badge + gradient backdrop (mobile-first design)
// ---------------------------------------------------------------------------
class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.wallet,
    required this.selected,
    required this.balance,
    required this.value,
    required this.averageCost,
    required this.onTap,
  });

  final WalletData wallet;
  final bool selected;
  final String balance;
  final String value;
  final String? averageCost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_T.rLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(_T.rLg),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.22),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Subtle radial glow in the asset's color — gives each wallet its own identity
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      wallet.color.withOpacity(0.18),
                      wallet.color.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(_T.s4, _T.s4, _T.s4, _T.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: large icon badge + label + verified pill
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WalletIconBadge(wallet: wallet),
                      SizedBox(width: _T.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallet.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                                height: 1.2,
                              ),
                            ),
                            if (wallet.custom) ...[
                              SizedBox(height: _T.s1),
                              VerifiedBadge(verified: wallet.verified),
                            ] else ...[
                              SizedBox(height: _T.s1),
                              Text(
                                _walletSubtitle(wallet),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.muted,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _T.s3),
                  // Balance — the hero number
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      balance,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: _T.s1),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                  if (averageCost != null) ...[
                    SizedBox(height: _T.s1),
                    Text(
                      averageCost!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Asset code shown under the wallet name (Au, Ag, Pt, USD, SGD)
  String _walletSubtitle(WalletData wallet) {
    switch (wallet.keyName) {
      case 'gold':
        return 'AU • PRECIOUS METAL';
      case 'silver':
        return 'AG • PRECIOUS METAL';
      case 'platinum':
        return 'PT • PRECIOUS METAL';
      case 'USD':
        return 'US DOLLAR';
      case 'SGD':
        return 'SINGAPORE DOLLAR';
      default:
        return wallet.unit.toUpperCase();
    }
  }
}

// ---------------------------------------------------------------------------
// Large circular icon badge — the visual anchor of each wallet card
// ---------------------------------------------------------------------------
class WalletIconBadge extends StatelessWidget {
  const WalletIconBadge({
    super.key,
    required this.wallet,
    this.size = 52,
  });

  final WalletData wallet;
  final double size;

  @override
  Widget build(BuildContext context) {
    final glyph = _glyphFor(wallet);
    final color = wallet.color;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Gradient gives the badge depth — top-light, bottom-deep
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: wallet.custom
              ? [
            AppColors.gold.withOpacity(0.85),
            AppColors.accent.withOpacity(0.85),
          ]
              : [
            color.withOpacity(0.28),
            color.withOpacity(0.12),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: glyph.isText
            ? Text(
          glyph.text!,
          style: TextStyle(
            fontSize: size * 0.40,
            fontWeight: FontWeight.w800,
            color: wallet.custom ? Colors.white : color,
            letterSpacing: -0.5,
            height: 1,
          ),
        )
            : Icon(
          glyph.icon,
          size: size * 0.50,
          color: wallet.custom ? Colors.white : color,
        ),
      ),
    );
  }

  _Glyph _glyphFor(WalletData wallet) {
    if (wallet.custom) {
      // Retirement / custom wallets: shield icon to imply protection
      return const _Glyph.icon(Icons.shield_outlined);
    }
    switch (wallet.keyName) {
      case 'gold':
        return const _Glyph.text('Au');
      case 'silver':
        return const _Glyph.text('Ag');
      case 'platinum':
        return const _Glyph.text('Pt');
      case 'USD':
        return const _Glyph.text(r'$');
      case 'SGD':
        return const _Glyph.text(r'S$');
      default:
        return const _Glyph.icon(Icons.account_balance_wallet_outlined);
    }
  }
}

class _Glyph {
  const _Glyph.text(String this.text) : icon = null;
  const _Glyph.icon(IconData this.icon) : text = null;

  final String? text;
  final IconData? icon;

  bool get isText => text != null;
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, required this.verified});

  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _T.s2 - 1, vertical: 3),
      decoration: BoxDecoration(
        color: (verified ? AppColors.green : AppColors.red).withOpacity(0.12),
        borderRadius: BorderRadius.circular(_T.rSm / 2),
      ),
      child: Text(
        verified ? 'Verified' : 'Unverified',
        style: TextStyle(
          color: verified ? AppColors.green : AppColors.red,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wallet actions — responsive grid (2 cols on mobile, 4 on tablet, 7 on wide)
// ---------------------------------------------------------------------------
class WalletActions extends StatelessWidget {
  const WalletActions({
    super.key,
    required this.onTap,
    required this.isMobile,
  });

  final ValueChanged<String> onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    const actions = <(IconData, String)>[
      (Icons.south, 'Deposit'),
      (Icons.swap_horiz, 'Transfer'),
      (Icons.payments_outlined, 'Convert'),
      (Icons.edit_outlined, 'Edit'),
      (Icons.send_outlined, 'Send'),
      (Icons.north, 'Withdraw'),
      (Icons.cancel_outlined, 'Close'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Column count by available width — avoids the "orphan tile" problem
        final int cols;
        if (constraints.maxWidth < 400) {
          cols = 4; // small phones: compact 4-col grid (1 row of 4 + 1 row of 3)
        } else if (constraints.maxWidth < _T.bpTablet) {
          cols = 4;
        } else if (constraints.maxWidth < _T.bpDesktop) {
          cols = 4;
        } else {
          cols = 7; // wide: all in a single row
        }

        const spacing = _T.s2;
        final tileWidth =
            (constraints.maxWidth - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: actions.map((action) {
            return SizedBox(
              width: tileWidth,
              child: _ActionTile(
                icon: action.$1,
                label: action.$2,
                onTap: () => onTap(action.$2),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_T.rSm),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: _T.s2, vertical: _T.s3),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(_T.rSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.panel2,
                borderRadius: BorderRadius.circular(_T.rSm),
              ),
              child: Icon(icon, size: 18, color: AppColors.muted),
            ),
            SizedBox(height: _T.s2 - 2),
            Text(
              label,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transaction list — card layout on mobile, DataTable on tablet+
// This is the biggest mobile UX win: no more horizontal scroll on a phone.
// ---------------------------------------------------------------------------
class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.isMobile,
  });

  final List<WalletTransaction> transactions;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(_T.s5),
        child: const Center(
          child: Text(
            'No transactions found',
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      );
    }

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < transactions.length; i++) ...[
            _TransactionCard(tx: transactions[i]),
            if (i < transactions.length - 1) SizedBox(height: _T.s2),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        dataTextStyle: const TextStyle(color: AppColors.text, fontSize: 13),
        dividerThickness: 0.7,
        columns: const [
          DataColumn(label: Text('Date & Time')),
          DataColumn(label: Text('Asset')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Status')),
        ],
        rows: transactions.map((tx) {
          final sign = tx.isCredit ? '+' : '-';
          final amount = tx.isMetal
              ? '$sign${tx.amount} ${tx.unit}'
              : '$sign${tx.unit}${formatNumber(tx.amount)}';
          return DataRow(
            cells: [
              DataCell(Text(formatDateTime(tx.date))),
              DataCell(Text(tx.asset)),
              DataCell(Text(tx.typeLabel)),
              DataCell(Text(
                amount,
                style: TextStyle(
                  color: tx.isCredit ? AppColors.green : AppColors.red,
                  fontWeight: FontWeight.w700,
                ),
              )),
              DataCell(StatusBadge(status: tx.status)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.tx});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final sign = tx.isCredit ? '+' : '-';
    final amount = tx.isMetal
        ? '$sign${tx.amount} ${tx.unit}'
        : '$sign${tx.unit}${formatNumber(tx.amount)}';

    return Container(
      padding: EdgeInsets.all(_T.s3),
      decoration: BoxDecoration(
        color: AppColors.panel2,
        borderRadius: BorderRadius.circular(_T.rSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.typeLabel,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: _T.s1 / 2),
                    Text(
                      '${tx.asset} • ${formatDateTime(tx.date)}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: _T.s2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      color: tx.isCredit ? AppColors.green : AppColors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: _T.s1 / 2),
                  StatusBadge(status: tx.status),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final completed = status == 'completed';
    final color = completed ? AppColors.green : AppColors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _T.s2, vertical: _T.s1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(_T.rSm / 2),
      ),
      child: Text(
        completed ? 'Completed' : 'Failed',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(_T.s5),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(_T.rMd),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: _T.s3),
      decoration: BoxDecoration(
        color: AppColors.panel2,
        borderRadius: BorderRadius.circular(_T.rSm),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true, // critical for mobile: fills available width
          dropdownColor: AppColors.panel2,
          icon: const Icon(
            Icons.expand_more,
            size: 18,
            color: AppColors.muted,
          ),
          style: const TextStyle(color: AppColors.text, fontSize: 13),
          items: items.entries
              .map((entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

class DateButton extends StatelessWidget {
  const DateButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.calendar_month, size: 16),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.border),
        backgroundColor: AppColors.panel2,
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_T.rSm),
        ),
      ),
    );
  }
}

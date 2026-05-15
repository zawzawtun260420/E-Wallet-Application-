import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/signup.dart';

// ---------------------------------------------------------------------------
// Design tokens — kept in sync with wallet_page.dart and settings.dart
// ---------------------------------------------------------------------------
class _T {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;

  static const double rSm = 8;
  static const double rMd = 12;
  static const double rLg = 16;
  static const double rXl = 20;

  static const double bpTablet = 600;
  static const double bpDesktop = 840;

  static double pagePadding(double width) {
    if (width < bpTablet) return s4;
    if (width < bpDesktop) return s5;
    return s6;
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _balanceVisible = true;

  final List<Map<String, String>> users = const [
    {'name': 'Add New', 'image': 'assets/image/add.png'},
    {'name': 'Alexandria', 'image': 'assets/image/image1.png'},
    {'name': 'Immanuel', 'image': 'assets/image/image2.png'},
    {'name': 'Kayshania', 'image': 'assets/image/image3.png'},
    {'name': 'Ande', 'image': 'assets/image/image4.jpg'},
  ];

  // Transactions — one `amount` per map, kept as double for proper currency math
  final List<Map<String, dynamic>> transactions = const [
    {
      'title': 'Transfer',
      'date': 'Yesterday · 19:12',
      'amount': -60.00,
      'currency': 'SGD',
      'icon': Icons.swap_horiz,
      'color': Colors.red,
    },
    {
      'title': 'Top Up',
      'date': 'May 29, 2023 · 19:12',
      'amount': 1500.00,
      'currency': 'USD',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'title': 'Internet',
      'date': 'May 16, 2023 · 17:34',
      'amount': -35.50,
      'currency': 'SGD',
      'icon': Icons.wifi,
      'color': Colors.red,
    },
    {
      'title': 'Work history',
      'date': 'May 13, 2022 · 17:34',
      'amount': 450.00,
      'currency': 'EUR',
      'icon': Icons.work_history,
      'color': Colors.green,
    },
    {
      'title': 'Bills',
      'date': 'May 13, 2022 · 17:34',
      'amount': -67.20,
      'currency': 'SGD',
      'icon': Icons.receipt_long,
      'color': Colors.red,
    },
    {
      'title': 'Balance',
      'date': 'May 13, 2022 · 17:34',
      'amount': 450.00,
      'currency': 'GBP',
      'icon': Icons.balance,
      'color': Colors.green,
    },
  ];

  String _formatAmount(double amount, String currency) {
    // Thousands separator + 2 decimals
    final fixed = amount.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]},',
    );
    final body = '$currency $whole.${parts[1]}';
    return amount < 0 ? '-$body' : body;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < _T.bpTablet;
    final pad = _T.pagePadding(width);

    // Constrain content width on tablet/desktop so it doesn't stretch wide
    final maxWidth = isMobile ? double.infinity : 720.0;

    return Scaffold(
      backgroundColor: Background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    balance: 24321.90,
                    balanceVisible: _balanceVisible,
                    onToggleBalance: () => setState(() {
                      _balanceVisible = !_balanceVisible;
                    }),
                    isMobile: isMobile,
                    pad: pad,
                    onTransfer: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Signup()),
                      );
                    },
                  ),
                  SizedBox(height: _T.s4),
                  _SectionTitle(
                    title: 'Send again',
                    onSeeAll: () {},
                    pad: pad,
                  ),
                  SizedBox(height: _T.s3),
                  _SendAgainList(users: users, pad: pad, isMobile: isMobile),
                  SizedBox(height: _T.s4),
                  _SectionTitle(
                    title: 'Latest Transaction',
                    onSeeAll: () {},
                    pad: pad,
                  ),
                  SizedBox(height: _T.s2),
                  _TransactionsList(
                    transactions: transactions,
                    formatAmount: _formatAmount,
                    pad: pad,
                  ),
                  // Bottom spacer that respects the system gesture area
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + _T.s4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header — colored top with logo, points, balance, and quick-actions card
// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header({
    required this.balance,
    required this.balanceVisible,
    required this.onToggleBalance,
    required this.isMobile,
    required this.pad,
    required this.onTransfer,
  });

  final double balance;
  final bool balanceVisible;
  final VoidCallback onToggleBalance;
  final bool isMobile;
  final double pad;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    // The actions card overhangs the header by ~25px — we add that to the
    // stack's bottom margin so the card sits half on header / half on body.
    const overhang = 25.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Colored header background with rounded bottom
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: btntxt,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.elliptical(300, 40),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            pad,
            _T.s4,
            pad,
            _T.s6 + overhang + _T.s3, // leave room for overhanging card
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _topBar(),
              SizedBox(height: _T.s5),
              const Text(
                'Your Balance',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(height: _T.s2),
              _balanceRow(),
            ],
          ),
        ),
        // Quick-actions card — overhangs the header
        Positioned(
          left: pad,
          right: pad,
          bottom: -overhang,
          child: _QuickActions(onTransfer: onTransfer),
        ),
        // Spacer so siblings below account for the overhanging card
        Positioned(
          left: 0,
          right: 0,
          bottom: -overhang - _T.s2,
          child: const SizedBox(height: overhang + _T.s2),
        ),
      ],
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand title — using RichText since we want two-tone styling later if needed
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
              children: [
                TextSpan(text: 'GBNX '),
                TextSpan(
                  text: 'Digital App',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: _T.s2),
        // Points pill — sizes to its content rather than fixed 130px
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: _T.s3,
            vertical: _T.s2 - 2,
          ),
          decoration: BoxDecoration(
            color: Background,
            borderRadius: BorderRadius.circular(_T.rXl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Color(0xFFffa41c), size: 18),
              SizedBox(width: _T.s1 + 2),
              const Text(
                '1,972 Points',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _balanceRow() {
    final fixed = balance.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]},',
    );
    final display = balanceVisible ? 'SGD $whole.${parts[1]}' : 'SGD ••••••';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              display,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        SizedBox(width: _T.s2),
        InkWell(
          onTap: onToggleBalance,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(_T.s1),
            child: Icon(
              balanceVisible
                  ? Icons.remove_red_eye_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Quick-actions card — Transfer / Top Up / Withdraw / More
// Uses Expanded children so the 4 actions split the row width evenly on any phone
// ---------------------------------------------------------------------------
class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onTransfer});

  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    final actions = <_ActionData>[
      _ActionData(
        icon: Icons.swap_horiz_rounded,
        label: 'Transfer',
        asset: 'assets/image/transfer 1.png',
        onTap: onTransfer,
      ),
      _ActionData(
        icon: Icons.south_rounded,
        label: 'Top Up',
        asset: 'assets/image/icon-wtihdraw.png',
        onTap: () {},
      ),
      _ActionData(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Withdraw',
        asset: 'assets/image/icon-wallet.png',
        onTap: () {},
      ),
      _ActionData(
        icon: Icons.more_horiz_rounded,
        label: 'More',
        asset: 'assets/image/icon-more.png',
        onTap: () {},
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: _T.s3, horizontal: _T.s2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_T.rLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final a in actions)
            Expanded(child: _ActionTile(data: a)),
        ],
      ),
    );
  }
}

class _ActionData {
  _ActionData({
    required this.icon,
    required this.label,
    required this.asset,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String asset;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.data});

  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(_T.rSm),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _T.s2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Try asset first; fall back to Material icon if it fails to load.
            // This keeps the screen usable even if the asset isn't bundled.
            SizedBox(
              width: 28,
              height: 28,
              child: Image.asset(
                data.asset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(data.icon, size: 24, color: btntxt),
              ),
            ),
            SizedBox(height: _T.s2 - 2),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
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
// Section title with "See all" link
// ---------------------------------------------------------------------------
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.onSeeAll,
    required this.pad,
  });

  final String title;
  final VoidCallback onSeeAll;
  final double pad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            borderRadius: BorderRadius.circular(_T.rSm),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _T.s1,
                vertical: _T.s1,
              ),
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: const Color(0xFF059e8c),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: _T.s1),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF059e8c),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Horizontal contacts list — sizes avatars based on screen width
// ---------------------------------------------------------------------------
class _SendAgainList extends StatelessWidget {
  const _SendAgainList({
    required this.users,
    required this.pad,
    required this.isMobile,
  });

  final List<Map<String, String>> users;
  final double pad;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final avatarSize = isMobile ? 60.0 : 70.0;
    final itemHeight = avatarSize + 30; // avatar + label

    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: pad),
        itemCount: users.length,
        separatorBuilder: (_, __) => SizedBox(width: _T.s3),
        itemBuilder: (context, index) {
          final user = users[index];
          final isAdd = index == 0;
          return SizedBox(
            width: avatarSize,
            child: Column(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAdd ? Colors.purple.withOpacity(0.12) : null,
                    image: isAdd
                        ? null
                        : DecorationImage(
                      image: AssetImage(user['image']!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: isAdd
                      ? const Icon(
                    Icons.add_rounded,
                    color: Colors.purple,
                    size: 28,
                  )
                      : null,
                ),
                SizedBox(height: _T.s1 + 2),
                Text(
                  user['name']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transactions list — uses ListTile-style rows but with proper formatting
// ---------------------------------------------------------------------------
class _TransactionsList extends StatelessWidget {
  const _TransactionsList({
    required this.transactions,
    required this.formatAmount,
    required this.pad,
  });

  final List<Map<String, dynamic>> transactions;
  final String Function(double, String) formatAmount;
  final double pad;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: pad),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => SizedBox(height: _T.s1),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final amount = tx['amount'] as double;
        final currency = tx['currency'] as String;
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(_T.rMd),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: _T.s2),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(_T.rMd),
                  ),
                  child: Icon(
                    tx['icon'] as IconData,
                    color: Colors.purple,
                    size: 22,
                  ),
                ),
                SizedBox(width: _T.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: _T.s1 - 2),
                      Text(
                        tx['date'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: _T.s2),
                Text(
                  formatAmount(amount, currency),
                  style: TextStyle(
                    color: tx['color'] as Color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
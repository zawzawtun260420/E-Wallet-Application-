import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:projectapp/theme/app_colors.dart';
import 'package:projectapp/screen/login.dart';

// ---------------------------------------------------------------------------
// Design tokens — must stay in sync with wallet_page.dart for visual consistency
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
    if (width < bpTablet) return s4;
    if (width < bpDesktop) return s5;
    return s6;
  }
}

// ---------------------------------------------------------------------------
// Settings item model — drives both the tile UI and the detail page routing
// ---------------------------------------------------------------------------
class _SettingsItem {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingValue,
    this.badgeCount,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingValue; // e.g. "English", "Dark"
  final int? badgeCount;        // e.g. 3 unread notifications
  final Color? iconColor;
}
=======
import 'package:projectapp/constant/colours.dart';
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < _T.bpTablet;
    final pad = _T.pagePadding(width);

    // Constrain content width on tablets/desktop so the layout doesn't stretch
    final maxContentWidth = isMobile ? double.infinity : 640.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(pad, _T.s2, pad, _T.s6),
              children: [
                _ProfileCard(
                  name: 'Alexandria Putri',
                  email: 'alexandria@email.com',
                  imagePath: 'assets/image/image1.png',
                  onEdit: () => _openDetail(
                    context,
                    title: 'Edit Profile',
                    icon: Icons.edit_outlined,
                  ),
                ),
                SizedBox(height: _T.s5),
                const _SectionHeader(title: 'Account'),
                SizedBox(height: _T.s2),
                _SectionPanel(
                  items: const [
                    _SettingsItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      subtitle: 'Name, phone, address, date of birth',
                    ),
                    _SettingsItem(
                      icon: Icons.verified_user_outlined,
                      title: 'KYC Verification',
                      subtitle: 'Identity documents and verification status',
                      trailingValue: 'Tier 2',
                    ),
                    _SettingsItem(
                      icon: Icons.security_rounded,
                      title: 'Security & Privacy',
                      subtitle: 'Password, 2FA, biometric login',
                      trailingValue: '2FA on',
                    ),
                    _SettingsItem(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Login',
                      subtitle: 'Use fingerprint or Face ID to sign in',
                      trailingValue: 'On',
                    ),
                    _SettingsItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      subtitle: 'Price alerts, transactions, marketing',
                      badgeCount: 3,
                    ),
                  ],
                  onTap: (item) => _openDetail(
                    context,
                    title: item.title,
                    icon: item.icon,
                  ),
                ),
                SizedBox(height: _T.s5),
                const _SectionHeader(title: 'Trading & Wallets'),
                SizedBox(height: _T.s2),
                _SectionPanel(
                  items: const [
                    _SettingsItem(
                      icon: Icons.notifications_active_outlined,
                      title: 'Price Alerts',
                      subtitle: 'Manage your active price notifications',
                      trailingValue: '5 active',
                    ),
                    _SettingsItem(
                      icon: Icons.event_repeat_rounded,
                      title: 'Auto Save Plans',
                      subtitle: 'Recurring purchases and scheduled buys',
                      trailingValue: '2 active',
                    ),
                    _SettingsItem(
                      icon: Icons.tune_rounded,
                      title: 'Trading Preferences',
                      subtitle: 'Default order type and confirmation prompts',
                    ),
                    _SettingsItem(
                      icon: Icons.warehouse_outlined,
                      title: 'Storage & Delivery',
                      subtitle: 'Vault location and physical delivery address',
                      trailingValue: 'Singapore',
                    ),
                  ],
                  onTap: (item) => _openDetail(
                    context,
                    title: item.title,
                    icon: item.icon,
                  ),
                ),
                SizedBox(height: _T.s5),
                const _SectionHeader(title: 'Financial'),
                SizedBox(height: _T.s2),
                _SectionPanel(
                  items: const [
                    _SettingsItem(
                      icon: Icons.attach_money_rounded,
                      title: 'Display Currency',
                      subtitle: 'Default fiat currency for values',
                      trailingValue: 'SGD',
                    ),
                    _SettingsItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Statements & Reports',
                      subtitle: 'Transaction history and tax documents',
                    ),
                  ],
                  onTap: (item) => _openDetail(
                    context,
                    title: item.title,
                    icon: item.icon,
                  ),
                ),
                SizedBox(height: _T.s5),
                const _SectionHeader(title: 'App'),
                SizedBox(height: _T.s2),
                _SectionPanel(
                  items: const [
                    _SettingsItem(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: 'Display language for the app',
                      trailingValue: 'English',
                    ),
                    _SettingsItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Theme Mode',
                      subtitle: 'Light, dark, or system default',
                      trailingValue: 'Dark',
                    ),
                    _SettingsItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                      subtitle: 'FAQs, contact support, report issue',
                    ),
                    _SettingsItem(
                      icon: Icons.gavel_rounded,
                      title: 'Legal',
                      subtitle: 'Terms of service and privacy policy',
                    ),
                    _SettingsItem(
                      icon: Icons.info_outline_rounded,
                      title: 'About',
                      subtitle: 'App version and licenses',
                      trailingValue: 'v1.0.0',
                    ),
                  ],
                  onTap: (item) => _openDetail(
                    context,
                    title: item.title,
                    icon: item.icon,
                  ),
                ),
                SizedBox(height: _T.s6),
                _LogoutButton(
                  onPressed: () => _confirmLogout(context),
                ),
                SizedBox(height: _T.s3),
                const Center(
                  child: Text(
                    'v1.0.0  •  GoldSilver Central',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // Routing helpers
  // ------------------------------------------------------------------
  void _openDetail(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsDetailPage(title: title, icon: icon),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_T.rMd),
          ),
          title: const Text(
            'Log out?',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'You will need to sign in again to access your wallets.',
            style: TextStyle(color: AppColors.muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_T.rSm),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                      (route) => false,
                );
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Profile card — matches AppPanel styling from wallet page
// ---------------------------------------------------------------------------
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.email,
    required this.imagePath,
    required this.onEdit,
  });

  final String name;
  final String email;
  final String imagePath;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_T.s4),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(_T.rLg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with gradient ring — visual anchor matching wallet icon badges
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.gold, AppColors.accent],
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.panel2,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          SizedBox(width: _T.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: _T.s1),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: _T.s2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _T.s2,
                    vertical: _T.s1 - 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(_T.rSm / 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 12,
                        color: AppColors.green,
                      ),
                      SizedBox(width: _T.s1),
                      const Text(
                        'Verified',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: _T.s2),
          // Edit button — consistent with action tiles
          Material(
            color: AppColors.panel2,
            borderRadius: BorderRadius.circular(_T.rSm),
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(_T.rSm),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_T.rSm),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.accent,
                  size: 18,
                ),
              ),
            ),
=======
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 30),
          const Text("Account Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _settingsTile(Icons.person_outline, "Personal Information"),
          _settingsTile(Icons.security_rounded, "Security & Privacy"),
          _settingsTile(Icons.notifications_none_rounded, "Notifications"),
          const SizedBox(height: 30),
          const Text("App Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _settingsTile(Icons.language_rounded, "Language"),
          _settingsTile(Icons.dark_mode_outlined, "Theme Mode"),
          _settingsTile(Icons.help_outline_rounded, "Help Center"),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Handle Logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              foregroundColor: Colors.redAccent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/image/image1.png'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Alexandria Putri", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("alexandria@email.com", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: btn),
            onPressed: () {},
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}

// ---------------------------------------------------------------------------
// Section header — matches the "Transaction History" treatment on wallet page
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _T.s1),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section panel — groups related tiles in a single bordered container
// (standard iOS/Android settings pattern)
// ---------------------------------------------------------------------------
class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.items,
    required this.onTap,
  });

  final List<_SettingsItem> items;
  final ValueChanged<_SettingsItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(_T.rMd),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _SettingsTile(
              item: items[i],
              onTap: () => onTap(items[i]),
            ),
            if (i < items.length - 1)
              Padding(
                padding: EdgeInsets.only(left: _T.s4 + 40 + _T.s3),
                child: const Divider(
                  height: 1,
                  thickness: 0.6,
                  color: AppColors.border,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings tile — title + subtitle + optional trailing value/badge
// ---------------------------------------------------------------------------
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.item,
    required this.onTap,
  });

  final _SettingsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _T.s4,
          vertical: _T.s3,
        ),
        child: Row(
          children: [
            // Icon badge — same visual language as wallet action tiles
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.panel2,
                borderRadius: BorderRadius.circular(_T.rSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor ?? AppColors.text,
                size: 20,
              ),
            ),
            SizedBox(width: _T.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: _T.s1 - 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: _T.s2),
            if (item.badgeCount != null && item.badgeCount! > 0)
              Container(
                margin: EdgeInsets.only(right: _T.s2),
                padding: EdgeInsets.symmetric(
                  horizontal: _T.s2,
                  vertical: 2,
                ),
                constraints: const BoxConstraints(minWidth: 20),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${item.badgeCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            else if (item.trailingValue != null)
              Padding(
                padding: EdgeInsets.only(right: _T.s2),
                child: Text(
                  item.trailingValue!,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logout button — outlined, soft red, matching the wallet page button language
// ---------------------------------------------------------------------------
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.logout_rounded, size: 18),
      label: const Text(
        'Log out',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.red,
        side: BorderSide(color: AppColors.red.withOpacity(0.4)),
        backgroundColor: AppColors.red.withOpacity(0.06),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_T.rMd),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable detail page — every settings item routes here.
// Replace the body with the actual feature UI as those screens are built.
// ---------------------------------------------------------------------------
class SettingsDetailPage extends StatelessWidget {
  const SettingsDetailPage({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final pad = _T.pagePadding(width);
    final isMobile = width < _T.bpTablet;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 640,
            ),
            child: ListView(
              padding: EdgeInsets.all(pad),
              children: [
                // Detail page header — same icon-badge motif as wallet/settings cards
                Container(
                  padding: EdgeInsets.all(_T.s4),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(_T.rLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.accent.withOpacity(0.28),
                              AppColors.accent.withOpacity(0.12),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.45),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(icon,
                            color: AppColors.accent, size: 24),
                      ),
                      SizedBox(width: _T.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: _T.s1),
                            const Text(
                              'Manage your preferences for this section',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _T.s4),
                // Placeholder content — replace with the real screen body
                Container(
                  padding: EdgeInsets.all(_T.s5),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(_T.rMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Coming Soon',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: _T.s2),
                      Text(
                        'The "$title" screen will live here. Build the real UI '
                            'in this widget — the routing and design wrapper are '
                            'already wired up.',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
=======

  Widget _settingsTile(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
    );
  }
}

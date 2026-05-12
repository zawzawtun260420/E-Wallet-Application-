import 'package:flutter/material.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Background,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'GBNX ', style: TextStyle(color: btn)),
              const TextSpan(text: 'Digital App', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 30),
            _buildSectionHeader("My Wallets", () {}),
            const SizedBox(height: 15),
            _buildWalletsList(), // Increased size for better appearance
            const SizedBox(height: 30),
            _buildSectionHeader("My Saving Plans", () {}),
            const SizedBox(height: 15),
            _buildSavingPlans(),
            const SizedBox(height: 30),
            _buildQuickActions(), // Moved under My Saving Plans
            const SizedBox(height: 30),
            _buildSectionHeader("Storage Charges", () {}),
            const SizedBox(height: 15),
            _buildStorageChargesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: btn,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: btn.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "SGD 45,250.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 5),
              const Text("+2.5% this month", style: TextStyle(color: Colors.greenAccent)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(Icons.send_rounded, "Send"),
        _actionItem(Icons.account_balance_wallet_rounded, "Receive"),
        _actionItem(Icons.currency_exchange_rounded, "Exchange"),
      ],
    );
  }

  Widget _actionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: btn, size: 28),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: Text("See All", style: TextStyle(color: btn)),
        ),
      ],
    );
  }

  Widget _buildWalletsList() {
    return SizedBox(
      height: 170, // Increased height for larger rectangles
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _walletCard(
            "Gold Wallet",
            "SGD 32,000",
            [const Color(0xFFFFD700), const Color(0xFFFFA500)],
            Icons.stars_rounded,
          ),
          _walletCard(
            "Silver Wallet",
            "SGD 8,000",
            [const Color(0xFFC0C0C0), const Color(0xFFA9A9A9)],
            Icons.monetization_on_rounded,
          ),
          _walletCard(
            "Platinum Wallet",
            "SGD 5,250",
            [const Color(0xFFE5E4E2), const Color(0xFFB7B7B7)],
            Icons.workspace_premium_rounded,
          ),
        ],
      ),
    );
  }

  Widget _walletCard(String name, String balance, List<Color> colors, IconData icon) {
    return Container(
      width: 333, // Increased width by 33px for an even wider look
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35), // Even more rounded for a modern look
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const Icon(Icons.more_horiz, color: Colors.white70, size: 24),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                balance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingPlans() {
    return Column(
      children: [
        _savingPlanTile("Retirement Fund", 0.65, "SGD 12,000 / 20,000", Colors.orange),
        _savingPlanTile("New Car", 0.40, "SGD 8,000 / 20,000", Colors.blue),
      ],
    );
  }

  Widget _savingPlanTile(String title, double progress, String detail, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: color,
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(detail, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageChargesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storage_rounded, color: Colors.redAccent),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Monthly Storage Fee", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("SGD 5.00 due on 1st Oct", style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: btn,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Pay", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

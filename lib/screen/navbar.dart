import 'package:flutter/material.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/exchange.dart';
import 'package:projectapp/screen/dashboard.dart';
import 'package:projectapp/screen/settings.dart';
import 'package:projectapp/screen/wallet_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentvalue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentvalue,
        onTap: (value) {
          setState(() {
            currentvalue = value;
          });
        },
        type: BottomNavigationBarType.fixed, // Added for better layout with 4 items
        selectedItemColor: btntxt,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: "Exchange"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: "My Wallets"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  getCurrentView() {
    if (currentvalue == 0) {
      return const DashboardPage();
    } else if (currentvalue == 1) {
      return const Exchange();
    } else if (currentvalue == 2) {
      return const WalletPage();
    } else if (currentvalue == 3) {
      return const SettingsPage();
    } else {
      return const Center(
          child: Text("Page Not Found", style: TextStyle(fontSize: 20)));
    }
  }
}

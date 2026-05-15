import 'package:flutter/material.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/exchange.dart';
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: btntxt,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows_rounded), label: "Exchange"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: "My Wallets"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
      ),
    );
  }

  Widget getCurrentView() {
    switch (currentvalue) {
      case 0:
        return const Exchange();
      case 1:
        return const Exchange();
      case 2:
        return const WalletPage();
      case 3:
        return const SettingsPage();
      default:
        return const Center(child: Text("Page Not Found"));
    }
  }
}

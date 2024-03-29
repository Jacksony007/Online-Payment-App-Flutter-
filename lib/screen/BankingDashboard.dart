import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/screen/BankingPaymentHistory.dart';
import '../utils/BankingBottomNavigationBar.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingImages.dart';
import '../utils/BankingStrings.dart';
import 'BankingHome1.dart';
import '../Settings/BankingMenu.dart';
import '../General Payment/BankingQrCodeScanner.dart';
import 'BankingTransfer.dart';

class BankingDashboard extends StatefulWidget {
  static var tag = "/BankingDashboard";

  const BankingDashboard({Key? key}) : super(key: key);

  @override
  _BankingDashboardState createState() => _BankingDashboardState();
}

class _BankingDashboardState extends State<BankingDashboard> {
  var selectedIndex = 0;
  var pages = [
    BankingHome1(),
    const BankingTransfer(),
    const QRScannerPage(),
    const BankingHistoryPage(),
    const BankingMenu(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Banking_app_Background,
          bottomNavigationBar: BankingBottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Banking_greyColor.withOpacity(0.5),
            items: const <BankingBottomNavigationBarItem>[
              BankingBottomNavigationBarItem(
                  icon: Banking_ic_Home, title: Text(Banking_lbl_Home)),
              BankingBottomNavigationBarItem(
                  icon: Banking_ic_Transfer, title: Text(Banking_lbl_Transfer)),
              BankingBottomNavigationBarItem(
                  icon: Banking_ic_QRCode, title: Text(Banking_lbl_Scan)),
              BankingBottomNavigationBarItem(
                  icon: Banking_ic_HistoryIcon,
                  title: Text(Banking_lbl_History)),
              BankingBottomNavigationBarItem(
                  icon: Banking_ic_Settings, title: Text(Banking_lbl_Setting)),
            ],
            currentIndex: selectedIndex,
            unselectedIconTheme: IconThemeData(
                color: Banking_greyColor.withOpacity(0.5), size: 28),
            selectedIconTheme:
                const IconThemeData(color: Colors.blue, size: 28),
            onTap: _onItemTapped,
            type: BankingBottomNavigationBarType.fixed,
          ),
          body: SafeArea(
            child: pages[selectedIndex],
          ),
        ),
      ),
    );
  }
}

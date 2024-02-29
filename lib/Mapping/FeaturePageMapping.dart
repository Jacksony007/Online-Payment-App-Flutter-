import 'package:flutter/material.dart';
import '../Auth Services/AuthServices.dart';
import '../Controller/UserDetails.dart';
import '../General Payment/BalancePin.dart';
import '../Inner Screen/AmountEntryScreen.dart';
import '../General Payment/BankingPayByUpi.dart';
import '../General Payment/BankingPayToContact.dart';
import '../General Payment/BankingPayToPhoneNumber.dart';
import '../Insurance/FamilyInsurancePage.dart';
import '../Mobile Recharge/MobileRecharge.dart';
import '../Pay Bills/DvlaPage.dart';
import '../Transport/BusBookingPage.dart';
import '../Transport/FlightBookingPage.dart';
import '../Pay Bills/PayElectricBill.dart';
import '../Pay Bills/UniversitySelectionPage.dart';
import '../Transport/RiderBookingPage.dart';
import '../Transport/TrainBookingPage.dart';
import '../Transport/UberBookingPage.dart';
import '../User Model/user_financial_model.dart';
import '../utils/BankingFeaturedItems.dart';

class FeaturePageMapping {
  static AuthService _authService = AuthService();

  static const Map<String, Widget> pageMap = {
    // General Payment Mapping
    'Scan To Pay': AmountEntryScreen(companyName: 'demo'),
    'Pay to Contact': PayToContactPage(),
    'Pay to PhoneNumber': PayToPhoneNumberPage(),
    'Pay to UPI': PayToUpiPage(),

    // Bill Payment Mapping
    'Fees': UniversitySelectionPage(),
    'Electricity': MeterVerificationPage(title: 'Electricity Bill'),
    'Water': MeterVerificationPage(title: 'Water Bill'),
    'DVLA': DvlaPage(),

    // Mobile Recharge Mapping
    'Tigo': MobileRechargeScreen(title: 'Tigo'),
    'Airtel': MobileRechargeScreen(title: 'Airtel'),
    'Vodacom': MobileRechargeScreen(title: 'Vodacom'),
    'Jio': MobileRechargeScreen(title: 'Jio'),
    'MTN': MobileRechargeScreen(title: 'MTN'),
    'Glo': MobileRechargeScreen(title: 'Glo'),

    // Insurance Mapping
    'Family Insurance': FamilyInsurancePage(),

    // Transport Mapping
    'Flight Ticket': FlightBookingPage(),
    'Bus Ticket': BusBookingPage(),
    'Train Ticket': TrainBookingPage(),
    'Uber': UberBookingPage(),
    'Ride': BookingPage(title: 'Rider'),
    'Auto Rickshaw': BookingPage(title: 'AutoRickshaw'),
  };

  static Stream<UserFinancialModel?> streamUserFinancialData() {
    return FirebaseService().streamUserFinancialData();
  }

  static Future<void> navigateToPage(
    BuildContext context,
    FeatureItem featureItem,
  ) async {
    if (featureItem.title == 'Check Balance') {
      try {
        Stream<UserFinancialModel?> userFinancialStream =
            streamUserFinancialData();

        final bool isAuthenticated = await _authService.isAuthenticated();

        if (!isAuthenticated) {
          showSnackBar("Please SignIn to your Account.", context);
          return;
        }

        await for (UserFinancialModel? userFinancialDetails
            in userFinancialStream) {
          if (userFinancialDetails == null || userFinancialDetails.isEmpty()) {
            showSnackBar("Please link Bank Account to Proceed.", context);
            return;
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BalancePinPage()),
            );
            return;
          }
        }
      } catch (e) {
        showSnackBar('An error occurred. Please try again later.', context);
      }
    } else {
      final Widget? page = pageMap[featureItem.title];
      if (page != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      } else {
        // Handle navigation for other feature items if needed
        // showSnackBar('An error occurred. Please try again later.', context);
      }
    }
  }

  static void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

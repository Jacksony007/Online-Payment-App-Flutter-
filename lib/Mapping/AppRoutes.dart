import 'package:flutter/material.dart';
import '../Registration and Login/LoginPage.dart';
import '../Registration and Login/OTPPage.dart';
import '../Registration and Login/RegistrationPage.dart';
import '../screen/AuthenticatedBankingShareScreen.dart';
import '../screen/BankingDashboard.dart';
import '../screen/UnauthenticatedBankingShareScreen.dart';

class AppRoutes {
  static const String bankingDashboard = '/';
  static const String authenticatedBankingShare =
      '/authenticated_banking_share';
  static const String unauthenticatedBankingShare =
      '/unauthenticated_banking_share';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String otp = '/otppage';

  static final Map<String, Widget Function(BuildContext)> routes = {
    bankingDashboard: (context) => const BankingDashboard(),
    authenticatedBankingShare: (context) => AuthenticatedBankingShareScreen(),
    unauthenticatedBankingShare: (context) =>
        UnauthenticatedBankingShareScreen(),
    login: (context) => LoginPage(),
    registration: (context) => RegistrationPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final WidgetBuilder builder = routes[settings.name] ??
        (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );

    if (settings.name == otp) {
      // Extract the arguments for the OTP page
      final Map<String, dynamic>? args =
          settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        return MaterialPageRoute(
            builder: (context) => OtpPage(
                  phoneNumber: args['phoneNumber'],
                  email: args['email'],
                  displayName: args['displayName'],
                  Title: args['Title'],
                ));
      } else {
        // Handle the case where phoneNumber is not available
        Scaffold(
          body: Center(
            child: Text('Missing phoneNumber argument for OTP page'),
          ),
        );
      }
    }

    return MaterialPageRoute(builder: builder);
  }
}

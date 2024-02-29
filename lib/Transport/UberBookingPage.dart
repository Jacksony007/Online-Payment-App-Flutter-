import 'package:flutter/material.dart';

import '../model/FlightAdvertisement.dart';
import '../utils/BankingColors.dart';
import '../Inner Screen/AdvertisementRow.dart';
import 'UberSearchForm.dart';

class UberBookingPage extends StatefulWidget {
  const UberBookingPage({Key? key}) : super(key: key);

  @override
  _UberBookingPageState createState() => _UberBookingPageState();
}

class _UberBookingPageState extends State<UberBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      appBar: AppBar(
        title: const Text('Uber Booking', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recommendation Row
              const UberRideRequestForm(),

              // Advertisement Row
              const SizedBox(height: 16),
              // Add some spacing
              AdvertisementRow(advertisements: busAdvertisementList),

              // Bus Search Row (Similar to Flight Booking, create a BusSearchForm widget)
              const SizedBox(height: 16), // Add some spacing
            ],
          ),
        ),
      ),
    );
  }
}

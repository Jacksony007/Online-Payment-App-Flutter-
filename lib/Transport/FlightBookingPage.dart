import 'package:flutter/material.dart';
import '../model/FlightAdvertisement.dart';
import '../utils/BankingColors.dart';
import '../Inner Screen/AdvertisementRow.dart';
import 'FlightSearchForm.dart';

class FlightBookingPage extends StatefulWidget {
  const FlightBookingPage({Key? key}) : super(key: key);

  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      appBar: AppBar(
        title: const Text(
          'Flight Booking',
          style: TextStyle(color: Colors.white),
        ),
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
              const FlightSearchForm(),

              // Advertisement Row
              const SizedBox(height: 16), // Add some spacing
              AdvertisementRow(advertisements: advertisementList),

              // Domestic Flights Search Row
              const SizedBox(height: 16), // Add some spacing
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../model/FlightAdvertisement.dart';
import '../utils/BankingColors.dart';
import '../Inner Screen/AdvertisementRow.dart';
import 'RiderSearchForm.dart';
import 'AutoRickshawRideSearchForm.dart';

class BookingPage extends StatefulWidget {
  final String title; // Pass the title to the BookingPage constructor
  const BookingPage({Key? key, required this.title}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    // Check the title to decide which form to display
    Widget bookingForm;
    String appBarText;

    if (widget.title == "Rider") {
      bookingForm = const MotorcycleRideSearchForm();
      appBarText = "Motorcycle Ride Booking";
    } else if (widget.title == "AutoRickshaw") {
      bookingForm = const AutoRickshawRideSearchForm();
      appBarText = "Auto Rickshaw Ride Booking";
    } else {
      // Default to RiderSearchForm if the title is not recognized
      bookingForm = const MotorcycleRideSearchForm();
      appBarText = "Rider Booking";
    }

    return Scaffold(
      backgroundColor: Banking_app_Background,
      appBar: AppBar(
        title: Text(appBarText, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the appropriate form based on the title
              bookingForm,

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

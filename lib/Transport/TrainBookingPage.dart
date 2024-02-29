import 'package:flutter/material.dart';

import '../model/FlightAdvertisement.dart';
import '../utils/BankingColors.dart';
import '../Inner Screen/AdvertisementRow.dart';
import 'TrainSearchingForm.dart';

class TrainBookingPage extends StatefulWidget {
  const TrainBookingPage({Key? key}) : super(key: key);

  @override
  _TrainBookingPageState createState() => _TrainBookingPageState();
}

class _TrainBookingPageState extends State<TrainBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      appBar: AppBar(
        title: const Text('Train Booking', style: TextStyle(color: Colors.white),),
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
              const TrainSearchForm(),

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

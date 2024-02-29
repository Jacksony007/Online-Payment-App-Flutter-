import 'package:flutter/material.dart';

class UberRideRequestForm extends StatefulWidget {
  const UberRideRequestForm({Key? key}) : super(key: key);

  @override
  _UberRideRequestFormState createState() => _UberRideRequestFormState();
}

class _UberRideRequestFormState extends State<UberRideRequestForm> {
  String fromLocation = '';
  String toLocation = '';
  bool isUberXSelected = true;
  int passengersCount = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  fromLocation = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'From',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the pickup location';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  toLocation = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'To',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the destination location';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isUberXSelected = true;
                    });
                  },
                  child: Text('UberX'),
                  style: ElevatedButton.styleFrom(
                    primary: isUberXSelected ? Colors.blue : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isUberXSelected = false;
                    });
                  },
                  child: Text('UberBlack'),
                  style: ElevatedButton.styleFrom(
                    primary: isUberXSelected ? Colors.grey : Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  passengersCount = int.tryParse(value) ?? 1;
                });
              },
              decoration: InputDecoration(
                labelText: 'Number of Passengers',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of passengers';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform the action when the form is valid
                  // e.g., Send ride request to the server
                }
              },
              child: Text(
                'Request Ride',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: TextStyle(
                  fontSize: 16,
                ),
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

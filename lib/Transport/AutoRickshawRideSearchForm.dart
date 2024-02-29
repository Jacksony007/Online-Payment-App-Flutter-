import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AutoRickshawRideSearchForm extends StatefulWidget {
  const AutoRickshawRideSearchForm({Key? key}) : super(key: key);

  @override
  _AutoRickshawRideSearchFormState createState() =>
      _AutoRickshawRideSearchFormState();
}

class _AutoRickshawRideSearchFormState
    extends State<AutoRickshawRideSearchForm> {
  String fromLocation = '';
  String toLocation = '';
  String autoRickshawType = 'Standard';
  int passengersCount = 1;
  String preferredService = 'Any';
  late DateTime rideDate;

  TextEditingController rideDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String getFormattedDate(DateTime? date) {
    if (date != null) {
      final formattedDate = DateFormat('dd/MMM/yyyy').format(date);
      return formattedDate;
    } else {
      return '';
    }
  }

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
            DropdownButtonFormField<String>(
              value: autoRickshawType,
              onChanged: (value) {
                setState(() {
                  autoRickshawType = value!;
                });
              },
              items: ['Standard', 'Deluxe'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Auto-Rickshaw Type',
                prefixIcon: Icon(Icons.directions_bike),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        passengersCount = int.tryParse(value) ?? 1;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Passengers',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of passengers';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: preferredService,
                    onChanged: (value) {
                      setState(() {
                        preferredService = value!;
                      });
                    },
                    items: ['Any', 'AutoFleet', 'RickGo'].map((service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Preferred Service',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              controller: rideDateController,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selectedDate != null) {
                  setState(() {
                    rideDate = selectedDate;
                    rideDateController.text = getFormattedDate(rideDate);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Ride Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select the ride date';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform the action when the form is valid
                  // e.g., Send auto-rickshaw ride request
                }
              },
              child: Text(
                'Search Auto-Rickshaw Ride',
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MotorcycleRideSearchForm extends StatefulWidget {
  const MotorcycleRideSearchForm({Key? key}) : super(key: key);

  @override
  _MotorcycleRideSearchFormState createState() =>
      _MotorcycleRideSearchFormState();
}

class _MotorcycleRideSearchFormState extends State<MotorcycleRideSearchForm> {
  String fromLocation = '';
  String toLocation = '';
  String motorcycleType = 'Standard';
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
              decoration: const InputDecoration(
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
            const SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  toLocation = value;
                });
              },
              decoration: const InputDecoration(
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: motorcycleType,
              onChanged: (value) {
                setState(() {
                  motorcycleType = value!;
                });
              },
              items: ['Standard', 'Sport', 'Cruiser'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Motorcycle Type',
                prefixIcon: Icon(Icons.motorcycle),
              ),
            ),
            const SizedBox(height: 16),
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
                    decoration: const InputDecoration(
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
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: preferredService,
                    onChanged: (value) {
                      setState(() {
                        preferredService = value!;
                      });
                    },
                    items: ['Any', 'Go-Jek', 'Grab', 'Uber'].map((service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Preferred Service',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
              decoration: const InputDecoration(
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform the action when the form is valid
                  // e.g., Send motorcycle ride request
                }
              },
              child: const Text(
                'Search Motorcycle Ride',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
                padding: const EdgeInsets.all(16),
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

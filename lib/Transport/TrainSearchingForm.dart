import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainSearchForm extends StatefulWidget {
  const TrainSearchForm({Key? key}) : super(key: key);

  @override
  _TrainSearchFormState createState() => _TrainSearchFormState();
}

class _TrainSearchFormState extends State<TrainSearchForm> {
  bool isRoundTrip = false;
  String fromLocation = '';
  String toLocation = '';
  String seatType = 'Sleeper';
  int passengersCount = 1;
  bool showACTrainsOnly = false;
  String preferredTrainType = 'Any';
  late DateTime departureDate;
  late DateTime returnDate;

  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isRoundTrip = false;
                      });
                    },
                    icon: Icon(Icons.train),
                    label: Text('One Way'),
                    style: ElevatedButton.styleFrom(
                      primary: isRoundTrip ? Colors.grey : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isRoundTrip = true;
                      });
                    },
                    icon: Icon(Icons.compare_arrows),
                    label: Text('Round Trip'),
                    style: ElevatedButton.styleFrom(
                      primary: isRoundTrip ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  fromLocation = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'From',
                prefixIcon: Icon(Icons.directions_railway),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the departure location';
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
                prefixIcon: Icon(Icons.directions_railway),
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
              value: seatType,
              onChanged: (value) {
                setState(() {
                  seatType = value!;
                });
              },
              items: ['Sleeper', 'AC Chair Car', 'AC Sleeper'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Seat Type',
                prefixIcon: Icon(Icons.airline_seat_recline_extra),
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
                    value: preferredTrainType,
                    onChanged: (value) {
                      setState(() {
                        preferredTrainType = value!;
                      });
                    },
                    items: ['Any', 'Express', 'Superfast'].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Preferred Train Type',
                      prefixIcon: Icon(Icons.train),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              controller: departureDateController,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selectedDate != null) {
                  setState(() {
                    departureDate = selectedDate;
                    departureDateController.text =
                        getFormattedDate(departureDate);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Departure Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select the departure date';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            if (isRoundTrip)
              TextFormField(
                readOnly: true,
                controller: returnDateController,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      returnDate = selectedDate;
                      returnDateController.text =
                          getFormattedDate(returnDate);
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Return Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the return date';
                  }
                  return null;
                },
              ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Show AC Trains only'),
              value: showACTrainsOnly,
              onChanged: (value) {
                setState(() {
                  showACTrainsOnly = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform the action when the form is valid
                }
              },
              child: Text(
                'Search Trains',
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

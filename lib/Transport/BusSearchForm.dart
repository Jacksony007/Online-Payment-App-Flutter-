import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusSearchForm extends StatefulWidget {
  const BusSearchForm({Key? key}) : super(key: key);

  @override
  _BusSearchFormState createState() => _BusSearchFormState();
}

class _BusSearchFormState extends State<BusSearchForm> {
  bool isRoundTrip = false;
  String fromLocation = '';
  String toLocation = '';
  String busType = 'Sleeper';
  int passengersCount = 1;
  bool showOnlyACBuses = false;
  String preferredBusOperator = 'Any';
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
                    icon: const Icon(Icons.directions_bus),
                    label: const Text('One Way'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRoundTrip ? Colors.grey : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isRoundTrip = true;
                      });
                    },
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Round Trip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRoundTrip ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  fromLocation = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'From',
                prefixIcon: Icon(Icons.place),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the departure location';
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
                prefixIcon: Icon(Icons.place),
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
              value: busType,
              onChanged: (value) {
                setState(() {
                  busType = value!;
                });
              },
              items: ['Sleeper', 'Seater', 'AC Sleeper'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Bus Type',
                prefixIcon: Icon(Icons.directions_bus),
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
                    value: preferredBusOperator,
                    onChanged: (value) {
                      setState(() {
                        preferredBusOperator = value!;
                      });
                    },
                    items: ['Any', 'Megabus', 'Greyhound', 'BoltBus'].map((operator) {
                      return DropdownMenuItem<String>(
                        value: operator,
                        child: Text(operator),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Preferred Bus Operator',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
              decoration: const InputDecoration(
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
            const SizedBox(height: 16),
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
                decoration: const InputDecoration(
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
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Show Only AC Buses'),
              value: showOnlyACBuses,
              onChanged: (value) {
                setState(() {
                  showOnlyACBuses = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform the action when the form is valid
                }
              },
              child: const Text(
                'Search Buses',
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

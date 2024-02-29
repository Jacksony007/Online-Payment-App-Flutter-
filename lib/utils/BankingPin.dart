import 'package:flutter/material.dart';

import 'BankingColors.dart';
import 'BankingCustomIcon.dart';

class PinEntryScreen extends StatefulWidget {
  final Map<String, dynamic> params;

  const PinEntryScreen({Key? key, required this.params}) : super(key: key);

  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String pin = '';
  bool obscurePin = true;

  void onKeyPressed(int number) {
    setState(() {
      if (pin.length < 4) {
        pin += number.toString();
      }
      if (pin.length == 4) {
        _showReceiptDialog(widget.params);
      }
    });
  }

  void _toggleObscurePin() {
    setState(() {
      obscurePin = !obscurePin;
    });
  }

  void _showReceiptDialog(Map<String, dynamic> values) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8.0),
              Text(
                'Payment Successful',
                style: TextStyle(color: Colors.blue, fontSize: 18.0),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildDialogContent(values),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildDialogContent(Map<String, dynamic> values) {
    List<Widget> content = [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Image.asset(
            'images/banking/tick.png',
            height: 70,
            width: 70,
            color: Colors.green,
          ),
        ),
      ),
      const SizedBox(height: 10.0),
    ];

    values.forEach((key, value) {
      String capitalizedValue =
          _capitalizeFirstLetterEachWord(value.toString());
      content.add(Text('$key: $capitalizedValue'));
      content.add(const SizedBox(height: 10.0));
    });

    content.addAll([
      const SizedBox(height: 20.0),
      const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.thumb_up, size: 24, color: Colors.blue),
            SizedBox(width: 8.0),
            Text('Thank You!',
                style: TextStyle(fontSize: 18, color: Colors.blue)),
          ],
        ),
      ),
    ]);

    return content;
  }

  String _capitalizeFirstLetterEachWord(String input) {
    return input.replaceAllMapped(RegExp(r'\b\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color of the app
      appBar: AppBar(
        title: const Text('Modern PIN Pad'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: NumPad(
          buttonColor: Colors.blue,
          iconColor: Colors.white,
          pin: pin,
          delete: () {
            setState(() {
              if (pin.isNotEmpty) {
                pin = pin.substring(0, pin.length - 1);
              }
            });
          },
          toggleObscurePin: _toggleObscurePin,
          obscurePin: obscurePin,
          onKeyPressed: onKeyPressed, // Added onKeyPressed callback
        ),
      ),
    );
  }
}

class NumPad extends StatelessWidget {
  final double buttonWidth;
  final double buttonHeight;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController? controller; // Add '?' to make it nullable
  final Function delete;
  final Function toggleObscurePin;
  final String pin;
  final bool obscurePin;
  final Function onKeyPressed; // Added onKeyPressed callback

  const NumPad({
    Key? key,
    this.buttonWidth = 140,
    this.buttonHeight = 75,
    this.buttonColor = Colors.blue,
    this.iconColor = Colors.blue,
    this.controller,
    required this.delete,
    required this.toggleObscurePin,
    required this.obscurePin,
    required this.pin,
    required this.onKeyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

// Calculate the button dimensions based on the screen size
    double calculatedButtonWidth = screenWidth / 5;
    double calculatedButtonHeight =
        (screenWidth / 10).clamp(70, double.infinity);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Banking_app_Background,

      child: Column(
        children: [
          const SizedBox(height: 100),
          PinDisplayField(
            pin: obscurePin ? '●' * pin.length : pin,
            obscure: false, // Set to true if you want to obscure the PIN
          ),
          const SizedBox(height: 50),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Align at the bottom

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => NumberButton(
                      number: index + 1,
                      width: calculatedButtonWidth,
                      height: calculatedButtonHeight,
                      color: buttonColor,
                      pin: pin,
                      onKeyPressed: (number) => onKeyPressed(number),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => NumberButton(
                      number: index + 4,
                      width: calculatedButtonWidth,
                      height: calculatedButtonHeight,
                      color: buttonColor,
                      pin: pin,
                      onKeyPressed: (number) => onKeyPressed(number),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => NumberButton(
                      number: index + 7,
                      width: calculatedButtonWidth,
                      height: calculatedButtonHeight,
                      color: buttonColor,
                      pin: pin,
                      onKeyPressed: (number) => onKeyPressed(number),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: () => delete(),
                      icon: Icons.backspace,
                      iconColor: iconColor,
                      buttonWidth: calculatedButtonWidth,
                      buttonHeight: calculatedButtonHeight,
                    ),
                    NumberButton(
                      number: 0,
                      width: calculatedButtonWidth,
                      height: calculatedButtonHeight,
                      color: buttonColor,
                      pin: pin,
                      onKeyPressed: (number) => onKeyPressed(number),
                    ),
                    ElevatedButton(
                      onPressed: () => toggleObscurePin(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ).merge(
                        ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(calculatedButtonWidth, calculatedButtonHeight),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          obscurePin ? 'Show PIN' : 'Hide PIN',
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final double width;
  final double height;
  final Color color;
  final String pin;
  final Function onKeyPressed;

  const NumberButton({
    Key? key,
    required this.number,
    required this.width,
    required this.height,
    required this.color,
    required this.pin,
    required this.onKeyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(width * 0.2),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          onKeyPressed(number);
        },
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: height * 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class PinDisplayField extends StatelessWidget {
  final String pin;
  final bool obscure;

  const PinDisplayField({
    Key? key,
    required this.pin,
    required this.obscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                width: 40.0,
                height: 40.0,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: pin.length > index ? Colors.blue : Colors.black12,
                      width: 2.0, // Adjust the width of the underline
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    obscure
                        ? (index < pin.length ? '●' : '')
                        : (pin.length > index ? pin[index] : ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Additional content can be added below the PinDisplayField if needed
      ],
    );
  }
}

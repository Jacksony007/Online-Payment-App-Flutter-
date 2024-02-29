import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../Inner Screen/AmountEntryScreen.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final ImagePicker _picker = ImagePicker();
  bool isFlashOn = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan and Pay',
          style: TextStyle(color: Colors.white), // Set your desired text color
        ),
        backgroundColor: Colors.blue, // Set your desired color
        elevation: 0, // Remove elevation if you don't want a shadow
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orange, // Set your desired text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Set your desired border radius
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                    ),
                    label: const Text('Flash'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set your desired text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Set your desired border radius
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  // Adjust this value to position the scanning line within the focus area
                  child: _buildScanningLine(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 2,
          width: 300,
          color: Colors.green, // Set your desired scanning line color
          margin: EdgeInsets.only(top: 150 * _animation.value),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data

      _processScannedData(scanData.code);
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // If an image is picked, decode the QR code from the image
      final File file = File(pickedFile.path);
      final String? scannedData = await _decodeQRCodeFromImage(file);
      if (scannedData != null) {
        print('Scanned data from image: $scannedData');
        _processScannedData(scannedData);
      } else {
        print('No QR code found in the selected image.');
      }
    }
  }

  Future<String?> _decodeQRCodeFromImage(File imageFile) async {
    try {
      final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image != null) {
        // Your decoding logic here
        // You can use any QR code decoding logic compatible with null safety

        // For example, using the qr_code_scanner package
        final result = await controller.scannedDataStream.first;
        return result.code;
      }

      return null;
    } catch (e) {
      print('Error decoding QR code from image: $e');
      return null;
    }
  }

  void _processScannedData(String? data) {
    if (data != null) {
      // Navigate to the AmountEntryScreen page when a QR code is found
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmountEntryScreen(
            companyName: data,
          ),
        ),
      );
    } else {

    }
  }


  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
      controller.toggleFlash();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class NextPage extends StatelessWidget {
  final String scannedData;

  const NextPage({Key? key, required this.scannedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Next Page',
          style: TextStyle(color: Colors.white), // Set your desired text color
        ),
        backgroundColor: Colors.blue, // Set your desired color
        elevation: 0, // Remove elevation if you don't want a shadow
      ),
      body: Center(
        child: Text('Scanned QR Code: $scannedData'),
      ),
    );
  }
}

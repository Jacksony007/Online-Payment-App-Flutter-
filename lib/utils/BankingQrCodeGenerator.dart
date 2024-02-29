import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Controller/UserDetails.dart';
import '../User Model/user_financial_model.dart';

class QrCodeGenerator extends StatefulWidget {
  QrCodeGenerator({Key? key}) : super(key: key);

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  UserFinancialModel? financialData;

  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserFinancialModel?>(
      stream: firebaseService.streamUserFinancialData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserFinancialModel financialData = snapshot.data!;

          // If the Future is complete, display the QrImageView
          return QrImageView(
            data: financialData.payflowId ?? '',
            version: QrVersions.auto,
            size: 200.0,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.blue,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.blue, // Set data module color here
            ),
          );
        } else if (snapshot.hasError) {
          // If there's an error, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If the Future is still incomplete, show a loading indicator
          return CircularProgressIndicator();
        }
      },
    );
  }
}

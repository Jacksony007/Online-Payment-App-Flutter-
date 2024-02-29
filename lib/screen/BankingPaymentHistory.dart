import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/User%20Model/PaymentHistoryModel.dart';

class BankingHistoryPage extends StatefulWidget {
  static var tag = "/BankingSaving";

  const BankingHistoryPage({Key? key}) : super(key: key);

  @override
  _BankingHistoryPageState createState() => _BankingHistoryPageState();
}

class _BankingHistoryPageState extends State<BankingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Historyhg',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: paymentHistoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  PaymentHistoryModel payment = paymentHistoryList[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Transaction ID: ${payment.transactionId}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.receiverName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bank: ${payment.receiverBankName}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Amount: \$${payment.amount}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Date: ${payment.date} - ${payment.time}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      trailing: _buildStatusIcon(payment.status),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button click
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View More Transactions',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(PaymentStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case PaymentStatus.Successful:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case PaymentStatus.Pending:
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case PaymentStatus.Failed:
        icon = Icons.cancel;
        color = Colors.red;
        break;
    }

    return Icon(
      icon,
      color: color,
      size: 30,
    );
  }
}

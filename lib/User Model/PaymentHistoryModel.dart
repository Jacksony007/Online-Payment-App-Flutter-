class PaymentHistoryModel {
  final String transactionId;
  final double amount;
  final String time;
  final String date;
  final String receiverName;
  final String receiverBankName;
  final PaymentStatus status;

  PaymentHistoryModel({
    required this.transactionId,
    required this.amount,
    required this.time,
    required this.date,
    required this.receiverName,
    required this.receiverBankName,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'amount': amount,
      'time': time,
      'date': date,
      'receiverName': receiverName,
      'receiverBankName': receiverBankName,
      'status': status.toString(), // Convert enum to string
    };
  }
}

enum PaymentStatus {
  Successful,
  Pending,
  Failed,
  // Add more statuses as needed
}

// Create a list of PaymentHistoryModel instances
List<PaymentHistoryModel> paymentHistoryList = [
  PaymentHistoryModel(
    transactionId: "1dewhmn",
    amount: 100.0,
    time: "10:00 AM",
    date: "2024-01-01",
    receiverName: "John Doe",
    receiverBankName: "Bank A",
    status: PaymentStatus.Successful,
  ),
  PaymentHistoryModel(
    transactionId: "1we356r",
    amount: 100.0,
    time: "10:00 AM",
    date: "2024-01-01",
    receiverName: "John Doe",
    receiverBankName: "Bank A",
    status: PaymentStatus.Pending,
  ),
  PaymentHistoryModel(
    transactionId: "111cd2e",
    amount: 100.0,
    time: "10:00 AM",
    date: "2024-01-01",
    receiverName: "John Doe",
    receiverBankName: "Bank A",
    status: PaymentStatus.Successful,
  ),
  PaymentHistoryModel(
    transactionId: "123fgdk4",
    amount: 100.0,
    time: "10:00 AM",
    date: "2024-01-01",
    receiverName: "John Doe",
    receiverBankName: "Bank A",
    status: PaymentStatus.Failed,
  ),
  PaymentHistoryModel(
    transactionId: "po4x34b1",
    amount: 100.0,
    time: "10:00 AM",
    date: "2024-01-01",
    receiverName: "John Doe",
    receiverBankName: "Bank A",
    status: PaymentStatus.Successful,
  ),
  PaymentHistoryModel(
    transactionId: "fg76fw1",
    amount: 100.0,
    time: "10:00 AM",
    date: "2024-01-01",
    receiverName: "John Doe",
    receiverBankName: "Bank A",
    status: PaymentStatus.Successful,
  ),
  // Add more instances as needed
];

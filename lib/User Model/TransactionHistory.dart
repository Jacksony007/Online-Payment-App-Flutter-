class Transaction {
  final String type;
  final String date;
  final String amount;

  Transaction(this.type, this.date, this.amount);
}

List<Transaction> transactions = [
  Transaction("Payment", "12 Jan 2023", "₵500"),
  Transaction("Withdrawal", "10 Jan 2023", "₵200"),
  // Add more transactions as needed
];
// user_financial_model.dart
class BankInfo {
  final String? phoneNumber;
  final double? balance;
  final String? payflowId;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String? pin;
  final String? username;
  final bool isActive;

  BankInfo({
    this.phoneNumber,
    this.balance,
    this.payflowId,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.pin,
    this.username,
    required this.isActive,
  });
}

final List<BankInfo> banks = [
  BankInfo(
    phoneNumber: '+255764431337',
    balance: 1000.0,
    payflowId: '',
    bankName: 'ABC Bank',
    accountNumber: '1234567890',
    accountName: 'John Doe',
    pin: '1234',
    username: 'johndoe',
    isActive: true,
  ),
  // Add more sample banks as needed
];

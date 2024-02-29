// user_financial_model.dart
class UserFinancialModel {
  final String? bankInfoId;
  final String? phoneNumber;
  final String? payflowId;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final bool isActive;

  UserFinancialModel({
    this.bankInfoId,
    this.phoneNumber,
    this.payflowId,
    this.bankName,
    this.accountNumber,
    this.accountName,
    required this.isActive,
  });

  // Convert the financial model to a Map for saving to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'bankInfoId': bankInfoId,
      'phoneNumber': phoneNumber,
      'payflowId': payflowId,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'isActive': isActive,
    };
  }

  // Create a financial model from a Map (usually from SharedPreferences)
  factory UserFinancialModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserFinancialModel(
        bankInfoId: '',
        phoneNumber: '',
        payflowId: '',
        bankName: '',
        accountNumber: '',
        accountName: '',
        isActive: false,
      );
    }

    return UserFinancialModel(
      bankInfoId: json['bankInfoId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0.0,
      payflowId: json['payflowId'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  bool isEmpty() {
    return (bankName?.isEmpty ?? true) ||
        (bankInfoId?.isEmpty ?? true) ||
        (accountNumber?.isEmpty ?? true) ||
        (phoneNumber?.isEmpty ?? true) ||
        (accountName?.isEmpty ?? true) ||
        !isActive;
    // Add other conditions as needed
  }
}

// user_model.dart
class UserModel {
  final String? email;
  final String? phoneNumber;
  final String? photoURL;
  final String? displayName;

  UserModel({this.email, this.phoneNumber, this.photoURL, this.displayName});

  // Convert the user model to a Map for saving to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'photoURL': photoURL ?? '',
      'DisplayName': displayName ?? '',
    };
  }

  // Factory constructor to create a UserModel instance from a Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        photoURL: json['photoURL'],
        displayName: json['displayName']);
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Auth Services/AuthServices.dart';
import '../Controller/UserDetails.dart';
import '../User Model/user_model.dart';
import '../model/BankInfo.dart';
import '../utils/BankingContants.dart';
import 'AllOtherBanks.dart';
import 'FeaturedItemsClass.dart';

class PaymentSettingsPage extends StatefulWidget {
  const PaymentSettingsPage({Key? key}) : super(key: key);

  @override
  _PaymentSettingsPageState createState() => _PaymentSettingsPageState();
}

class _PaymentSettingsPageState extends State<PaymentSettingsPage> {
  final AuthService _authService = AuthService();
  UserModel? userData;

  FirebaseService firebaseService = FirebaseService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      checkAuthentication();
    });
  }

  Future<void> checkAuthentication() async {
    bool isAuthenticated = await _authService.isAuthenticated();
    setState(() {
      isLoading = true;
    });

    if (!isAuthenticated) {
      // User is not authenticated
      Navigator.pushReplacementNamed(context, '/registration');
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Link Bank', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              StreamBuilder<UserModel?>(
                                stream: firebaseService.streamUserData(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    userData = snapshot.data!;
                                    return Expanded(
                                        child: Text(
                                      'Choose your Bank account associated with this mobile number\n ${userData?.phoneNumber ?? ''}',
                                      style: primaryTextStyle(
                                        size: 18,
                                        color: Colors.blue,
                                        fontFamily: fontSemiBold,
                                      ),
                                    ));
                                  } else {
                                    return Text(
                                      'No Mobile Number',
                                      style: primaryTextStyle(
                                        size: 18,
                                        fontFamily: fontSemiBold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          FeatureCategory(
                            category: 'Popular Banks',
                            banks: BankList.getBanks(),
                            categoryColor: Colors.purple,
                          ),
                          const SizedBox(height: 16.0),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  200, // Adjust the maxHeight as needed
                            ),
                            child: AllOtherBanks(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}

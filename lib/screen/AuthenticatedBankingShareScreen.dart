import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_flutter_ui_kits/utils/BankingQrCodeGenerator.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Auth Services/AuthServices.dart';
import '../Controller/UserDetails.dart';
import '../Edit Screen/EditProfileScreen.dart';
import '../User Model/user_financial_model.dart';
import '../User Model/user_model.dart';
import '../model/BankingModel.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingDataGenerator.dart';
import '../utils/BankingImages.dart';
import '../utils/BankingStrings.dart';

class AuthenticatedBankingShareScreen extends StatefulWidget {
  static const String routeName = "/authenticated_banking_share";

  @override
  _AuthenticatedBankingShareScreenState createState() =>
      _AuthenticatedBankingShareScreenState();
}

class _AuthenticatedBankingShareScreenState
    extends State<AuthenticatedBankingShareScreen> {
  late List<BankingShareInfoModel> mList1;

  final AuthService _authService = AuthService();

  UserModel? userData;
  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();

  // Add a loading state variable
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    mList1 = bankingInfoList();
    // Add a delay before checking authentication
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
      backgroundColor: Banking_app_Background,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildPageContent(),
    );
  }

  Widget buildPageContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    child:
                        // Display user's picture
                        StreamBuilder<UserModel?>(
                      stream: firebaseService.streamUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          userData = snapshot.data!;
                          return CircleAvatar(
                            backgroundImage: userData?.photoURL != null &&
                                    userData!.photoURL!.isNotEmpty
                                ? AssetImage(userData!.photoURL!)
                                : AssetImage(DefaultPicture),
                            radius: 60,
                          );
                        } else {
                          return CircleAvatar(
                            backgroundImage: AssetImage(DefaultPicture),
                            radius: 60,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<UserFinancialModel?>(
                      stream: firebaseService.streamUserFinancialData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserFinancialModel financialData = snapshot.data!;
                          return Text(
                            financialData.accountName ?? 'No Account Linked',
                            style: boldTextStyle(
                              color: Banking_TextColorPrimary,
                              size: 24,
                            ),
                          );
                        } else
                          return Text('No Account Linked',
                              style: boldTextStyle(
                                color: Banking_TextColorPrimary,
                                size: 24,
                              ));
                      })
                ],
              ),
            ),
          ),
          backgroundColor: Banking_app_Background,
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "My Account",
                  style: boldTextStyle(
                    size: 30,
                    color: Banking_TextColorPrimary,
                  ),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Mobile Number',
                      style: primaryTextStyle(
                        color: Banking_TextColorPrimary,
                        size: 18,
                        fontFamily: fontSemiBold,
                      ),
                    ),
                    StreamBuilder<UserModel?>(
                      stream: firebaseService.streamUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          userData = snapshot.data!;
                          return Text(
                            userData?.phoneNumber ?? '',
                            style: primaryTextStyle(
                              size: 18,
                              fontFamily: fontSemiBold,
                            ),
                          );
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
                const Divider(height: 20),
                StreamBuilder<UserFinancialModel?>(
                  stream: firebaseService.streamUserFinancialData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserFinancialModel financialData = snapshot.data!;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Bank Name',
                                  style: primaryTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 18,
                                      fontFamily: fontSemiBold)),
                              Text(financialData.bankName ?? 'No Bank Account',
                                  style: primaryTextStyle(
                                      size: 18, fontFamily: fontSemiBold)),
                            ],
                          ).paddingOnly(bottom: spacing_middle),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Payflow Id',
                                  style: primaryTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 18,
                                      fontFamily: fontSemiBold)),
                              Text(financialData.payflowId ?? 'No Bank Account',
                                  style: primaryTextStyle(
                                      size: 18, fontFamily: fontSemiBold)),
                            ],
                          ),
                          const Divider(height: 20),

                          Center(
                            child: Text('Scan QR Code',
                                style: boldTextStyle(
                                    size: 20, color: Banking_TextColorPrimary)),
                          ),
                          5.height,
                          // Wrap QrCodeGenerator with Visibility widget
                          Visibility(
                            visible: financialData.payflowId != null &&
                                financialData.payflowId!.isNotEmpty,
                            child: Center(
                              child: QrCodeGenerator(),
                            ),
                          ),
                          // Move Row widget inside the Center
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  financialData.payflowId ?? 'No PayflowId',
                                  style: primaryTextStyle(
                                    size: 14,
                                    color: Banking_TextColorPrimary,
                                    fontFamily: fontMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Copy payflowId to clipboard
                                    Clipboard.setData(ClipboardData(
                                      text: financialData.payflowId ?? '',
                                    ));
                                    Fluttertoast.showToast(
                                      msg: "Payflow ID copied to clipboard",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Bank Name',
                                  style: primaryTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 18,
                                      fontFamily: fontSemiBold)),
                              Text('No details',
                                  style: primaryTextStyle(
                                      size: 18, fontFamily: fontSemiBold)),
                            ],
                          ).paddingOnly(bottom: spacing_middle),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Payflow Id',
                                  style: primaryTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 18,
                                      fontFamily: fontSemiBold)),
                              Text('No details',
                                  style: primaryTextStyle(
                                      size: 18, fontFamily: fontSemiBold)),
                            ],
                          ),
                          const Divider(height: 20),

                          Center(
                            child: Text('Scan QR Code',
                                style: boldTextStyle(
                                    size: 20, color: Banking_TextColorPrimary)),
                          ),
                          5.height,
                          // Wrap QrCodeGenerator with Visibility widget
                          Visibility(
                            visible: false,
                            // You can set this to false as there are no details
                            child: Center(
                              child: QrCodeGenerator(),
                            ),
                          ),
                          // Move Row widget inside the Center
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No details',
                                  style: primaryTextStyle(
                                    size: 14,
                                    color: Banking_TextColorPrimary,
                                    fontFamily: fontMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Handle the copy action for 'No details'
                                    // You can show a toast or handle it as per your requirement
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                20.height,
                Text(Banking_lbl_Share_Info,
                    style: primaryTextStyle(
                        color: Banking_TextColorPrimary,
                        size: 18,
                        fontFamily: fontSemiBold)),
                40.height,
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mList1.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(right: spacing_standard_new),
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 20,
                        width: 50,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: boxDecorationWithShadow(
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Banking_whitePureColor,
                            boxShadow: defaultBoxShadow()),
                        child: Image.asset(mList1[index].icon,
                                height: 30, width: 30)
                            .center(),
                      );
                    },
                  ),
                ).center(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

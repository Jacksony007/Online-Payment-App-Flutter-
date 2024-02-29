import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/Settings/LinkBankPage.dart';
import 'package:free_flutter_ui_kits/Settings/RemoveCard.dart';
import 'package:free_flutter_ui_kits/utils/ThemeProvider.dart';
import 'package:provider/provider.dart';
import '../Auth Services/AuthServices.dart';
import '../Controller/UserDetails.dart';
import '../Edit Screen/EditProfileScreen.dart';
import '../User Model/user_financial_model.dart';
import '../User Model/user_model.dart';
import 'BankLinkPage.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingImages.dart';
import '../utils/BankingStrings.dart';
import '../utils/BankingWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../screen/BankingChangePasword.dart';
import '../screen/BankingContact.dart';
import '../screen/BankingLocation.dart';
import '../screen/BankingNews.dart';
import '../screen/BankingQuestionAnswer.dart';
import '../screen/BankingRateInfo.dart';
import '../screen/BankingTermsCondition.dart';
import 'ChangePayflowId.dart';

class BankingMenu extends StatefulWidget {
  static var tag = "/BankingMenu";

  const BankingMenu({Key? key}) : super(key: key);

  @override
  _BankingMenuState createState() => _BankingMenuState();
}

class _BankingMenuState extends State<BankingMenu> {
  UserModel? userData;
  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              10.height,
              Text(Banking_lbl_Setting,
                  style:
                      boldTextStyle(color: Banking_TextColorPrimary, size: 35)),
              16.height,

              // Container 1: My Account
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                  radius: 40,
                                );
                              } else {
                                return CircleAvatar(
                                  backgroundImage: AssetImage(DefaultPicture),
                                  radius: 40,
                                );
                              }
                            },
                          ),
                          10.width,
                          StreamBuilder<UserFinancialModel?>(
                              stream: firebaseService.streamUserFinancialData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  UserFinancialModel financialData =
                                      snapshot.data!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      5.height,
                                      Text(
                                          financialData.accountName ??
                                              "No Bank Account",
                                          style: boldTextStyle(
                                              color: Banking_TextColorPrimary,
                                              size: 18)),
                                      5.height,
                                      Text(
                                          financialData.accountNumber ??
                                              "No Account Number",
                                          style: primaryTextStyle(
                                              color: Banking_TextColorSecondary,
                                              size: 16,
                                              fontFamily: fontMedium)),
                                      5.height,
                                      Text(
                                          financialData.bankName ??
                                              'No Bank Name',
                                          style: primaryTextStyle(
                                              color: Banking_TextColorSecondary,
                                              size: 16,
                                              fontFamily: fontMedium)),
                                    ],
                                  ).expand();
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      5.height,
                                      Text("No Bank Account",
                                          style: boldTextStyle(
                                              color: Banking_TextColorPrimary,
                                              size: 18)),
                                      5.height,
                                      Text("No Account Number",
                                          style: primaryTextStyle(
                                              color: Banking_TextColorSecondary,
                                              size: 16,
                                              fontFamily: fontMedium)),
                                      5.height,
                                      Text('No Bank Name',
                                          style: primaryTextStyle(
                                              color: Banking_TextColorSecondary,
                                              size: 16,
                                              fontFamily: fontMedium)),
                                    ],
                                  ).expand();
                                }
                              }),
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),

              // Container 2: Account Settings
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Account Settings",
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 20)),
                    10.height,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          bankingOption(
                                  "images/banking/edit-user-3-svgrepo-com.png",
                                  'Edit Profile',
                                  Banking_blueColor)
                              .onTap(() {
                            EditProfileScreen().launch(context);
                          }),
                          bankingOption("images/banking/Upi.png",
                                  'Change Payflow ID', Banking_pinkColor)
                              .onTap(() {
                            ChangePayflowIdPage().launch(context);
                          }),
                          bankingOption("images/banking/Banking_ic_Moblie.png",
                                  'Payment Settings', Banking_greenLightColor)
                              .onTap(() {
                            PaymentSettingsPage().launch(context);
                          }),
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),
              // Container 3: Bank Settings
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Bank Settings",
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 20)),
                    10.height,
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          bankingOption("images/banking/bank-transfer.png",
                                  'Link Bank', Banking_blueColor)
                              .onTap(() {
                            BankLinkPage().launch(context);
                          }),
                          bankingOption(
                                  "images/banking/lock-password-svgrepo-com.png",
                                  'Change PIN',
                                  Colors.green)
                              .onTap(() {
                            BankingChangePassword().launch(context);
                          }),
                          bankingOption("images/banking/payment.png",
                                  'Remove Bank', Banking_pinkColor)
                              .onTap(() {
                            RemoveCardPage().launch(context);
                          }),
                          10.height,
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),

              // Container 4: Notification
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Notification",
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 20)),
                    10.height,
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          bankingOption("images/banking/notification.png",
                                  'Push Notification', Banking_blueColor)
                              .onTap(() {
                            //  BankingNews().launch(context);
                          }),
                          bankingOption("images/banking/night-mode.png",
                                  'Dark Mode', Banking_greenLightColor)
                              .onTap(() {
                            //  BankingRateInfo().launch(context);
                          }),
                          10.height,
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),

              // Container 5: Contact Information
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Contact Information",
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 20)),
                    10.height,
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          bankingOption(Banking_ic_News, Banking_lbl_News,
                                  Banking_blueColor)
                              .onTap(() {
                            const BankingNews().launch(context);
                          }),
                          bankingOption(
                                  Banking_ic_Chart,
                                  Banking_lbl_Rate_Information,
                                  Banking_greenLightColor)
                              .onTap(() {
                            const BankingRateInfo().launch(context);
                          }),
                          bankingOption(Banking_ic_Pin, Banking_lbl_Location,
                                  Banking_greenLightColor)
                              .onTap(() {
                            const BankingLocation().launch(context);
                          }),
                          10.height,
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),

              // Container 5: Others
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Others",
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 20)),
                    10.height,
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: spacing_middle),
                          bankingOption(
                                  Banking_ic_TC,
                                  Banking_lbl_Term_Conditions,
                                  Banking_greenLightColor)
                              .onTap(() {
                            const BankingTermsCondition().launch(context);
                          }),
                          bankingOption(
                                  Banking_ic_Question,
                                  Banking_lbl_Questions_Answers,
                                  Banking_palColor)
                              .onTap(() {
                            const BankingQuestionAnswer().launch(context);
                          }),
                          bankingOption(Banking_ic_Call, Banking_lbl_Contact,
                                  Banking_blueColor)
                              .onTap(() {
                            const BankingContact().launch(context);
                          }),
                          const SizedBox(height: spacing_middle),
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),

              // Container 6: Logout
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    bankingOption(Banking_ic_Logout, Banking_lbl_Logout,
                            Banking_pinkColor)
                        .onTap(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const CustomDialog(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
        child: const Icon(Icons.brightness_4),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          16.height,
          Text(Banking_lbl_Confirmation_for_logout,
                  style: primaryTextStyle(size: 18))
              .onTap(() {
            finish(context);
          }).paddingOnly(top: 8, bottom: 8),
          const Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Cancel", style: primaryTextStyle(size: 18)).onTap(() {
                finish(context);
              }).paddingRight(16),
              Container(width: 1.0, height: 40, color: Banking_greyColor)
                  .center(),
              Text("Logout",
                      style: primaryTextStyle(size: 18, color: Banking_Primary))
                  .onTap(() async {
                // Call the signOut method from your AuthService
                await AuthService().signOut();
                // Close the current screen or navigate to the login screen
                finish(context);
              }).paddingLeft(16),
            ],
          ),
          16.height,
        ],
      ));
}

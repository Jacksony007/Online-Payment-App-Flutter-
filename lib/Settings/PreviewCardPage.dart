import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingImages.dart';
import '../utils/BankingWidget.dart';
import '../User Model/MyCards.dart';

class PreviewCardPage extends StatefulWidget {
  static var tag = "/BankingTransfer";
  final MyCardsModel card;
  final int cardIndex;

  const PreviewCardPage({Key? key, required this.card, required this.cardIndex})
      : super(key: key);

  @override
  _PreviewCardPageState createState() => _PreviewCardPageState();
}

class _PreviewCardPageState extends State<PreviewCardPage> {
  bool isSwitch = false;
  bool isGetOtp = false;
  var tapCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _bankLogo = widget.card.imagePath.validate();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Remove Card ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        backgroundColor: Banking_app_Background,
        body: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          Banking_ic_CardImage,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.card.accountname.validate(),
                                    style: boldTextStyle(
                                      color: Banking_whitePureColor,
                                      size: 18,
                                      fontFamily: fontMedium,
                                    ),
                                  ).paddingOnly(
                                    top: spacing_large,
                                    left: spacing_standard_new,
                                  ),
                                  Text(
                                    "PayFlow App",
                                    style: boldTextStyle(
                                      color: Banking_whitePureColor,
                                      size: 16,
                                      fontFamily: fontMedium,
                                    ),
                                  ).paddingOnly(
                                    top: spacing_large,
                                    right: spacing_standard_new,
                                  ),
                                ],
                              ),
                              Text(
                                widget.card.bankname.validate(),
                                style: boldTextStyle(
                                  color: Banking_whitePureColor,
                                  size: 18,
                                  fontFamily: fontMedium,
                                ),
                              ).paddingOnly(
                                top: spacing_large,
                                left: spacing_standard_new,
                              ),
                              Text(
                                widget.card.accountNumber.validate(),
                                style: boldTextStyle(
                                  color: Banking_whitePureColor,
                                  size: 18,
                                  fontFamily: fontMedium,
                                ),
                              ).paddingOnly(
                                left: spacing_standard_new,
                                top: spacing_control,
                              ),
                              Text(
                                widget.card.expireDate.validate(),
                                style: boldTextStyle(
                                  color: Banking_whitePureColor,
                                  size: 18,
                                  fontFamily: fontMedium,
                                ),
                              ).paddingOnly(
                                top: spacing_standard,
                                left: spacing_standard_new,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Bank Name",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(_bankLogo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(widget.card.bankname.validate(),
                                  style: primaryTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 16,
                                      fontFamily: fontRegular)),
                            ],
                          )
                        ],
                      ),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Account Name",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                          Row(
                            children: [
                              Text(widget.card.accountname.validate(),
                                  style: primaryTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 16,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ],
                      ),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Account Number",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                          Text(widget.card.accountNumber.validate(),
                              style: primaryTextStyle(
                                  color: Banking_TextColorPrimary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date Linked",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                          Text(widget.card.dateLinked.validate(),
                              style: primaryTextStyle(
                                  color: Banking_TextColorPrimary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                        ],
                      ),
                      const Divider(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("A OTP code has been send to your phone",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 14,
                                  fontFamily: fontRegular)),
                          EditText(text: "Enter OTP", isPassword: false),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('Resend',
                                    style: primaryTextStyle(
                                        size: 18, fontFamily: fontRegular))
                                .onTap(() {}),
                          ),
                          8.height,
                          Text("Use Face ID to verify transaction",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 14,
                                  fontFamily: fontRegular)),
                          Image.asset(Banking_ic_face_id,
                                  color: Banking_Primary, height: 40, width: 40)
                              .center()
                              .paddingOnly(top: 16, bottom: 16),
                        ],
                      ).visible(isGetOtp == true),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delete this Card",
                              style: primaryTextStyle(
                                  color: Banking_TextColorSecondary,
                                  size: 16,
                                  fontFamily: fontRegular)),
                          Switch(
                            value: isSwitch,
                            onChanged: (value) {
                              setState(() {
                                isSwitch = value;
                              });
                            },
                            activeTrackColor: Banking_Primary.withOpacity(0.5),
                            activeColor: Banking_Primary,
                          ),
                        ],
                      ).visible(isGetOtp == false),
                      const Divider(height: 24),
                      16.height,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isGetOtp == true
                              ? Banking_Primary
                              : Colors.red, // Change color based on the state
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the button's border radius
                          ),
                          elevation: 4, // Adjust the button's elevation
                        ),
                        onPressed: () {
                          setState(() {
                            isGetOtp = true;
                            tapCount = tapCount + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          // Adjust the button's padding
                          child: Text(
                            isGetOtp == true ? 'Confirm' : 'Delete',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors
                                    .white), // Adjust the button's text style
                          ),
                        ),
                      ).visible(isSwitch == true),
                      24.height,
                    ],
                  )
                ],
              ),
            )));
  }
}

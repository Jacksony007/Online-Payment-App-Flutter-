import 'package:flutter/material.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingImages.dart';
import '../utils/BankingStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Banking_app_Background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Banking_TextColorPrimary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "My Account",
          style: boldTextStyle(color: Banking_TextColorPrimary, size: 20),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Banking_app_Background,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const CircleAvatar(
                        backgroundImage: AssetImage(Banking_ic_user3),
                        radius: 40,
                      ),
                      10.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          5.height,
                          Text(
                            "William Hyfford",
                            style: boldTextStyle(
                              color: Banking_TextColorPrimary,
                              size: 18,
                            ),
                          ),
                          5.height,
                          Text(
                            "123 456 789",
                            style: primaryTextStyle(
                              color: Banking_TextColorSecondary,
                              size: 16,
                              fontFamily: fontMedium,
                            ),
                          ),
                          5.height,
                          Text(
                            Banking_lbl_app_Name,
                            style: primaryTextStyle(
                              color: Banking_TextColorSecondary,
                              size: 16,
                              fontFamily: fontMedium,
                            ),
                          ),
                        ],
                      ).expand()
                    ],
                  ),
                ),
                16.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

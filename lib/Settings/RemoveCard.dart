import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../User Model/MyCards.dart';
import 'MyCardsSlider.dart';
import 'PreviewCardPage.dart';

class RemoveCardPage extends StatefulWidget {
  static var tag = "/BankingTransfer";

  const RemoveCardPage({Key? key}) : super(key: key);

  @override
  _RemoveCardPageState createState() => _RemoveCardPageState();
}

class _RemoveCardPageState extends State<RemoveCardPage> {
  bool isSwitch = false;
  bool isGetOtp = false;

  late List<MyCardsModel> mList; // Add this line
  int currentIndexPage = 0;

  // Function to update currentIndexPage
  void updateCurrentIndex(int index) {
    setState(() {
      currentIndexPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    mList = bankingCardList(); // Initialize mList
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              Text(
                isSwitch == true ? "Confirm Remove" : 'My Cards',
                style: primaryTextStyle(
                    color: Banking_TextColorPrimary,
                    size: 26,
                    fontFamily: fontBold),
              ),
              10.height,
              16.height,
              MyCardsSliderPage(updateCurrentIndex: updateCurrentIndex)
                  .visible(isSwitch == false),
              Center(
                child: isSwitch
                    ? PreviewCardPage(
                        card: mList[currentIndexPage],
                        cardIndex: currentIndexPage,
                      )
                    : SizedBox(), // Empty SizedBox when isSwitch is false
              ),
              16.height,
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

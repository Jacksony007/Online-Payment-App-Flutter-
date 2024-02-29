import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../model/BankingModel.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingDataGenerator.dart';
import '../utils/BankingImages.dart';
import '../utils/BankingStrings.dart';

class BankingSaving extends StatefulWidget {
  static var tag = "/BankingSaving";

  const BankingSaving({Key? key}) : super(key: key);

  @override
  _BankingSavingState createState() => _BankingSavingState();
}

class _BankingSavingState extends State<BankingSaving> {
  late List<BankingSavingModel> savingList;

  @override
  void initState() {
    super.initState();
    savingList = bankingSavingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        padding: const EdgeInsets.all(12),
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: context.height(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    Text(Banking_lbl_Saving_Online,
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 35)),
                    30.height,
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        BankingSavingModel data =
                            savingList[index % savingList.length];
                        return Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 0),
                          padding: const EdgeInsets.all(8),
                          decoration: boxDecorationWithShadow(
                              backgroundColor: Banking_whitePureColor,
                              boxShadow: defaultBoxShadow(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Banking_palColor),
                                padding: const EdgeInsets.all(16),
                                child: Image.asset(Banking_ic_piggyBank,
                                    height: 20, width: 20, fit: BoxFit.fill),
                              ).center(),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.title!,
                                      style: primaryTextStyle(
                                          color: Banking_TextColorPrimary,
                                          size: 18,
                                          fontFamily: fontMedium)),
                                  8.height,
                                  Text(data.rs!,
                                      style: primaryTextStyle(
                                          color: Banking_TextColorSecondary,
                                          size: 18)),
                                  2.height,
                                  Text(data.interest!,
                                      style: primaryTextStyle(
                                          color: Banking_TextColorSecondary,
                                          size: 18)),
                                ],
                              ).expand(),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(data.date!,
                                    style: primaryTextStyle(
                                        color: Banking_TextColorSecondary,
                                        size: 16)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

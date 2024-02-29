import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingImages.dart';
import '../User Model/MyCards.dart';
import 'PreviewCardPage.dart';

class MyCardsSliderPage extends StatefulWidget {
  static String tag = '/BankingSlider';

  final void Function(int index) updateCurrentIndex; // Add this line

  const MyCardsSliderPage({Key? key, required this.updateCurrentIndex})
      : super(key: key);

  @override
  MyCardsSliderStatePage createState() => MyCardsSliderStatePage();
}

class MyCardsSliderStatePage extends State<MyCardsSliderPage> {
  var currentIndexPage = 0;
  late List<MyCardsModel> mList;

  @override
  void initState() {
    super.initState();
    mList = bankingCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 8, right: 16),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Update the currentIndex in the parent widget
                  widget.updateCurrentIndex(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewCardPage(
                        card: mList[index],
                        cardIndex: index,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: 320,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: 320,
                        child: Image.asset(
                          Banking_ic_CardImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            24.height,
                            Row(
                              children: [
                                Text(
                                  mList[index].accountname.validate(),
                                  style: primaryTextStyle(
                                    color: Banking_whitePureColor,
                                    size: 18,
                                    fontFamily: fontMedium,
                                  ),
                                ).expand(),
                                Text(
                                  'PayFlow',
                                  style: primaryTextStyle(
                                    color: Banking_whitePureColor,
                                    size: 16,
                                    fontFamily: fontMedium,
                                  ),
                                )
                              ],
                            ),
                            24.height,
                            Text(
                              mList[index].bankname.validate(),
                              style: primaryTextStyle(
                                color: Banking_whitePureColor,
                                size: 18,
                                fontFamily: fontMedium,
                              ),
                            ),
                            4.height,
                            Text(
                              mList[index].accountNumber.validate(),
                              style: primaryTextStyle(
                                color: Banking_whitePureColor,
                                size: 18,
                                fontFamily: fontMedium,
                              ),
                            ),
                            8.height,
                            Text(
                              mList[index].expireDate.validate(),
                              style: primaryTextStyle(
                                color: Banking_whitePureColor,
                                size: 18,
                                fontFamily: fontMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.height,
                    ],
                  ).paddingRight(16),
                ),
              );
            },
          ),
        ),
        16.height,
        DotsIndicator(
          dotsCount: mList.length,
          position: currentIndexPage,
          decorator: const DotsDecorator(
            size: Size.square(5.0),
            activeSize: Size.square(8.0),
            color: Banking_greyColor,
            activeColor: Banking_blackColor,
          ),
        )
      ],
    );
  }
}

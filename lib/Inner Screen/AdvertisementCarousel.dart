import 'dart:async';
import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/model/AdvertisementModel.dart';
import 'package:free_flutter_ui_kits/utils/BankingColors.dart';
import 'package:free_flutter_ui_kits/utils/BankingContants.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementCarousel extends StatefulWidget {
  final List<AdvertisementModel> advertisementList;

  const AdvertisementCarousel({
    Key? key,
    required this.advertisementList,
  }) : super(key: key);

  @override
  _AdvertisementCarouselState createState() => _AdvertisementCarouselState();
}

class _AdvertisementCarouselState extends State<AdvertisementCarousel> {
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.page == widget.advertisementList.length - 1) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.advertisementList.length,
      itemBuilder: (context, index) {
        AdvertisementModel model = widget.advertisementList[index];
        return GestureDetector(
          onTap: () async {
            // Handle the click action here
            if (await canLaunchUrl(Uri.parse(model.link))) {
              await launchUrl(Uri.parse(model.link));
            } else {
              throw 'Could not launch ${model.link}';
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(model.imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          model.title,
                          style: const TextStyle(
                            color: Banking_TextColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontBold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          model.description,
                          style: const TextStyle(
                            color: Banking_TextColorWhite,
                            fontSize: 16,
                            fontFamily: fontRegular,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          model.callToAction,
                          style: const TextStyle(
                            color: Banking_TextColorWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

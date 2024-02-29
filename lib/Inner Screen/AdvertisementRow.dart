import 'dart:async';

import 'package:flutter/material.dart';

import '../model/FlightAdvertisement.dart';
import 'AdvertisementItems.dart';

class AdvertisementRow extends StatefulWidget {
  final List<Advertisement> advertisements;

  const AdvertisementRow({Key? key, required this.advertisements})
      : super(key: key);

  @override
  _AdvertisementRowState createState() => _AdvertisementRowState();
}

class _AdvertisementRowState extends State<AdvertisementRow> {
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.page == widget.advertisements.length - 1) {
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
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.advertisements.length,
        itemBuilder: (context, index) {
          return AdvertisementItem(
            advertisement: widget.advertisements[index],
          );
        },
      ),
    );
  }
}

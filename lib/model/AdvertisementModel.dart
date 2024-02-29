import 'package:flutter/material.dart';

class AdvertisementModel {
  final String imagePath;
  final String title;
  final String description;
  final String callToAction;
  final String link;
  final Color color; // Add this line

  AdvertisementModel({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.callToAction,
    required this.link,
    required this.color, // Add this line
  });
}

List<AdvertisementModel> advertisementList = [
  AdvertisementModel(
    imagePath: 'images/banking/Ruthy_2.jpg',
    title: 'Happy New Year',
    description: "Happy New Year, my dearest. 💖🎉 #2024Love",
    callToAction: 'Ruthy',
    link: 'https://console.firebase.google.com/u/0/',
    color: Colors
        .red, // Add a color for the first item, replace with your desired color
  ),
  AdvertisementModel(
    imagePath: 'images/banking/New_year.png',
    title: "Happy New Year from Payflow!",
    description:
        "Wishing our valued customers a prosperous New Year ahead! Thank you for choosing Payflow. Here's to success in 2024! 🎉🌟 #HappyNewYear",
    callToAction: 'Payflow 2024',
    link: 'https://www.youtube.com/',
    color: Colors
        .blue, // Add a color for the second item, replace with your desired color
  ),
  AdvertisementModel(
    imagePath: 'images/banking/payflow.jpeg',
    title: 'Payflow App',
    description:
        "Banking, Simplified. Download our app now! #EasyBanking📱💳 Share the App, Share the Perks! Banking made easy. 📱💸 #SpreadTheJoy",
    callToAction: 'Share Now',
    link: 'https://console.firebase.google.com/u/0/',
    color: Colors
        .green, // Add a color for the third item, replace with your desired color
  ),
];

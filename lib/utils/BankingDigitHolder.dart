import 'package:flutter/material.dart';

class DigitHolder extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final String code;
  const DigitHolder({
    required this.selectedIndex,
    //Key key,
    required this.width,
    required this.index,
    required this.code,
  }) ;

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: width * 0.10,
      width: width * 0.10,
      margin: EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: index == selectedIndex ? Colors.blue : Colors.transparent,
              offset: Offset(0, 0),
              spreadRadius: 1.5,


            )
          ]),
      child: code.length > index
          ? Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: Colors.black.withBlue(40),
          shape: BoxShape.circle,
        ),
      )
          : Container(),
    );
  }
}

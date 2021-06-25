import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style.dart';

class NoContent extends StatelessWidget {
  final String text;
  final String image;
  final String subText;
  final String infoText;

  const NoContent(
    this.text,
    this.image,
    this.subText,
    this.infoText,
  );

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            image,
            height: screenSize.height * 0.15,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            text == null ? '' : text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context)),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.2),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: subText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54)),
                  TextSpan(
                      text: infoText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

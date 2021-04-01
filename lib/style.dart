import 'package:flutter/material.dart';

const LargeTextSize = 26.0;
const MediumTextSize1 = 20.0;
const MediumTextSize2 = 15.0;
const BodyTextSize = 12.0;

const String FontNameDefault = 'Lato';

const AppBarTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w400,
  fontSize: MediumTextSize1,
  color: Colors.black,
);

const TitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w400,
  fontSize: LargeTextSize,
  color: Colors.black,
);

const CaptionTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.bold,
  fontSize: MediumTextSize2,
  color: Colors.black,
);

const Body1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w400,
  fontSize: BodyTextSize,
  color: Colors.black54,
);

double textHeader(BuildContext context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double customSize = 2.5;
  return customSize * unitHeightValue;
}

double textAppTitle(BuildContext context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double customSize = 2.5;
  return customSize * unitHeightValue;
}

double textSubTitle(BuildContext context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double customSize = 2.0;
  return customSize * unitHeightValue;
}

double textBody1(BuildContext context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double customSize = 1.8;
  return customSize * unitHeightValue;
}

double textButton(BuildContext context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double customSize = 1.6;
  return customSize * unitHeightValue;
}

double textbody2(BuildContext context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double customSize = 1.6;
  return customSize * unitHeightValue;
}
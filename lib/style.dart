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

double textH1(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.8;
  } else if (size.height < 680) {
    customSize = 3.2;
  } else {
    customSize = 3.0;
  }
  // print('H1: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

double textHeader(BuildContext context) {
  //2.8
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.5;
  } else if (size.height < 680) {
    customSize = 3.0;
  } else {
    customSize = 2.8;
  }
  // print('Header: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

double textAppTitle(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.3;
  } else if (size.height < 680) {
    customSize = 2.8;
  } else {
    customSize = 2.5;
  }
  // print('App Title: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

double textSubTitle(BuildContext context) {
  //2.35
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.0;
  } else if (size.height < 680) {
    customSize = 2.5;
  } else {
    customSize = 2.35;
  }
  // print('SubTitle: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

double textBody1(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.0;
  } else if (size.height < 680) {
    customSize = 2.5;
  } else {
    customSize = 2.35;
  }
  //print('Body1: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

double textButton(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.0;
  } else if (size.height < 680) {
    customSize = 2.5;
  } else {
    customSize = 2.35;
  }
  // print('Button: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

double textbody2(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double unitHeightValue = size.height * 0.01;
  double customSize;
  if (size.height > 685) {
    customSize = 2.0;
  } else if (size.height < 680) {
    customSize = 2.5;
  } else {
    customSize = 2.35;
  }
  // print('Body2: ${customSize * unitHeightValue}');
  return customSize * unitHeightValue;
}

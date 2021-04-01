import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style.dart';

class NoContent extends StatelessWidget {
  final String text;
  const NoContent(this.text);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/no_content.svg',
            height: screenSize.height * 0.3,
          ),
          Text(
            text == null ? '' : text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault, fontSize: textSubTitle(context)),
          ),
        ],
      ),
    );
  }
}

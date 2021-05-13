import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style.dart';

class NoContent extends StatelessWidget {
  final String text;
  final String image;
  final bool isAdmin;
  final String header;
  final String subText;
  const NoContent(
      this.text, this.image, this.isAdmin, this.header, this.subText);

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
                fontSize: textSubTitle(context)),
          ),
          SizedBox(
            height: 10.0,
          ),
          isAdmin
              ? Container(
                  height: screenSize.height * 0.05,
                  width: screenSize.width * 0.45,
                  alignment: Alignment.center,
                  child: OutlineButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(header,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context))),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.add_circle_outline,
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.2),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: header,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black)),
                        TextSpan(
                            text: subText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54))
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

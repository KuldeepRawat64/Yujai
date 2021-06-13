import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../style.dart';

class NoPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        left: screenSize.width * 0.05,
        right: screenSize.width * 0.05,
        top: screenSize.height * 0.025,
      ),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            // side: BorderSide(
            //   color: Colors.grey[300],
            // ),
          ),
        ),
        width: screenSize.width * 0.8,
        // height: MediaQuery.of(context).size.height * 0.3,
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(40.0)),
                      width: 40.0,
                      height: 40.0,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 12.0,
                          color: Colors.grey[200],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 120.0,
                          height: 12.0,
                          color: Colors.grey[200],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                      ],
                    ),
                  ]),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                  Container(
                    height: screenSize.height * 0.5,
                    width: screenSize.width,
                    color: Colors.grey[200],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.0,
                        height: 12.0,
                        color: Colors.grey[200],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 120.0,
                        height: 12.0,
                        color: Colors.grey[200],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                  child: Text(
                'No post to see',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

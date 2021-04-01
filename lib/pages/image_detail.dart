import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ImageDetail extends StatefulWidget {
  final String image;
  ImageDetail({Key key, this.image}) : super(key: key);

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          title: Text(
            'Detail',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          // centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Container(
            child: CachedNetworkImage(
              filterQuality: FilterQuality.medium,
              fadeInCurve: Curves.easeIn,
              fadeOutCurve: Curves.easeOut,
              imageUrl: widget.image,
              placeholder: ((context, s) => Center(
                    child: CircularProgressIndicator(),
                  )),
              // width: screenSize.width,
              //height: screenSize.height * 0.4,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../style.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        // top: screenSize.height * 0.005,
        left: screenSize.width * 0.1,
      ),
      child: Container(
        child: _item.isSelected
            ? Chip(
                labelPadding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.005),
                backgroundColor: Colors.deepPurple[50],
                label: Text(
                  _item.text,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textButton(context),
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: screenSize.height * 0.015,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      _item.subText,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        //  fontSize: textAppTitle(context),
                        color: Colors.grey,
                        //   fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class RadioItem2 extends StatelessWidget {
  final RadioModel _item;
  RadioItem2(this._item);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        // top: screenSize.height * 0.005,
        left: screenSize.width * 0.1,
      ),
      child: Container(
        child: _item.isSelected
            ? Chip(
                backgroundColor: Colors.deepPurple[50],
                label: Text(
                  _item.text,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textButton(context),
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: screenSize.height * 0.015,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      _item.subText,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        //  fontSize: textAppTitle(context),
                        color: Colors.grey,
                        //   fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;

  final String text;
  final String subText;
  RadioModel(this.isSelected, this.text, this.subText);
}

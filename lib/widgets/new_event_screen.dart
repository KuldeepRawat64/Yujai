import 'package:flutter/material.dart';
import 'package:Yujai/pages/new_event_form.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';

class NewEventScreen extends StatefulWidget {
  final Group group;
  final User currentUser;

  const NewEventScreen({Key key, this.group, this.currentUser})
      : super(key: key);

  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  bool isOnline = false;
  bool isClicked = false;
  int _widgetId = 1;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: screenSize.height * 0.95,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenSize.height * 0.01,
                      top: screenSize.height * 0.02,
                      //left: screenSize.width * 0.05,
                      // right: screenSize.width * 0.05
                    ),
                    child: Text(
                      'New Event',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textHeader(context),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenSize.height * 0.01,
                      top: screenSize.height * 0.02,
                      //left: screenSize.width * 0.05,
                      //right: screenSize.width * 0.05
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              !isClicked
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenSize.height * 0.2,
                        ),
                        Text(
                          'Select Event Type',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textAppTitle(context),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenSize.height * 0.05,
                              left: screenSize.width * 0.01,
                              right: screenSize.width * 0.01),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isClicked = true;
                                _widgetId = 1;
                              });
                            },
                            child: Container(
                                width: screenSize.width * 0.8,
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(screenSize.height * 0.015),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.web_asset_outlined,
                                            color:
                                                Theme.of(context).accentColor),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Online',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textAppTitle(context),
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenSize.height * 0.05,
                              left: screenSize.width * 0.01,
                              right: screenSize.width * 0.01),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isClicked = true;
                                _widgetId = 2;
                              });
                            },
                            child: Container(
                                width: screenSize.width * 0.8,
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(screenSize.height * 0.015),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_city_rounded,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Offline',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textAppTitle(context),
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  : _renderWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderWidget1() {
    return Container(
        key: Key('First'),
        child: NewEventForm(
          isOnline: true,
          group: widget.group,
          currentUser: widget.currentUser,
        ));
  }

  Widget _renderWidget2() {
    return Container(
        key: Key('Second'),
        child: NewEventForm(
          isOnline: false,
          group: widget.group,
          currentUser: widget.currentUser,
        ));
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _renderWidget1() : _renderWidget2();
  }
}

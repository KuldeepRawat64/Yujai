import 'package:Yujai/pages/edit_edu_form.dart';
import 'package:Yujai/pages/edit_profile_form.dart';
import 'package:Yujai/pages/new_education_form.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/new_post_form.dart';
import 'package:intl/intl.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';

class EditProfileEducation extends StatefulWidget {
  final User currentUser;

  const EditProfileEducation({Key key, this.currentUser}) : super(key: key);

  @override
  _EditProfileEducationState createState() => _EditProfileEducationState();
}

class _EditProfileEducationState extends State<EditProfileEducation> {
  bool isOnline = false;
  bool isClicked = false;
  int _widgetId = 1;
  Map<String, dynamic> currentEd;

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.currentUser.education == null) {
  //     isClicked = !isClicked;
  //     _widgetId = 2;
  //   }
  // }

  Widget getEducations(List<dynamic> education) {
    return Column(
      children: education != null
          ? education
              .map((e) => ListTile(
                    onTap: () {
                      setState(() {
                        isClicked = true;
                        _widgetId = 1;
                        currentEd = e;
                      });
                    },
                    //  isThreeLine: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${convertDate(e['startUniversity'])} - ${e['isPresent'] == true ? 'Present' : convertDate(e['endUniversity'])}',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['field'],
                          style: TextStyle(
                            //   color: Colors.black,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          e['university'],
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            //    fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ))
              .toList()
          : Container(),
    );
  }

  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.yMMM().format(date);
    return formattedDate;
  }

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
            //shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: screenSize.height * 0.01,
                        top: screenSize.height * 0.02,
                        left: screenSize.width * 0.05,
                        right: screenSize.width * 0.05),
                    child: !isClicked
                        ? Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textHeader(context),
                                fontWeight: FontWeight.bold),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                isClicked = !isClicked;
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.black54,
                              ),
                            )
                            //  Text(
                            //   'Cancel',
                            //   style: TextStyle(
                            //     fontFamily: FontNameDefault,
                            //     fontSize: textSubTitle(context),
                            //     //fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: screenSize.height * 0.01,
                        top: screenSize.height * 0.02,
                        left: screenSize.width * 0.05,
                        right: screenSize.width * 0.05),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            Icons.close,
                            color: Colors.black54,
                          ),
                        )
                        //  Text(
                        //   'Cancel',
                        //   style: TextStyle(
                        //     fontFamily: FontNameDefault,
                        //     fontSize: textSubTitle(context),
                        //     //fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        ),
                  )
                ],
              ),
              !isClicked
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenSize.height * 0.05,
                              left: screenSize.width * 0.05,
                              right: screenSize.width * 0.05),
                          child: widget.currentUser.education.isEmpty
                              ? Text(
                                  'Add educational backgrounds so people will know about it.',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textAppTitle(context),
                                    //  fontWeight: FontWeight.bold,
                                  ),
                                )
                              : getEducations(widget.currentUser.education),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenSize.height * 0.05,
                              left: screenSize.width * 0.05,
                              right: screenSize.width * 0.05),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isClicked = true;
                                _widgetId = 2;
                              });
                            },
                            child: Container(
                                //    width: screenSize.width * 0.8,
                                decoration: ShapeDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(screenSize.height * 0.015),
                                  child: Center(
                                    child: Text(
                                      'Add education',
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textAppTitle(context),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  : _renderWidget(),
              // Container(
              //   child: EditEducationForm(
              //     currentUser: widget.currentUser,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderWidget1() {
    return Container(
      key: Key('First'),
      child: EditEducationForm(
        education: currentEd,
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _renderWidget2() {
    return Container(
      key: Key('Second'),
      child: NewEducationForm(
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _renderWidget1() : _renderWidget2();
  }
}

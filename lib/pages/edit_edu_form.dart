import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';

class EditEducationForm extends StatefulWidget {
  final UserModel currentUser;
  final Map<String, dynamic> education;

  EditEducationForm({this.currentUser, this.education});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditEducationForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  User currentUser;
  final _universityController = TextEditingController();
  final _fieldController = TextEditingController();
  final _degreeController = TextEditingController();
  bool isChecked = false;
  int startDate = 0;
  int endDate = 0;
  int id = 0;

  @override
  void initState() {
    super.initState();
    getData();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  File imageFile;

  getData() {
    _universityController.text = widget.education['university'] ?? '';
    startDate = widget.education['startUniversity'] ?? 0;
    endDate = widget.education['endUniversity'] ?? 0;
    _fieldController.text = widget.education['field'] ?? '';
    _degreeController.text = widget.education['degree'] ?? '';
    isChecked = widget.education['isPresent'];
  }

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'education': FieldValue.arrayUnion(<Map<String, dynamic>>[
          {
            'university': _universityController.text,
            'field': _fieldController.text,
            'degree': _degreeController.text,
            'startUniversity': startDate,
            'endUniversity': endDate,
            'isPresent': isChecked
          }
        ])
      });

      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  DateTime checkInitialValue(int milis) {
    return DateTime.fromMillisecondsSinceEpoch(milis);
  }

  deleteDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              //    overflow: Overflow.visible,
              children: [
                Wrap(
                  children: <Widget>[
                    Container(
                        height: screenSize.height * 0.09,
                        child: Text(
                          'Are you sure you want to delete this education?',
                          style: TextStyle(color: Colors.black54),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              deletePost();
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }

  deletePost() {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'education': FieldValue.arrayRemove([widget.education])
    }).then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.04,
            screenSize.height * 0.05,
            screenSize.width * 0.04,
            screenSize.height * 0.1,
          ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _universityController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        //   hintText: 'University',
                        labelText: 'University',
                        labelStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.grey,
                          fontSize: textSubTitle(context),
                          //fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please enter name of your university/college";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    TextFormField(
                      autocorrect: true,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _fieldController,
                      decoration: InputDecoration(
                        icon: IconButton(
                          icon: Icon(
                            MdiIcons.bookshelf,
                            color: Colors.black54,
                            size: 30,
                          ),
                          onPressed: null,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        //   hintText: 'Field of Study',
                        labelText: 'Field of Study',
                        labelStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.grey,
                          fontSize: textSubTitle(context),
                          //fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please enter your field of study";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    TextFormField(
                      autocorrect: true,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _degreeController,
                      decoration: InputDecoration(
                        icon: IconButton(
                          icon: Icon(
                            Icons.school_outlined,
                            color: Colors.black54,
                            size: 30,
                          ),
                          onPressed: null,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        //   hintText: 'Field of Study',
                        labelText: 'Degree',
                        labelStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.grey,
                          fontSize: textSubTitle(context),
                          //fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return "Please enter your degree";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenSize.width * 0.46,
                          child: DateTimeFormField(
                            initialValue: checkInitialValue(startDate),
                            dateTextStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              //    fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                isDense: true,
                                icon: IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.black54,
                                    size: 25,
                                  ),
                                  onPressed: null,
                                ),
                                labelText: 'Start Date',
                                hintStyle: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.grey,
                                  fontSize: textSubTitle(context),
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none),
                            mode: DateTimeFieldPickerMode.date,
                            //      autovalidateMode: AutovalidateMode.always,
                            onDateSelected: (DateTime value) {
                              setState(() {
                                startDate = value.millisecondsSinceEpoch;
                              });
                              print(value);
                            },
                            // onSaved: (DateTime value) {
                            //   setState(() {
                            //     startDate = value.millisecondsSinceEpoch;
                            //   });
                            // },
                            validator: (DateTime value) {
                              if (value == null) {
                                return 'Enter date';
                              } else {
                                if (value.millisecondsSinceEpoch == endDate ||
                                    value.millisecondsSinceEpoch > endDate &&
                                        endDate != 0) {
                                  return 'Incorrect date';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                        !isChecked
                            ? Container(
                                width: screenSize.width * 0.31,
                                child: DateTimeFormField(
                                  initialValue: checkInitialValue(endDate),
                                  dateTextStyle: TextStyle(
                                    fontFamily: FontNameDefault,
                                    //   fontSize: textSubTitle(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      isDense: true,
                                      labelText: 'End Date',
                                      hintStyle: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.grey,
                                        fontSize: textSubTitle(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      border: InputBorder.none),
                                  mode: DateTimeFieldPickerMode.date,
                                  //   autovalidateMode: AutovalidateMode.always,
                                  // onSaved: (DateTime value) {
                                  //   setState(() {
                                  //     endDate = value.millisecondsSinceEpoch;
                                  //   });
                                  // },
                                  onDateSelected: (DateTime value) {
                                    setState(() {
                                      endDate = value.millisecondsSinceEpoch;
                                    });
                                    print(value);
                                  },
                                  validator: (DateTime value) {
                                    if (value == null) {
                                      return 'Enter date';
                                    } else {
                                      if (value.millisecondsSinceEpoch ==
                                              startDate ||
                                          value.millisecondsSinceEpoch <
                                              startDate) {
                                        return 'Incorrect date';
                                      }
                                      return null;
                                    }
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            activeColor: Theme.of(context).accentColor,
                            value: isChecked,
                            onChanged: (val) {
                              setState(() {
                                isChecked = val;
                              });
                            }),
                        Text('Present')
                      ],
                    ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     top: screenSize.height * 0.02,
                //     bottom: screenSize.height * 0.01,
                //   ),
                //   child: InkWell(
                //     onTap: () {
                //       submit(context);
                //     },
                //     child: Container(
                //         height: screenSize.height * 0.07,
                //         //  width: screenSize.width * 0.8,
                //         decoration: ShapeDecoration(
                //             color: Theme.of(context).primaryColor,
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(8.0))),
                //         child: Padding(
                //           padding: EdgeInsets.all(screenSize.height * 0.015),
                //           child: Center(
                //             child: Text(
                //               'Update',
                //               style: TextStyle(
                //                 fontFamily: FontNameDefault,
                //                 fontSize: textAppTitle(context),
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //         )),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.02,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      deleteDialog();
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //  width: screenSize.width * 0.8,
                        decoration: ShapeDecoration(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red[50]),
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.015),
                          child: Center(
                            child: Text(
                              'Delete',
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}

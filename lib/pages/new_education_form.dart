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

class NewEducationForm extends StatefulWidget {
  final User currentUser;

  NewEducationForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<NewEducationForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  FirebaseUser currentUser;
  final _universityController = TextEditingController();
  final _fieldController = TextEditingController();
  final _degreeController = TextEditingController();
  bool isChecked = false;
  int startDate = 0;
  int endDate = 0;

  @override
  void initState() {
    super.initState();
    // getData();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  File imageFile;

  // getData() {
  //   _universityController.text =
  //       widget.currentUser.education['university'] ?? '';
  //   startDate = widget.currentUser.education['startUniversity'] ?? 0;
  //   endDate = widget.currentUser.education['endUniversity'] ?? 0;
  //   _fieldController.text = widget.currentUser.education['field'] ?? '';
  //   if (widget.currentUser.certifications.length == 1) {
  //     _degreeController.text = widget.currentUser.certifications[0] ?? '';
  //   } else if (widget.currentUser.certifications.length == 2) {
  //     _degreeController.text = widget.currentUser.certifications[0] ?? '';
  //     _cert2Controller.text = widget.currentUser.certifications[1] ?? '';
  //   }
  //   if (widget.currentUser.certifications.length == 3) {
  //     _degreeController.text = widget.currentUser.certifications[0] ?? '';
  //     _cert2Controller.text = widget.currentUser.certifications[1] ?? '';
  //     _cert3Controller.text = widget.currentUser.certifications[2] ?? '';
  //   }
  // }

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Firestore.instance
              .collection('users')
              .document(currentUser.uid)
              .updateData({
        'education': FieldValue.arrayUnion([
          {
            'university': _universityController.text,
            'field': _fieldController.text,
            'degree': _degreeController.text,
            'startUniversity': startDate,
            'endUniversity': endDate,
            'isPresent': isChecked
          }
        ])
      })
          // .then((value) {
          //   Firestore.instance
          //       .collection('users')
          //       .document(currentUser.uid)
          //       .updateData({
          //     'certifications': [
          //       _degreeController.text,
          //       _cert2Controller.text,
          //       _cert3Controller.text
          //     ]
          //   });
          // })
          ;

      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  DateTime checkInitialValue(int milis) {
    return DateTime.fromMillisecondsSinceEpoch(milis);
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
                            //      initialValue: checkInitialValue(startDate),
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
                                  //   initialValue: checkInitialValue(endDate),
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
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.02,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      submit(context);
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //  width: screenSize.width * 0.8,
                        decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.015),
                          child: Center(
                            child: Text(
                              'Save',
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

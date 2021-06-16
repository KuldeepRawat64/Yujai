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

class EditExperienceForm extends StatefulWidget {
  final UserModel currentUser;
  final Map<String, dynamic> experience;
  EditExperienceForm({this.currentUser, this.experience});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditExperienceForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  User currentUser;
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  int startDate = 0;
  int endDate = 0;
  int id = 0;
  int index = 0;
  bool isChecked = false;
  String valueEmpType;
  String valueIndustry;
  List typeItems = [
    'Full-time employee',
    'Part-time employee',
    'Intern',
    'Owner',
    'Board member',
    'Volunteer',
    'Freelancer',
    'Self-employed',
    'Partner',
    'Shareholder',
    'Civil servant',
    'Recruiter',
  ];
  List industries = [
    'Architecture and planning',
    'Art, culture and sport',
    'Auditing, tax and law',
    'Automotive and vehicle manufacturing',
    'Banking and financial services',
    'Civil service, associations and institutions',
    'Consulting',
    'Consumer goods and trade',
    'Education and science',
    'Energy, water and environment',
    'HR services',
    'Health and social',
    'Insurance',
    'Internet and IT',
    'Marketing, PR and design',
    'Media and publishing',
    'Medical services',
    'Other services',
    'Real Estate',
    'Telecommunication',
    'Tourism and food service',
    'Transport and logistics',
  ];

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

  getData() {
    _companyController.text = widget.experience['company'] ?? '';
    startDate = widget.experience['startCompany'] ?? 0;
    endDate = widget.experience['endCompany'] ?? 0;
    _designationController.text = widget.experience['designation'] ?? '';
    valueEmpType = widget.experience['employmentType'] ?? '';
    valueIndustry = widget.experience['industry'] ?? '';
    isChecked = widget.experience['isPresent'];
  }

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'experience': FieldValue.arrayUnion([
          {
            'company': _companyController.text,
            'designation': _designationController.text,
            'startCompany': startDate,
            'endCompany': endDate,
            'isPresent': isChecked,
            'employmentType': valueEmpType,
            'industry': valueIndustry
          },
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
      'experience': FieldValue.arrayRemove([widget.experience])
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _designationController,
                  decoration: InputDecoration(
                    // icon: Icon(
                    //   Icons.work_outline,
                    //   size: screenSize.height * 0.035,
                    //   color: Colors.black54,
                    // ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    //   hintText: 'Designation',
                    labelText: 'Designation',
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
                      return "Please enter a designation that describes your work";
                    return null;
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        border: InputBorder.none),
                    hint: Text(
                      'Employment type',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    // underline: Container(),
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    iconSize: 30,
                    isExpanded: true,
                    value: valueEmpType,
                    items: typeItems.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              )));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        valueEmpType = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null)
                        return 'Please select an employment type';
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                //Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _companyController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        //     hintText: 'Company Name',
                        labelText: 'Company Name',
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
                          return 'Please enter your company name';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: InputBorder.none),
                        hint: Text(
                          'Industry',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: textSubTitle(context),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        //  underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 30,
                        isExpanded: true,
                        value: valueIndustry,
                        items: industries.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  )));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            valueIndustry = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Please select an industry';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.calendar_today,
                                        size: screenSize.height * 0.035,
                                        color: Colors.black54,
                                      ),
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
                                //   autovalidateMode: AutovalidateMode.always,
                                onDateSelected: (DateTime value) {
                                  setState(() {
                                    startDate = value.millisecondsSinceEpoch;
                                  });
                                },
                                // onSaved: (DateTime value) {
                                //   startDate = value.millisecondsSinceEpoch;
                                // },
                                validator: (DateTime value) {
                                  if (value == null) {
                                    return 'Enter date';
                                  } else {
                                    if (value.millisecondsSinceEpoch ==
                                            endDate ||
                                        value.millisecondsSinceEpoch >
                                            endDate) {
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
                                      //   endDate = value.millisecondsSinceEpoch;
                                      // },
                                      onDateSelected: (DateTime value) {
                                        setState(() {
                                          endDate =
                                              value.millisecondsSinceEpoch;
                                        });
                                        //  print(value);
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
                          height: screenSize.height * 0.02,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(screenSize.height * 0.015),
                                  child: Center(
                                    child: Text(
                                      'Add experience',
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
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(screenSize.height * 0.015),
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
              ]),
            ])));
  }
}

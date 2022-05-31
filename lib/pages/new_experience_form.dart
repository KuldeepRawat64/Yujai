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
import 'package:path_provider/path_provider.dart';

class NewExperienceForm extends StatefulWidget {
  final UserModel currentUser;

  NewExperienceForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<NewExperienceForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  User currentUser;
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  int startDate = DateTime.now().millisecondsSinceEpoch;
  int endDate = DateTime.now().millisecondsSinceEpoch;
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
    //getData();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    // _dropDownMenuEmploymentType =
    //     buildDropDownMenuEmploymentType(_employmentType);
    // _selectedEmploymentType = _dropDownMenuEmploymentType[0].value;
    // _dropDownMenuIndustry = buildDropDownMenuIndustry(_industry);
    // _selectedIndustry = _dropDownMenuIndustry[0].value;
  }

  // getData() {
  //   if (widget.currentUser.experience.length == 1) {
  //     _companyController.text =
  //         widget.currentUser.experience.values.elementAt(0)['company'] ?? '';
  //     startDate =
  //         widget.currentUser.experience.values.elementAt(0)['startCompany'] ??
  //             0;
  //     endDate =
  //         widget.currentUser.experience.values.elementAt(0)['endCompany'] ?? 0;
  //     _designationController.text =
  //         widget.currentUser.experience.values.elementAt(0)['designation'] ??
  //             '';
  //   } else if (widget.currentUser.experience.length == 2) {
  //     _companyController.text =
  //         widget.currentUser.experience.values.elementAt(0)['company'] ?? '';
  //     startDate =
  //         widget.currentUser.experience.values.elementAt(0)['startCompany'] ??
  //             0;
  //     endDate =
  //         widget.currentUser.experience.values.elementAt(0)['endCompany'] ?? 0;
  //     _designationController.text =
  //         widget.currentUser.experience.values.elementAt(0)['designation'] ??
  //             '';
  //     _company2Controller.text =
  //         widget.currentUser.experience.values.elementAt(1)['company'] ?? '';
  //     startDate2 =
  //         widget.currentUser.experience.values.elementAt(1)['startCompany'] ??
  //             0;
  //     endDate2 =
  //         widget.currentUser.experience.values.elementAt(1)['endCompany'] ?? 0;
  //     _designation2Controller.text =
  //         widget.currentUser.experience.values.elementAt(1)['designation'] ??
  //             '';
  //   } else if (widget.currentUser.experience.length == 3) {
  //     _companyController.text =
  //         widget.currentUser.experience.values.elementAt(0)['company'] ?? '';
  //     startDate =
  //         widget.currentUser.experience.values.elementAt(0)['startCompany'] ??
  //             0;
  //     endDate =
  //         widget.currentUser.experience.values.elementAt(0)['endCompany'] ?? 0;
  //     _designationController.text =
  //         widget.currentUser.experience.values.elementAt(0)['designation'] ??
  //             '';
  //     _company2Controller.text =
  //         widget.currentUser.experience.values.elementAt(1)['company'] ?? '';
  //     startDate2 =
  //         widget.currentUser.experience.values.elementAt(1)['startCompany'] ??
  //             0;
  //     endDate2 =
  //         widget.currentUser.experience.values.elementAt(1)['endCompany'] ?? 0;
  //     _designation2Controller.text =
  //         widget.currentUser.experience.values.elementAt(1)['designation'] ??
  //             '';
  //     _company3Controller.text =
  //         widget.currentUser.experience.values.elementAt(1)['company'] ?? '';
  //     startDate3 =
  //         widget.currentUser.experience.values.elementAt(1)['startCompany'] ??
  //             0;
  //     endDate3 =
  //         widget.currentUser.experience.values.elementAt(1)['endCompany'] ?? 0;
  //     _designation3Controller.text =
  //         widget.currentUser.experience.values.elementAt(1)['designation'] ??
  //             '';
  //   }
  // }
  List<DropdownMenuItem<EmploymentType>> buildDropDownMenuEmploymentType(
      List employmentTypes) {
    List<DropdownMenuItem<EmploymentType>> items = [];
    for (EmploymentType employmentType in employmentTypes) {
      items.add(
        DropdownMenuItem(
          value: employmentType,
          child: Text(employmentType.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Industry>> buildDropDownMenuIndustry(List industrys) {
    List<DropdownMenuItem<Industry>> items = [];
    for (Industry industry in industrys) {
      items.add(
        DropdownMenuItem(
          value: industry,
          child: Text(industry.name),
        ),
      );
    }
    return items;
  }

  File imageFile;

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
      // if (_company2Controller.text.isNotEmpty &&
      //     _company3Controller.text.isEmpty) {
      //   Firestore.instance
      //       .collection('users')
      //       .document(currentUser.uid)
      //       .updateData({
      //     'experience': ({
      //       '0': {
      //         'company': _companyController.text,
      //         'designation': _designationController.text,
      //         'startCompany': startDate,
      //         'endCompany': endDate
      //       },
      //       '1': {
      //         'company': _company2Controller.text,
      //         'designation': _designation2Controller.text,
      //         'startCompany': startDate2,
      //         'endCompany': endDate2
      //       },
      //     })
      //   });
      // } else if (_company3Controller.text.isNotEmpty &&
      //     _company2Controller.text.isEmpty) {
      //   Firestore.instance
      //       .collection('users')
      //       .document(currentUser.uid)
      //       .updateData({
      //     'experience': ({
      //       '0': {
      //         'company': _companyController.text,
      //         'designation': _designationController.text,
      //         'startCompany': startDate,
      //         'endCompany': endDate
      //       },
      //       '1': {
      //         'company': _company3Controller.text,
      //         'designation': _designation3Controller.text,
      //         'startCompany': startDate3,
      //         'endCompany': endDate3
      //       },
      //     })
      //   });
      // } else if (_company2Controller.text.isEmpty &&
      //     _company3Controller.text.isEmpty) {
      //   Firestore.instance
      //       .collection('users')
      //       .document(currentUser.uid)
      //       .updateData({
      //     'experience': ({
      //       '0': {
      //         'company': _companyController.text,
      //         'designation': _designationController.text,
      //         'startCompany': startDate,
      //         'endCompany': endDate
      //       },
      //     })
      //   });
      // } else if (_companyController.text.isNotEmpty &&
      //     _company2Controller.text.isNotEmpty &&
      //     _company3Controller.text.isNotEmpty) {
      //   Firestore.instance
      //       .collection('users')
      //       .document(currentUser.uid)
      //       .updateData({
      //     'experience': ({
      //       '0': {
      //         'company': _companyController.text,
      //         'designation': _designationController.text,
      //         'startCompany': startDate,
      //         'endCompany': endDate
      //       },
      //       '1': {
      //         'company': _company2Controller.text,
      //         'designation': _designation2Controller.text,
      //         'startCompany': startDate2,
      //         'endCompany': endDate2
      //       },
      //       '2': {
      //         'company': _company3Controller.text,
      //         'designation': _designation3Controller.text,
      //         'startCompany': startDate3,
      //         'endCompany': endDate3
      //       },
      //     })
      //   });
      // }

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
                  screenSize.height * 0.01,
                  screenSize.width * 0.04,
                  screenSize.height * 0.1,
                ),
                children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                // TextFormField(
                //   textCapitalization: TextCapitalization.words,
                //   style: TextStyle(
                //     fontFamily: FontNameDefault,
                //     fontSize: textSubTitle(context),
                //     fontWeight: FontWeight.bold,
                //   ),
                //   controller: _companyController,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.grey[100],
                //     //  hintText: 'Company Name',
                //     labelText: 'Company Name',
                //     labelStyle: TextStyle(
                //       fontFamily: FontNameDefault,
                //       color: Colors.grey,
                //       fontSize: textSubTitle(context),
                //       //fontWeight: FontWeight.bold,
                //     ),
                //     border: InputBorder.none,
                //     isDense: true,
                //   ),
                //   validator: (value) {
                //     if (value.isEmpty)
                //       return "Please enter the name of your recent company";
                //     return null;
                //   },
                // ),

                // SizedBox(
                //   height: screenSize.height * 0.02,
                // ),
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
                    // SizedBox(
                    //   height: screenSize.height * 0.02,
                    // ),
                    // TextFormField(
                    //   textCapitalization: TextCapitalization.words,
                    //   style: TextStyle(
                    //     fontFamily: FontNameDefault,
                    //     fontSize: textSubTitle(context),
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   controller: _designation2Controller,
                    //   decoration: InputDecoration(
                    //     icon: Icon(
                    //       Icons.work_outline,
                    //       size: screenSize.height * 0.035,
                    //       color: Colors.black54,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.grey[100],
                    //     //     hintText: 'Designation',
                    //     labelText: 'Designation',
                    //     labelStyle: TextStyle(
                    //       fontFamily: FontNameDefault,
                    //       color: Colors.grey,
                    //       fontSize: textSubTitle(context),
                    //       //fontWeight: FontWeight.bold,
                    //     ),
                    //     border: InputBorder.none,
                    //     isDense: true,
                    //   ),
                    //   validator: (value) {
                    //     if (_company2Controller.text.isNotEmpty &&
                    //         value.isEmpty)
                    //       return "Please enter a designation that describes your work";
                    //     return null;
                    //   },
                    // ),
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       width: screenSize.width * 0.46,
                    //       child: DateTimeFormField(
                    //         initialValue: checkInitialValue(startDate2),
                    //         dateTextStyle: TextStyle(
                    //           fontFamily: FontNameDefault,
                    //           //    fontSize: textSubTitle(context),
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         decoration: InputDecoration(
                    //             filled: true,
                    //             fillColor: Colors.grey[100],
                    //             isDense: true,
                    //             icon: Icon(
                    //               Icons.calendar_today,
                    //               size: screenSize.height * 0.035,
                    //               color: Colors.black54,
                    //             ),
                    //             labelText: 'Start Date',
                    //             hintStyle: TextStyle(
                    //               fontFamily: FontNameDefault,
                    //               color: Colors.grey,
                    //               fontSize: textSubTitle(context),
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //             border: InputBorder.none),
                    //         mode: DateTimeFieldPickerMode.date,
                    //         autovalidateMode: AutovalidateMode.always,
                    //         onDateSelected: (DateTime value) {
                    //           setState(() {
                    //             startDate2 = value.millisecondsSinceEpoch;
                    //           });
                    //           //      print(value);
                    //         },
                    //         onSaved: (DateTime value) {
                    //           startDate2 = value.millisecondsSinceEpoch;
                    //         },
                    //         validator: (DateTime value) {
                    //           if (_company2Controller.text.isNotEmpty &&
                    //               _designation2Controller.text.isNotEmpty &&
                    //               value == null) {
                    //             // if (value == null ||
                    //             //     value.millisecondsSinceEpoch ==
                    //             //         initialEndValue2.millisecondsSinceEpoch)
                    //             //   return 'Invalid date';

                    //             return 'Invalid date';
                    //           }

                    //           return null;
                    //         },
                    //       ),
                    //     ),
                    //     Container(
                    //       width: screenSize.width * 0.31,
                    //       child: DateTimeFormField(
                    //         initialValue: checkInitialValue(endDate2),
                    //         dateTextStyle: TextStyle(
                    //           fontFamily: FontNameDefault,
                    //           //   fontSize: textSubTitle(context),
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         decoration: InputDecoration(
                    //             filled: true,
                    //             fillColor: Colors.grey[100],
                    //             isDense: true,
                    //             labelText: 'End Date',
                    //             hintStyle: TextStyle(
                    //               fontFamily: FontNameDefault,
                    //               color: Colors.grey,
                    //               fontSize: textSubTitle(context),
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //             border: InputBorder.none),
                    //         mode: DateTimeFieldPickerMode.date,
                    //         autovalidateMode: AutovalidateMode.always,
                    //         onSaved: (DateTime value) {
                    //           endDate2 = value.millisecondsSinceEpoch;
                    //         },
                    //         onDateSelected: (DateTime value) {
                    //           setState(() {
                    //             endDate2 = value.millisecondsSinceEpoch;
                    //           });
                    //           //     print(value);
                    //         },
                    //         validator: (DateTime value) {
                    //           if (_company2Controller.text.isNotEmpty &&
                    //               _designation2Controller.text.isNotEmpty &&
                    //               value == null) {
                    //             // if (value == null ||
                    //             //     value.millisecondsSinceEpoch ==
                    //             //         initialStartValue2
                    //             //             .millisecondsSinceEpoch)
                    //             //   return 'Invalid date';

                    //             return 'Invalid date';
                    //           }

                    //           return null;
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // TextFormField(
                        //   textCapitalization: TextCapitalization.words,
                        //   style: TextStyle(
                        //     fontFamily: FontNameDefault,
                        //     fontSize: textSubTitle(context),
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        //   controller: _companyController,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[100],
                        //     //     hintText: 'Company Name',
                        //     labelText: 'Company Name',
                        //     labelStyle: TextStyle(
                        //       fontFamily: FontNameDefault,
                        //       color: Colors.grey,
                        //       fontSize: textSubTitle(context),
                        //       //fontWeight: FontWeight.bold,
                        //     ),
                        //     border: InputBorder.none,
                        //     isDense: true,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: screenSize.height * 0.02,
                        // ),
                        // TextFormField(
                        //   textCapitalization: TextCapitalization.words,
                        //   style: TextStyle(
                        //     fontFamily: FontNameDefault,
                        //     fontSize: textSubTitle(context),
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        //   controller: _designation3Controller,
                        //   decoration: InputDecoration(
                        //     icon: Icon(
                        //       Icons.work_outline,
                        //       size: screenSize.height * 0.035,
                        //       color: Colors.black54,
                        //     ),
                        //     filled: true,
                        //     fillColor: Colors.grey[100],
                        //     //      hintText: 'Designation',
                        //     labelText: 'Designation',
                        //     labelStyle: TextStyle(
                        //       fontFamily: FontNameDefault,
                        //       color: Colors.grey,
                        //       fontSize: textSubTitle(context),
                        //       //fontWeight: FontWeight.bold,
                        //     ),
                        //     border: InputBorder.none,
                        //     isDense: true,
                        //   ),
                        //   validator: (value) {
                        //     if (_company3Controller.text.isNotEmpty &&
                        //         value.isEmpty)
                        //       return "Please enter a designation that describes your work";
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: screenSize.height * 0.02,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //       width: screenSize.width * 0.46,
                        //       child: DateTimeFormField(
                        //         initialValue: checkInitialValue(startDate3),
                        //         dateTextStyle: TextStyle(
                        //           fontFamily: FontNameDefault,
                        //           //    fontSize: textSubTitle(context),
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //         decoration: InputDecoration(
                        //             filled: true,
                        //             fillColor: Colors.grey[100],
                        //             isDense: true,
                        //             icon: Icon(
                        //               Icons.calendar_today,
                        //               size: screenSize.height * 0.035,
                        //               color: Colors.black54,
                        //             ),
                        //             labelText: 'Start Date',
                        //             hintStyle: TextStyle(
                        //               fontFamily: FontNameDefault,
                        //               color: Colors.grey,
                        //               fontSize: textSubTitle(context),
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //             border: InputBorder.none),
                        //         mode: DateTimeFieldPickerMode.date,
                        //         autovalidateMode: AutovalidateMode.always,
                        //         onDateSelected: (DateTime value) {
                        //           setState(() {
                        //             startDate3 = value.millisecondsSinceEpoch;
                        //           });
                        //           //       print(value);
                        //         },
                        //         onSaved: (DateTime value) {
                        //           startDate3 = value.millisecondsSinceEpoch;
                        //         },
                        //         validator: (DateTime value) {
                        //           if (_company3Controller.text.isNotEmpty &&
                        //               _designation3Controller.text.isNotEmpty &&
                        //               value == null) {
                        //             return 'Invalid date';
                        //           }

                        //           return null;
                        //         },
                        //       ),
                        //     ),
                        //     Container(
                        //       width: screenSize.width * 0.31,
                        //       child: DateTimeFormField(
                        //         initialValue: checkInitialValue(endDate3),
                        //         dateTextStyle: TextStyle(
                        //           fontFamily: FontNameDefault,
                        //           //   fontSize: textSubTitle(context),
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //         decoration: InputDecoration(
                        //             filled: true,
                        //             fillColor: Colors.grey[100],
                        //             isDense: true,
                        //             labelText: 'End Date',
                        //             hintStyle: TextStyle(
                        //               fontFamily: FontNameDefault,
                        //               color: Colors.grey,
                        //               fontSize: textSubTitle(context),
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //             border: InputBorder.none),
                        //         mode: DateTimeFieldPickerMode.date,
                        //         autovalidateMode: AutovalidateMode.always,
                        //         onSaved: (DateTime value) {
                        //           endDate3 = value.millisecondsSinceEpoch;
                        //         },
                        //         onDateSelected: (DateTime value) {
                        //           setState(() {
                        //             endDate3 = value.millisecondsSinceEpoch;
                        //           });
                        //           //   print(value);
                        //         },
                        //         validator: (DateTime value) {
                        //           if (_company3Controller.text.isNotEmpty &&
                        //               _designation3Controller.text.isNotEmpty &&
                        //               value == null) {
                        //             return 'Invalid date';
                        //           }

                        //           return null;
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenSize.width * 0.46,
                              child: DateTimeFormField(
                                // initialValue: checkInitialValue(startDate),
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
                                      // initialValue: checkInitialValue(endDate),
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
                                activeColor:
                                    Theme.of(context).primaryColorLight,
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
                        )
                      ],
                    )
                  ],
                ),
              ]),
            ])));
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

class EmploymentType {
  int id;
  String name;
  EmploymentType(this.id, this.name);
  static List<EmploymentType> getEmploymentType() {
    return <EmploymentType>[
      EmploymentType(1, 'Employment type'),
      EmploymentType(2, 'Full-time employee'),
      EmploymentType(3, 'Part-time employee'),
      EmploymentType(4, 'Intern'),
      EmploymentType(5, 'Owner'),
      EmploymentType(6, 'Board member'),
      EmploymentType(7, 'Volunteer'),
      EmploymentType(8, 'Freelancer'),
      EmploymentType(9, 'Self-employed'),
      EmploymentType(10, 'Partner'),
      EmploymentType(11, 'Shareholder'),
      EmploymentType(12, 'Civil servant'),
      EmploymentType(13, 'Recruiter'),
    ];
  }
}

class Industry {
  int id;
  String name;
  Industry(this.id, this.name);
  static List<Industry> getIndustry() {
    return <Industry>[
      Industry(1, 'Industry'),
      Industry(2, 'Architecture and planning'),
      Industry(3, 'Art, culture and sport'),
      Industry(4, 'Auditing, tax and law'),
      Industry(5, 'Automotive and vehicle manufacturing'),
      Industry(6, 'Banking and financial services'),
      Industry(7, 'Civil service, associations and institutions'),
      Industry(8, 'Consulting'),
      Industry(9, 'Consumer goods and trade'),
      Industry(10, 'Education and science'),
      Industry(11, 'Energy, water and environment'),
      Industry(12, 'HR services'),
      Industry(13, 'Health and social'),
      Industry(14, 'Insurance'),
      Industry(15, 'Internet and IT'),
      Industry(16, 'Marketing, PR and design'),
      Industry(17, 'Media and publishing'),
      Industry(18, 'Medical services'),
      Industry(19, 'Other services'),
      Industry(20, 'Real Estate'),
      Industry(21, 'Telecommunication'),
      Industry(22, 'Tourism and food service'),
      Industry(23, 'Transport and logistics'),
    ];
  }
}

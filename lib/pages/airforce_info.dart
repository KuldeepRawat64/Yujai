import 'dart:core';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'airforce_add_info.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AirforceInfo extends StatefulWidget {
  final String currentUserId;
  AirforceInfo({this.currentUserId});

  @override
  _AirforceInfoState createState() => _AirforceInfoState();
}

class _AirforceInfoState extends State<AirforceInfo> {
  bool isLoading = false;
  UserModel user;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _startServiceController = new TextEditingController();
  TextEditingController _endServiceController = new TextEditingController();
  UserModel _user;
  final format = DateFormat('yyyy');
  String selectedRank;
  String selectedCommand;
  String selectedRegiment;
  bool isChecked = false;
  String selectedMedal;
  List medals = [
    'Sena Medal',
    'Nausena Medal',
    'Vayusena Medal',
    'Sarvottam Yudh Seva Medal',
    'Uttam Yudh Seva Medal',
    'Ati Vishisht Seva Medal',
    'Vishisht Seva Medal',
    'Param Vir Chakra',
    'Maha Vir Chakra',
    'Vir Chakra',
    'Ashok Chakra',
    'Kirti Chakra',
    'Shaurya Chakra',
    'Wound Medal',
    'General Service Medal 1947',
    'Samanya Seva Medal',
    'Special Service Medal',
    'Samar Seva Star',
    'Poorvi Star',
    'Paschimi Star',
    'Operation Vijay Star',
    'Sainya Seva Medal',
    'High Altitude Service Medal',
    'Antrik Suraksha Padak',
    'Videsh Seva Medal',
    'Meritorius Service Medal',
    'Long Service and Good Conduct Medal',
    '30 Years Long Service Medal',
    '20 Years Long Service Medal',
    '9 Years Long Service Medal',
    'Territorial Army Decoration',
    'Territorial Army Medal',
    'Indian Independence Medal',
    '50th Independence Anniversary Medal',
    '25th Independence Anniversary Medal',
    'Commonwealth Awards',
  ];
  List ranks = [
    'Field Marshal',
    'General',
    'Lieutenant general',
    'Major General',
    'Brigadier',
    'Colonel',
    'Lieutenant Colonel',
    'Major',
    'Captain',
    'Lieutenant',
  ];
  List commands = [
    'Air force Training Command',
    'Central Command',
    'Eastern Command',
    'Northern Command',
    'South Western Command',
    'Southern Command',
    'Western Command'
  ];
  List regiments = [
    'Armoured Regiments',
    'Infantry Regiments',
    'Regiments of Artillery',
    'Corps of Army Air Defence',
    'Corps of Engineers'
  ];
  var _repository = Repository();

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
      selectedRank = _user.rank;
      selectedCommand = _user.command;
      selectedRegiment = _user.regiment;
      selectedMedal = _user.medal;
      _startServiceController.text = _user.startService;
      _endServiceController.text = _user.endService;
      if (_user.serviceStatus == 'Currently serving') {
        isChecked = true;
      } else {
        isChecked = false;
      }
    });
  }

  submit() async {
    if (_formKey.currentState.validate()) {
      User currentUser = await _auth.currentUser;
      usersRef.doc(currentUser.uid).update({
        "rank": selectedRank,
        "command": selectedCommand,
        "regiment": selectedRegiment,
        "startService": _startServiceController.text,
        "endService": _endServiceController.text,
        "serviceStatus": isChecked ? 'Currently serving' : 'Retired',
        "medal": selectedMedal ?? '',
      });
      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.015,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: submit,
                child: Container(
                  height: screenSize.height * 0.055,
                  width: screenSize.width / 5,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.white,
                      fontSize: textButton(context),
                    ),
                  )),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          //  centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Edit Military Info',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              screenSize.width / 11,
              screenSize.height * 0.02,
              screenSize.width / 11,
              0,
            ),
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: screenSize.height * 0.02),
                      child: Text(
                        'Select the details below to continue',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: InputBorder.none),
                        hint: Text(
                          'Rank',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: textSubTitle(context),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        //  underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 30,
                        isExpanded: true,
                        value: selectedRank,
                        items: ranks.map((valueItem) {
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
                            selectedRank = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Please select a rank';
                          return null;
                        },
                      ),
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
                          'Command',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: textSubTitle(context),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        //  underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 30,
                        isExpanded: true,
                        value: selectedCommand,
                        items: commands.map((valueItem) {
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
                            selectedCommand = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Please select a command';
                          return null;
                        },
                      ),
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
                          'Regiment',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: textSubTitle(context),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        //  underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 30,
                        isExpanded: true,
                        value: selectedRegiment,
                        items: regiments.map((valueItem) {
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
                            selectedRegiment = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Please select a regiment';
                          return null;
                        },
                      ),
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
                          'Medal',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: textSubTitle(context),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        //  underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 30,
                        isExpanded: true,
                        value: selectedMedal,
                        items: medals.map((valueItem) {
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
                            selectedMedal = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.05,
                    ),
                    IconButton(
                        onPressed: submit,
                        icon: Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: Colors.black54,
                          size: 35.0,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height * 0.015,
                          ),
                          child: Text(
                            'Service',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              //     height: screenSize.height * 0.075,
                              width: screenSize.width / 2.55,
                              child: DateTimeField(
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                ),
                                controller: _startServiceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  //   hintText: 'University',
                                  labelText: 'Start year',
                                  labelStyle: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.grey,
                                    fontSize: textSubTitle(context),
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                format: format,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      initialDatePickerMode:
                                          DatePickerMode.year,
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),
                            !isChecked
                                ? Container(
                                    //      height: screenSize.height * 0.075,
                                    width: screenSize.width / 2.55,
                                    child: DateTimeField(
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      ),
                                      controller: _endServiceController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        //   hintText: 'University',
                                        labelText: 'End year',
                                        labelStyle: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey,
                                          fontSize: textSubTitle(context),
                                          //fontWeight: FontWeight.bold,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      format: format,
                                      onShowPicker: (context, currentValue) {
                                        return showDatePicker(
                                            initialDatePickerMode:
                                                DatePickerMode.year,
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
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
                        Text('Currently serving')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:core';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Yujai/models/company.dart';
import 'package:Yujai/models/school.dart';
import '../models/college.dart';
import '../models/company.dart';
import '../models/university.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

final usersRef = FirebaseFirestore.instance.collection('users');

class ExperienceEdit extends StatefulWidget {
  final String company1;
  final String startCompany1;
  final String endCompany1;
  final String company2;
  final String startCompany2;
  final String endCompany2;
  final String company3;
  final String startCompany3;
  final String endCompany3;
  ExperienceEdit({
    this.company1,
    this.startCompany1,
    this.endCompany1,
    this.company2,
    this.startCompany2,
    this.endCompany2,
    this.company3,
    this.startCompany3,
    this.endCompany3,
  });

  @override
  _ExperienceEditState createState() => _ExperienceEditState();
}

class _ExperienceEditState extends State<ExperienceEdit> {
  DateTime date;
  TextEditingController _company1Controller = new TextEditingController();
  TextEditingController _company2Controller = new TextEditingController();
  TextEditingController _company3Controller = new TextEditingController();
  TextEditingController _startCompany1Controller = new TextEditingController();
  TextEditingController _endCompany1Controller = new TextEditingController();
  TextEditingController _startCompany2Controller = new TextEditingController();
  TextEditingController _endCompany2Controller = new TextEditingController();
  TextEditingController _startCompany3Controller = new TextEditingController();
  TextEditingController _endCompany3Controller = new TextEditingController();
  AutoCompleteTextField schoolTextField;
  AutoCompleteTextField collegeTextField;
  AutoCompleteTextField universityTextField;
  AutoCompleteTextField companyTextField1;
  AutoCompleteTextField companyTextField2;
  AutoCompleteTextField companyTextField3;
  GlobalKey<AutoCompleteTextFieldState<School>> skey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<College>> ckey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<University>> ukey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Company>> ikey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Company>> cikey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Company>> ciikey = new GlobalKey();
  static List<Company> companies = [];
  var _repository = Repository();
  User currentUser;
  User user;
  bool isLoading = false;
  final format = DateFormat('yyyy');
  bool loading = true;
  UserModel _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List experience = [
    const Experience(1, 'Years'),
    const Experience(1, 'Months'),
  ];

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    getCompany();
    _company1Controller.text = widget.company1;
    _startCompany1Controller.text = widget.startCompany1;
    _endCompany1Controller.text = widget.endCompany1;
    _company2Controller.text = widget.company2;
    _startCompany2Controller.text = widget.startCompany2;
    _endCompany2Controller.text = widget.endCompany2;
    _company3Controller.text = widget.company3;
    _startCompany3Controller.text = widget.startCompany3;
    _endCompany3Controller.text = widget.endCompany3;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
  }

  submit() async {
    if (_company1Controller.text.isNotEmpty &&
            _startCompany1Controller.text.isNotEmpty &&
            _endCompany1Controller.text.isNotEmpty ||
        _company2Controller.text.isNotEmpty &&
            _startCompany2Controller.text.isNotEmpty &&
            _endCompany2Controller.text.isNotEmpty ||
        _company3Controller.text.isNotEmpty &&
            _startCompany3Controller.text.isNotEmpty &&
            _endCompany3Controller.text.isNotEmpty) {
      User currentUser = _auth.currentUser;
      usersRef.doc(currentUser.uid).update({
        "company1": _company1Controller.text,
        "company2": _company2Controller.text,
        "company3": _company3Controller.text,
        "startCompany1": _startCompany1Controller.text,
        "endCompany1": _endCompany1Controller.text,
        "startCompany2": _startCompany2Controller.text,
        "endCompany2": _endCompany2Controller.text,
        "startCompany3": _startCompany3Controller.text,
        "endCompany3": _endCompany3Controller.text,
      });
      Navigator.pop(context);
      retrieveUserDetails();
      setState(() {
        _user = _user;
      });
    } else {
      return null;
    }
  }

  void getCompany() async {
    try {
      final response = await http
          .get(Uri.parse("https://kuldeeprawat64.github.io/data/company.json"));
      if (response.statusCode == 200) {
        companies = loadCompany(response.body);
        //   print('Company: ${companies.length}');
        setState(() {
          loading = false;
        });
      } else {
        //   print("Error getting Company.");
      }
    } catch (e) {
      //  print("Error getting Company.");
    }
  }

  static List<Company> loadCompany(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Company>((json) => Company.fromJson(json)).toList();
  }

  Widget irow(Company company) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          company.name,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10.0,
          height: 8.0,
        ),
        Divider()
        // Text(
        //   user.email,
        // ),
      ],
    );
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
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: submit,
                child: Container(
                  height: screenSize.height * 0.055,
                  width: screenSize.width * 0.15,
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
          //   centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Experience Details',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            screenSize.width / 11,
            screenSize.height * 0.012,
            screenSize.width / 11,
            screenSize.height * 0.025,
          ),
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Company',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                          ),
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: Container(
                                  //    color: const Color(0xffffffff),
                                  child: companyTextField1 =
                                      AutoCompleteTextField<Company>(
                                    controller: _company1Controller,
                                    key: ikey,
                                    clearOnSubmit: false,
                                    suggestions: companies,
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textBody1(context),
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffffffff),
                                      contentPadding: EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      hintText: "Name your company",
                                      labelText: 'Company',
                                    ),
                                    itemFilter: (item, query) {
                                      return item.name
                                          .toLowerCase()
                                          .startsWith(query.toLowerCase());
                                    },
                                    itemSorter: (a, b) {
                                      return a.name.compareTo(b.name);
                                    },
                                    itemSubmitted: (item) {
                                      setState(() {
                                        companyTextField1.textField.controller
                                            .text = item.name;
                                      });
                                    },
                                    itemBuilder: (context, item) {
                                      // ui for the autocompelete row
                                      return irow(item);
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Years of experience',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            //  color: const Color(0xffffffff),
                            height: screenSize.height * 0.075,
                            width: screenSize.width / 2.55,
                            alignment: Alignment.center,
                            child: DateTimeField(
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                              controller: _startCompany1Controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: 'Start Year',
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    initialDatePickerMode: DatePickerMode.year,
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                          Container(
                            //    color: const Color(0xffffffff),
                            height: screenSize.height * 0.075,
                            width: screenSize.width / 2.55,
                            alignment: Alignment.center,
                            child: DateTimeField(
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                              controller: _endCompany1Controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: 'Till',
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    initialDatePickerMode: DatePickerMode.year,
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.012),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                          ),
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: Container(
                                  //  color: const Color(0xffffffff),
                                  child: companyTextField2 =
                                      AutoCompleteTextField<Company>(
                                    controller: _company2Controller,
                                    key: cikey,
                                    clearOnSubmit: false,
                                    suggestions: companies,
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textBody1(context),
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffffffff),
                                      contentPadding: EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      hintText: "Name your company",
                                      labelText: 'Company',
                                    ),
                                    itemFilter: (item, query) {
                                      return item.name
                                          .toLowerCase()
                                          .startsWith(query.toLowerCase());
                                    },
                                    itemSorter: (a, b) {
                                      return a.name.compareTo(b.name);
                                    },
                                    itemSubmitted: (item) {
                                      setState(() {
                                        companyTextField2.textField.controller
                                            .text = item.name;
                                      });
                                    },
                                    itemBuilder: (context, item) {
                                      // ui for the autocompelete row
                                      return irow(item);
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Years of experience',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            //      color: const Color(0xffffffff),
                            height: screenSize.height * 0.075,
                            width: screenSize.width / 2.55,
                            alignment: Alignment.center,
                            child: DateTimeField(
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                              controller: _startCompany2Controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: 'Start Year',
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    initialDatePickerMode: DatePickerMode.year,
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                          Container(
                            //   color: const Color(0xffffffff),
                            height: screenSize.height * 0.075,
                            width: screenSize.width / 2.55,
                            alignment: Alignment.center,
                            child: DateTimeField(
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                              controller: _endCompany2Controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: 'Till',
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    initialDatePickerMode: DatePickerMode.year,
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                          ),
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: Container(
                                  //   color: const Color(0xffffffff),
                                  child: companyTextField3 =
                                      AutoCompleteTextField<Company>(
                                    controller: _company3Controller,
                                    key: ciikey,
                                    clearOnSubmit: false,
                                    suggestions: companies,
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textBody1(context),
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffffffff),
                                      contentPadding: EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      hintText: "Name your company",
                                      labelText: 'Company',
                                    ),
                                    itemFilter: (item, query) {
                                      return item.name
                                          .toLowerCase()
                                          .startsWith(query.toLowerCase());
                                    },
                                    itemSorter: (a, b) {
                                      return a.name.compareTo(b.name);
                                    },
                                    itemSubmitted: (item) {
                                      setState(() {
                                        companyTextField3.textField.controller
                                            .text = item.name;
                                      });
                                    },
                                    itemBuilder: (context, item) {
                                      // ui for the autocompelete row
                                      return irow(item);
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Years of experience',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            //    color: const Color(0xffffffff),
                            height: screenSize.height * 0.075,
                            width: screenSize.width / 2.55,
                            alignment: Alignment.center,
                            child: DateTimeField(
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                              controller: _startCompany3Controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: 'Start Year',
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    initialDatePickerMode: DatePickerMode.year,
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                          Container(
                            //  color: const Color(0xffffffff),
                            height: screenSize.height * 0.075,
                            width: screenSize.width / 2.55,
                            alignment: Alignment.center,
                            child: DateTimeField(
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                              controller: _endCompany3Controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: 'Till',
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    initialDatePickerMode: DatePickerMode.year,
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Experience {
  const Experience(this.id, this.name);
  final String name;
  final int id;
}

import 'dart:core';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Yujai/models/company.dart';
import 'package:Yujai/models/school.dart';
import '../models/college.dart';
import '../models/company.dart';
import '../models/university.dart';
import '../models/user.dart';

final usersRef = Firestore.instance.collection('users');

class EducationDetail extends StatefulWidget {
  final String school,
      stream,
      startSchool,
      endSchool,
      college,
      startCollege,
      endCollege,
      university,
      startUniversity,
      endUniversity,
      certification1,
      certification2,
      certification3;

  EducationDetail({
    this.school,
    this.startSchool,
    this.endSchool,
    this.college,
    this.startCollege,
    this.endCollege,
    this.university,
    this.startUniversity,
    this.endUniversity,
    this.stream,
    this.certification1,
    this.certification2,
    this.certification3,
  });

  @override
  _EducationDetailState createState() => _EducationDetailState();
}

class _EducationDetailState extends State<EducationDetail> {
  DateTime date;
  TextEditingController _collegeController = new TextEditingController();
  TextEditingController _universityController = new TextEditingController();
  TextEditingController _schoolController = new TextEditingController();
  TextEditingController _startSchoolController = new TextEditingController();
  TextEditingController _endSchoolController = new TextEditingController();
  TextEditingController _certificate1Controller = new TextEditingController();
  TextEditingController _certificate2Controller = new TextEditingController();
  TextEditingController _certificate3Controller = new TextEditingController();
  TextEditingController _startCollegeController = new TextEditingController();
  TextEditingController _endCollegeController = new TextEditingController();
  TextEditingController _startUniversityController =
      new TextEditingController();
  TextEditingController _endUniversityController = new TextEditingController();
  TextEditingController _streamController = new TextEditingController();
  AutoCompleteTextField schoolTextField;
  AutoCompleteTextField collegeTextField;
  AutoCompleteTextField universityTextField;
  AutoCompleteTextField companyTextField;
  GlobalKey<AutoCompleteTextFieldState<School>> skey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<College>> ckey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<University>> ukey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Company>> ikey = new GlobalKey();
  var _repository = Repository();
  FirebaseUser currentUser;
  User user;
  bool isLoading = false;
  final format = DateFormat('yyyy');
  bool loading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  User _user;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _schoolController.text = widget.school;
    _startSchoolController.text = widget.startSchool;
    _endSchoolController.text = widget.endSchool;
    _collegeController.text = widget.college;
    _startCollegeController.text = widget.startCollege;
    _endCollegeController.text = widget.endCollege;
    _universityController.text = widget.university;
    _startUniversityController.text = widget.startUniversity;
    _endUniversityController.text = widget.endUniversity;
    _streamController.text = widget.stream;
    _certificate1Controller.text = widget.certification1;
    _certificate2Controller.text = widget.certification2;
    _certificate3Controller.text = widget.certification3;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
  }

  submit() async {
    FirebaseUser currentUser = await _auth.currentUser();
    if (_universityController.text.isNotEmpty &&
        _streamController.text.isNotEmpty) {
      usersRef.document(currentUser.uid).updateData({
        "stream": _streamController.text,
        "university": _universityController.text,
        "startUniversity": _startUniversityController.text,
        "endUniversity": _endUniversityController.text,
      });
      Navigator.pop(context);
      retrieveUserDetails();
      setState(() {
        _user = _user;
      });
    } else
      return null;
  }

  submitCert() async {
    FirebaseUser currentUser = await _auth.currentUser();
    if (_certificate1Controller.text.isNotEmpty ||
        _certificate2Controller.text.isNotEmpty ||
        _certificate3Controller.text.isNotEmpty) {
      usersRef.document(currentUser.uid).updateData({
        "certification1": _certificate1Controller.text,
        "certification2": _certificate2Controller.text,
        "certification3": _certificate3Controller.text,
      });
      Navigator.pop(context);
      retrieveUserDetails();
      setState(() {
        _user = _user;
      });
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    print('Education build');
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor:const Color(0xffffffff),
          title: Text(
            'Qualification details',
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
            screenSize.width / 30,
            screenSize.height * 0.012,
            screenSize.width / 30,
            screenSize.height * 0.025,
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Education',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.015,
                    horizontal: screenSize.width / 50,
                  ),
                  child: GestureDetector(
                    onTap: _showFormDialog,
                    child: Container(
                      height: screenSize.height * 0.045,
                      width: screenSize.width / 5,
                      child: Center(
                          child: Text(
                        'Add',
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
                )
              ],
            ),
            _user != null && _user.university.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user != null ? _user.university : '',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                          ),
                          Text(
                            _user != null ? _user.stream : '',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                          )
                        ],
                      ),
                      FlatButton(
                          onPressed: _showFormDialog, child: Icon(Icons.edit))
                    ],
                  )
                : Container(),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certifications',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.015,
                    horizontal: screenSize.width / 50,
                  ),
                  child: GestureDetector(
                    onTap: _showCertDialog,
                    child: Container(
                      height: screenSize.height * 0.045,
                      width: screenSize.width / 5,
                      child: Center(
                          child: Text(
                        'Add',
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
                )
              ],
            ),
            _user != null && _user.certification1.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _user.certification1.isNotEmpty
                              ? Text(
                                  _user.certification1,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                  ),
                                )
                              : Container(),
                          _user.certification2.isNotEmpty
                              ? Text(
                                  _user.certification2,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                  ),
                                )
                              : Container(),
                          _user.certification3.isNotEmpty
                              ? Text(
                                  _user.certification3,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      FlatButton(
                          onPressed: _showCertDialog, child: Icon(Icons.edit))
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _showFormDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Wrap(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'University',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                            Container(
                              height: screenSize.height * 0.09,
                              width: screenSize.width,
                              child: TextFormField(
                                style: TextStyle(
                                   fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                ),
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                controller: _universityController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Field of Study',
                               style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                            Container(
                              height: screenSize.height * 0.09,
                              child: TextFormField(
                                style: TextStyle(
                                   fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                ),
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                controller: _streamController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //  direction: Axis.vertical,
                              children: [
                                Text(
                                  'Start Year',
                                    style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                                ),
                                Container(
                                    height: screenSize.height * 0.07,
                                    width: screenSize.width / 3.5,
                                    child: TextFormField(
                                       style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                                      controller: _startUniversityController,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //     direction: Axis.vertical,
                              children: [
                                Text(
                                  'End Year',
                                    style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                                ),
                                Container(
                                    height: screenSize.height * 0.07,
                                    width: screenSize.width / 3.5,
                                    child: TextFormField(
                                       style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                                      controller: _endUniversityController,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.015,
                          horizontal: screenSize.width / 50,
                        ),
                        child: GestureDetector(
                          onTap: submit,
                          child: Container(
                            height: screenSize.height * 0.065,
                            width: screenSize.width / 3,
                            child: Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.white,
                                fontSize: textSubTitle(context),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  _showCertDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                Form(
                  key: _form2Key,
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Text(
                              'Add a qualification',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: screenSize.height * 0.07,
                              width: screenSize.width,
                              child: TextFormField(
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                ),
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                },
                                controller: _certificate1Controller,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Container(
                              height: screenSize.height * 0.07,
                              child: TextFormField(
                                style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                ),
                                controller: _certificate2Controller,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Container(
                              height: screenSize.height * 0.07,
                              child: TextFormField(
                                style: TextStyle(
                               fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                ),
                                controller: _certificate3Controller,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.015,
                          horizontal: screenSize.width / 50,
                        ),
                        child: GestureDetector(
                          onTap: submitCert,
                          child: Container(
                            height: screenSize.height * 0.065,
                            width: screenSize.width / 3,
                            child: Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

import 'package:Yujai/pages/home.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import '../models/location.dart';
import '../models/user.dart';
import 'agreementDialog.dart' as fullDialog;

final usersRef = Firestore.instance.collection('users');

class CreateAccountProfile extends StatefulWidget {
  @override
  _CreateAccountProfileState createState() => _CreateAccountProfileState();
}

class _CreateAccountProfileState extends State<CreateAccountProfile> {
  AutoCompleteTextField locationTextField;
  GlobalKey<AutoCompleteTextFieldState<Location>> lkey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime date;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isLoading = true;
  bool _phoneValid = true;
  bool _displayNameValid = true;
  bool _dateValid = false;
  final format = DateFormat('yyyy-MM-dd');
  bool loading = true;
  String selectedGender;
  String selectedStatus;
  bool onPressed = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  bool userAgreed = false;
  bool valueFirst = false;
  String accountType;
  User _user = User();
  var _repository = Repository();
  User currentuser, user, followingUser;
  int startDate = 0;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentuser = user;
          displayNameController.text = currentuser.displayName;
        });
      });
    });

    selectedGender = "Male";
    selectedStatus = "Single";
    accountType = "";
  }

  setSelectedGender(String val) {
    setState(() {
      selectedGender = val;
    });
  }

  setSelectedStatus(String val) {
    setState(() {
      selectedStatus = val;
    });
  }

  Widget row(Location location) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          location.name,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        // Text(
        //   user.email,
        // ),
      ],
    );
  }

  Future _openAgreeDialog(context) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return fullDialog.CreateAgreement();
        },
        //true to display with a dismiss button rather than a return navigation arrow
        fullscreenDialog: true));
    if (result != null) {
      accept(result, context);
    } else {
      decline(result, context);
    }
  }

  accept(String result, context) {
    setState(() {
      userAgreed = true;
    });
  }

  decline(String result, context) {
    setState(() {
      userAgreed = false;
    });
  }

  submit() async {
    FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      phoneController.text.trim().length < 10 ||
              phoneController.text.trim().length > 10 ||
              phoneController.text.isEmpty
          ? _phoneValid = false
          : _phoneValid = true;
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;

      // locationController.text.isEmpty
      //     ? _locationValid = false
      //     : _locationValid = true;
    });

    _firestore.collection('users').document(currentUser.uid).updateData({
      "displayName": displayNameController.text,
      "phone": phoneController.text,
      "dateOfBirth": startDate.toString(),
      "location": locationController.text,
      "gender": selectedGender,
      "status": selectedStatus,
    });

    SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                //     currentUserId: currentUser.uid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          key: _scaffoldKey,
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screenSize.width / 11,
                  screenSize.height * 0.02,
                  screenSize.width / 11,
                  screenSize.height * 0.025,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(Icons.keyboard_arrow_left,
                                    size: screenSize.height * 0.04,
                                    color: Colors.black54)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Create a Profile',
                                  style: TextStyle(
                                    //   color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textHeader(context),
                                  ),
                                ),
                                Text(
                                  'Fill the details below to continue',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    // fontSize: textBody1(context),
                                    //color:Colors.grey,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.02),
                        child: TextFormField(
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          controller: displayNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: 'Name',
                            labelText: 'Name',
                            hintStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textAppTitle(context),
                              fontWeight: FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty) return "Please enter a name";
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.02),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.phone_outlined,
                              color: Colors.black54,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            //   hintText: '00000 00000',
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.02),
                        child: DateTimeFormField(
                          dateTextStyle: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              isDense: true,
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.black54,
                              ),
                              labelText: 'Date of birth',
                              hintStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.grey,
                                fontSize: textSubTitle(context),
                                fontWeight: FontWeight.normal,
                              ),
                              border: InputBorder.none),
                          mode: DateTimeFieldPickerMode.date,
                          autovalidateMode: AutovalidateMode.always,
                          onDateSelected: (DateTime value) {
                            setState(() {
                              startDate = value.millisecondsSinceEpoch;
                            });
                            print(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.02),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          controller: locationController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: Colors.black54,
                            ),
                            labelText: "Location / City",
                            labelStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter a text for your post";
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.03,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.02),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Radio(
                                            value: 'Male',
                                            groupValue: selectedGender,
                                            activeColor:
                                                Colors.deepPurpleAccent,
                                            onChanged: (val) {
                                              // print("Gender $val");
                                              setSelectedGender(val);
                                            },
                                          ),
                                          Text(
                                            'Male',
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Radio(
                                            value: 'Female',
                                            groupValue: selectedGender,
                                            activeColor:
                                                Colors.deepPurpleAccent,
                                            onChanged: (val) {
                                              //print("Gender $val");
                                              setSelectedGender(val);
                                            },
                                          ),
                                          Text(
                                            'Female',
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Radio(
                                            value: 'Single',
                                            groupValue: selectedStatus,
                                            activeColor:
                                                Colors.deepPurpleAccent,
                                            onChanged: (val) {
                                              //print("Status $val");
                                              setSelectedStatus(val);
                                            },
                                          ),
                                          Text('Single',
                                              style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontSize: textBody1(context),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Radio(
                                            value: 'Married',
                                            groupValue: selectedStatus,
                                            activeColor:
                                                Colors.deepPurpleAccent,
                                            onChanged: (val) {
                                              //print("Status $val");
                                              setSelectedStatus(val);
                                            },
                                          ),
                                          Text('Married',
                                              style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontSize: textBody1(context),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.deepPurpleAccent,
                              value: this.valueFirst,
                              onChanged: (bool value) {
                                setState(() {
                                  if (value) {
                                    _openAgreeDialog(context);
                                  }
                                  this.valueFirst = value;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                //_openAgreeDialog(context);
                              },
                              child: Text(
                                'Accept Terms & Conditions',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.03,
                      ),
                      valueFirst &&
                              (displayNameController.text.isNotEmpty ||
                                  phoneController.text.isNotEmpty &&
                                      phoneController.text.length < 11 &&
                                      phoneController.text.length > 9 &&
                                      dateController.text.isNotEmpty ||
                                  locationController.text.isNotEmpty)
                          ? GestureDetector(
                              onTap: submit,
                              child: Container(
                                height: screenSize.height * 0.09,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.white,
                                        fontSize: textSubTitle(context),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: screenSize.height * 0.09,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.grey,
                                        fontSize: textAppTitle(context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

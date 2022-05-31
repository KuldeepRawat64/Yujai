import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'home.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ArmyAddInfo extends StatefulWidget {
  final String currentUserId;
  ArmyAddInfo({this.currentUserId});
  @override
  _ArmyAddInfoState createState() => _ArmyAddInfoState();
}

class _ArmyAddInfoState extends State<ArmyAddInfo> {
  final _formKey = GlobalKey<FormState>();

  DateTime startService = DateTime.now();
  DateTime endService = DateTime.now();
  TextEditingController _startServiceController = new TextEditingController();
  TextEditingController _endServiceController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  final format = DateFormat('yyyy');
  bool isLoading = false;
  UserModel user;
  bool startYear;
  bool endYear;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  @override
  void initState() {
    super.initState();
  }

  submit() async {
    if (_formKey.currentState.validate()) {
      User currentUser = _auth.currentUser;
      usersRef.doc(currentUser.uid).update({
        "startService": _startServiceController.text,
        "endService": _endServiceController.text,
        "bio": _bioController.text,
        "serviceStatus": isChecked ? 'Currently serving' : 'Retired',
        "medal": selectedMedal ?? '',
      });
      _formKey.currentState.save();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
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
          //    centerTitle: true,
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
                screenSize.width / 13,
                screenSize.height * 0.02,
                screenSize.width / 13,
                0,
              ),
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
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
                                              initialDate: currentValue ??
                                                  DateTime.now(),
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
                              activeColor: Theme.of(context).primaryColorLight,
                              value: isChecked,
                              onChanged: (val) {
                                setState(() {
                                  isChecked = val;
                                });
                              }),
                          Text('Currently serving')
                        ],
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
                        height: screenSize.height * 0.02,
                      ),
                      TextFormField(
                        autocorrect: true,
                        keyboardType: TextInputType.multiline,
                        minLines: 8,
                        maxLines: 8,
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        controller: _bioController,
                        decoration: InputDecoration(
                          icon: IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.black54,
                            ),
                            onPressed: null,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          //   hintText: 'Bio',
                          labelText: 'Bio',
                          labelStyle: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontSize: textSubTitle(context),
                            //fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/company_add_info.dart';
import '../models/user.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class CompanyInfo extends StatefulWidget {
  final String currentUserId;
  CompanyInfo({this.currentUserId});
  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  var _gstKey = GlobalKey<FormState>();
  User user;
  bool isLoading = true;
  bool onPressed;
  FirebaseUser currentUser;
  TextEditingController companyNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController establishYearController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final format = DateFormat('yyyy');

  @override
  void initState() {
    super.initState();
    getUser();

    onPressed = false;
  }

  getUser() async {
    currentUser = await _auth.currentUser();
  }

  List<DropdownMenuItem<CompanySize>> buildDropDownMenuCompanySize(
      List companySizes) {
    List<DropdownMenuItem<CompanySize>> items = List();
    for (CompanySize companySize in companySizes) {
      items.add(
        DropdownMenuItem(
          value: companySize,
          child: Text(companySize.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownCompanySize(CompanySize selectedCompanySize) {
    setState(() {
      //    _selectedCompanySize = selectedCompanySize;
    });
  }

  submit() async {
    final _gstValid = _gstKey.currentState.validate();
    if (!_gstValid) {
      return;
    }
    {
      FirebaseUser currentUser = await _auth.currentUser();
      usersRef.document(currentUser.uid).updateData({
        "accountType": 'Company',
        "displayName": companyNameController.text,
        "phone": phoneController.text,
        "establishYear": establishYearController.text,
        "gst": gstController.text,
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CompanyAddInfo(
                  //  currentUserId: currentUser.uid,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        body: ListView(
            padding: EdgeInsets.fromLTRB(
              screenSize.width / 11,
              screenSize.height * 0.055,
              screenSize.width / 11,
              0,
            ),
            children: [
              Form(
                key: _gstKey,
                child: Container(
                  child: Column(children: [
                    Text(
                      'Company Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textAppTitle(context),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: screenSize.height * 0.012),
                      child: Text(
                        'Fill the details below to continue',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/office-building.png',
                        height: screenSize.height * 0.12,
                        width: screenSize.width / 2.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.012),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Name',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black54,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: screenSize.height * 0.09,
                            child: TextFormField(
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                              controller: companyNameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                hintText: "Name of your company",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.012),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: screenSize.height * 0.09,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                              controller: phoneController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                hintText: "Company contact",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.012),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Establishment Year',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: screenSize.height * 0.09,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: textBody1(context),
                                  fontFamily: FontNameDefault),
                              keyboardType: TextInputType.number,
                              controller: establishYearController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffffffff),
                                  hintText: 'eg. 1967'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.012),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gst Number',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: screenSize.height * 0.09,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty ||
                                    !RegExp(r"^([0][1-9]|[1-2][0-9]|[3][0-7])([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$")
                                        .hasMatch(value)) {
                                  return 'Enter a valid gst';
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                              controller: gstController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                hintText: "Your gst no",
                                labelText: 'Gst',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    companyNameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            establishYearController.text.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.015),
                            child: GestureDetector(
                              onTap: submit,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                height: screenSize.height * 0.07,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(''),
                  ]),
                ),
              ),
            ]),
      ),
    );
  }
}

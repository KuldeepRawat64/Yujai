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
        backgroundColor: const Color(0xffffffff),
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textHeader(context),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.05,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: screenSize.height * 0.02),
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
                              fillColor: Colors.grey[100],
                              // suffix: Row(

                              labelText: 'Company name',
                              hintStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textAppTitle(context),
                                fontWeight: FontWeight.bold,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: new BorderRadius.circular(10),
                              // ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please enter your company name";
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: screenSize.height * 0.02),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            controller: phoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              // suffix: Row(

                              labelText: 'Company phone',
                              hintStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textAppTitle(context),
                                fontWeight: FontWeight.bold,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: new BorderRadius.circular(10),
                              // ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please enter your company phone";
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: screenSize.height * 0.02),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: textBody1(context),
                                fontFamily: FontNameDefault),
                            keyboardType: TextInputType.number,
                            controller: establishYearController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              // suffix: Row(

                              labelText: 'Establsihed year',
                              hintStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textAppTitle(context),
                                fontWeight: FontWeight.bold,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: new BorderRadius.circular(10),
                              // ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please enter established year of your company";
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: screenSize.height * 0.02),
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
                              fillColor: Colors.grey[100],
                              // suffix: Row(

                              labelText: 'Company gst',
                              hintStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textAppTitle(context),
                                fontWeight: FontWeight.bold,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: new BorderRadius.circular(10),
                              // ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height * 0.02,
                            //left: screenSize.width * 0.01,
                            //right: screenSize.width * 0.01
                          ),
                          child: InkWell(
                            onTap: submit,
                            child: Container(
                                height: screenSize.height * 0.07,
                                //    width: screenSize.width * 0.8,
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
                                      'Create',
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
                      ]),
                ),
              ),
            ]),
      ),
    );
  }
}

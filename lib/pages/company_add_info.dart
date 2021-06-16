import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:Yujai/pages/home.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:Yujai/models/industry.dart';
import 'package:http/http.dart' as http;

import '../style.dart';

class CompanyAddInfo extends StatefulWidget {
  final String currentUserId;
  CompanyAddInfo({this.currentUserId});
  @override
  _CompanyAddInfoState createState() => _CompanyAddInfoState();
}

class CompanySize {
  int id;
  String name;
  CompanySize(this.id, this.name);
  static List<CompanySize> getCompanySize() {
    return <CompanySize>[
      CompanySize(1, 'Select Company Size'),
      CompanySize(2, '1 - 9'),
      CompanySize(3, '10 - 49'),
      CompanySize(4, '50 - 99'),
      CompanySize(5, '100 - 999'),
      CompanySize(6, '1000 and above'),
    ];
  }
}

class CompanyType {
  int id;
  String name;
  CompanyType(this.id, this.name);
  static List<CompanyType> getCompanyType() {
    return <CompanyType>[
      CompanyType(1, 'Select Company Type'),
      CompanyType(2, 'Private Limited'),
      CompanyType(3, 'Corporation'),
      CompanyType(4, 'Goverment'),
      CompanyType(5, 'Public Limited'),
      CompanyType(6, 'Joint-Venture'),
      CompanyType(7, 'One Person Company'),
      CompanyType(8, 'Sole proprietorship'),
      CompanyType(9, 'Partnership Firm'),
      CompanyType(10, 'Branch Office'),
      CompanyType(11, 'NGO'),
    ];
  }
}

class _CompanyAddInfoState extends State<CompanyAddInfo> {
  List<CompanySize> _companySize = CompanySize.getCompanySize();
  List<DropdownMenuItem<CompanySize>> _dropDownMenuCompanySize;
  CompanySize _selectedCompanySize;
  List<CompanyType> _companyType = CompanyType.getCompanyType();
  List<DropdownMenuItem<CompanyType>> _dropDownMenuCompanyType;
  CompanyType _selectedCompanyType;
  TextEditingController _industryController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Industry>> inkey = new GlobalKey();
  AutoCompleteTextField industryTextField;
  //bool _industryValid = true;
  static List<Industry> industries = new List<Industry>();
  bool onPressed;
  bool loading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getIndustry();
    _dropDownMenuCompanySize = buildDropDownMenuCompanySize(_companySize);
    _selectedCompanySize = _dropDownMenuCompanySize[0].value;
    _dropDownMenuCompanyType = buildDropDownMenuCompanyType(_companyType);
    _selectedCompanyType = _dropDownMenuCompanyType[0].value;
    onPressed = false;
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
      _selectedCompanySize = selectedCompanySize;
    });
  }

  List<DropdownMenuItem<CompanyType>> buildDropDownMenuCompanyType(
      List companyTypes) {
    List<DropdownMenuItem<CompanyType>> items = List();
    for (CompanyType companyType in companyTypes) {
      items.add(
        DropdownMenuItem(
          value: companyType,
          child: Text(companyType.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownCompanyType(CompanyType selectedCompanyType) {
    setState(() {
      _selectedCompanyType = selectedCompanyType;
    });
  }

  void getIndustry() async {
    try {
      final response = await http.get(
          Uri.parse("https://kuldeeprawat64.github.io/data/industry.json"));
      if (response.statusCode == 200) {
        industries = loadIndustry(response.body);
        // print('Industry: ${industries.length}');
        setState(() {
          loading = false;
        });
      } else {
        //  print("Error getting Industry.");
      }
    } catch (e) {
      //  print("Error getting Industry.");
    }
  }

  static List<Industry> loadIndustry(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Industry>((json) => Industry.fromJson(json)).toList();
  }

  Widget irow(Industry industry) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            industry.name,
            style: TextStyle(
                fontFamily: FontNameDefault, fontSize: textBody1(context)),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.05,
        ),
        // Text(
        //   user.email,
        // ),
      ],
    );
  }

  submit() async {
    User currentUser = await _auth.currentUser;
    usersRef.doc(currentUser.uid).update({
      "industry": _industryController.text,
      "companySize": _selectedCompanySize.name,
      "bio": _bioController.text,
      "companyType": _selectedCompanyType.name,
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                //  currentUserId: currentUser.uid,
                )));
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
              Container(
                child: Column(children: [
                  Text(
                    'Additional Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textAppTitle(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenSize.height * 0.015),
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
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bio',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: TextField(
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context)),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            controller: _bioController,
                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 5,
                            maxLengthEnforced: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              hintText: 'Tell us about your company.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Industry Category',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : Container(
                                height: screenSize.height * 0.09,
                                child: industryTextField =
                                    AutoCompleteTextField<Industry>(
                                  textCapitalization: TextCapitalization.words,
                                  controller: _industryController,
                                  key: inkey,
                                  clearOnSubmit: false,
                                  suggestions: industries,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffffff),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    hintText: "Enter category e.g. Finance",
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
                                      industryTextField.textField.controller
                                          .text = item.name;
                                    });
                                  },
                                  itemBuilder: (context, item) {
                                    // ui for the autocompelete row
                                    return irow(item);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Size',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButton(
                              underline: Container(color: Colors.white),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black87,
                              ),
                              elevation: 1,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Theme.of(context).accentColor),
                              iconSize: 30,
                              isExpanded: true,
                              value: _selectedCompanySize,
                              items: _dropDownMenuCompanySize,
                              onChanged: onChangeDropDownCompanySize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Type',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButton(
                              underline: Container(color: Colors.white),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black87,
                              ),
                              elevation: 1,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Theme.of(context).accentColor),
                              iconSize: 30,
                              isExpanded: true,
                              value: _selectedCompanyType,
                              items: _dropDownMenuCompanyType,
                              onChanged: onChangeDropDownCompanyType,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _selectedCompanySize.name != 'Select Company Size' &&
                          _selectedCompanyType.name != 'Select Company Type' &&
                          _industryController.text.isNotEmpty &&
                          _bioController.text.isNotEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.015),
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
                                  "Submit",
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
            ]),
      ),
    );
  }
}

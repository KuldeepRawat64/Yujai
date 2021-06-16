import 'dart:convert';
import 'package:Yujai/models/industry.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../style.dart';

class EditOrgInfo extends StatefulWidget {
  final String name;
  final String industry;
  final String establishedYear;
  final String employees;
  final String products;
  final String gst;

  const EditOrgInfo({
    Key key,
    this.industry,
    this.establishedYear,
    this.employees,
    this.products,
    this.name,
    this.gst,
  }) : super(key: key);

  @override
  _EditOrgInfoState createState() => _EditOrgInfoState();
}

class _EditOrgInfoState extends State<EditOrgInfo> {
  var _repository = Repository();
  User currentUser;
  final _employeeController = TextEditingController();
  final _gstController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _productController = TextEditingController();
  final _establishmentController = TextEditingController();
  TextEditingController _industryController = new TextEditingController();
  bool onPressed;
  bool loading = true;
  AutoCompleteTextField industryTextField;
  GlobalKey<AutoCompleteTextFieldState<Industry>> industrykey = new GlobalKey();
  static List<Industry> industries = new List<Industry>();
  final format = DateFormat.y();
  bool isSelected = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _gstKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getIndustry();
    _companyNameController.text = widget.name;
    _industryController.text = widget.industry;
    _employeeController.text = widget.employees;
    _establishmentController.text = widget.establishedYear;
    _productController.text = widget.products;
    _gstController.text = widget.gst;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  void getIndustry() async {
    try {
      final response = await http.get(
          Uri.parse("https://kuldeeprawat64.github.io/data/industry.json"));
      if (response.statusCode == 200) {
        industries = loadIndustry(response.body);
        print('industry: ${industries.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting industry.");
      }
    } catch (e) {
      print("Error getting industry.");
    }
  }

  static List<Industry> loadIndustry(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Industry>((json) => Industry.fromJson(json)).toList();
  }

  Widget industryrow(Industry industry) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Divider(),
        Text(
          industry.name,
          style: TextStyle(fontSize: screenSize.height * 0.025),
        ),
        SizedBox(
          height: screenSize.height * 0.012,
        ),
        // Text(
        //   user.email,
        // ),
      ],
    );
  }

  submit() async {
    final _gstValid = _gstKey.currentState.validate();
    if (_companyNameController.text.isNotEmpty &&
        _gstController.text.isNotEmpty &&
        _employeeController.text.isNotEmpty &&
        _establishmentController.text.isNotEmpty &&
        _industryController.text.isNotEmpty &&
        _productController.text.isNotEmpty &&
        _gstValid) {
      User currentUser = await _auth.currentUser;
      _firestore.collection('users').doc(currentUser.uid).update({
        "displayName": _companyNameController.text,
        "gst": _gstController.text,
        "employees": _employeeController.text,
        "establishedYear": _establishmentController.text,
        "industry": _industryController.text,
        "products": _productController.text,
      });
      Navigator.pop(context);
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
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
                  width: screenSize.width * 0.15,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Edit Organization Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _gstKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width / 30,
                  top: screenSize.height * 0.012,
                  right: screenSize.width / 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Organization Info',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.012),
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //color: const Color(0xffffffff),
                      height: screenSize.height * 0.09,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                        ),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                        textCapitalization: TextCapitalization.words,
                        controller: _companyNameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.012),
                      child: Text(
                        'Employees',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: screenSize.height * 0.09,
                      // color: const Color(0xffffffff),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                        ),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _employeeController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.012),
                      child: Text(
                        'Year of establishment',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //  color: const Color(0xffffffff),
                      alignment: Alignment.center,
                      // height: MediaQuery.of(context).size.height * 0.06,
                      //width: width * 0.5,
                      child: DateTimeField(
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                        controller: _establishmentController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: 'yyyy',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.012),
                          child: Text(
                            'Industry Category',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        loading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.005),
                                child: Container(
                                  //   color: const Color(0xffffffff),
                                  child: industryTextField =
                                      AutoCompleteTextField<Industry>(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffffffff),
                                    ),
                                    controller: _industryController,
                                    key: industrykey,
                                    clearOnSubmit: false,
                                    suggestions: industries,
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
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
                                      return industryrow(item);
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.012),
                          child: Text(
                            'Product and Services',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          //   color: const Color(0xffffffff),
                          child: TextFormField(
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            controller: _productController,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              hintText: 'product, services',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.012),
                          child: Text(
                            'Gst Number',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black54,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          //   color: const Color(0xffffffff),
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
                            controller: _gstController,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextWidgets(List<dynamic> strings) {
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: chip(items, Colors.deepPurple),
              ))
          .toList(),
    );
  }

  Widget chip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          label[0].toUpperCase(),
          style: TextStyle(color: Colors.black54),
        ),
      ),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(6.0),
    );
  }
}

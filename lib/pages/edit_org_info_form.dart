import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/industry.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EditOrgInfoForm extends StatefulWidget {
  final UserModel currentUser;

  EditOrgInfoForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditOrgInfoForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  UserModel currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  DateFormat format = DateFormat.y();
  bool isSelected = false;
  var _gstKey = GlobalKey<FormState>();
  String valueEmployee;
  String formattedString = 'yyyy';
  DateTime estYear;
  List employees = ['1-9', '10-49', '50-99', '100-999', '1000+'];

  @override
  void initState() {
    super.initState();

    getIndustry();
    _companyNameController.text = widget.currentUser.displayName;
    _industryController.text = widget.currentUser.industry;
    _employeeController.text = widget.currentUser.employees;
    _establishmentController.text = widget.currentUser.establishYear;
    _productController.text = widget.currentUser.products;
    _gstController.text = widget.currentUser.gst;

    // _repository.getCurrentUser().then((user) {
    //   setState(() {
    //     currentUser = user;
    //   });
    // });
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

  File imageFile;

  submit() async {
    if (_formKey.currentState.validate()) {
      User currentUser = await _auth.currentUser;
      _firestore.collection('users').doc(currentUser.uid).update({
        "displayName": _companyNameController.text,
        "gst": _gstController.text,
        "employees": valueEmployee,
        "establishedYear": _establishmentController.text,
        "industry": _industryController.text,
        "products": _productController.text,
      });
      _formKey.currentState.save();
      Navigator.pop(context);
    }
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
            screenSize.height * 0.05,
            screenSize.width * 0.04,
            screenSize.height * 0.1,
          ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //  Text(
                //   'Organization Info',
                //   style: TextStyle(
                //     fontFamily: FontNameDefault,
                //     color: Colors.black54,
                //     fontWeight: FontWeight.bold,
                //     fontSize: textSubTitle(context),
                //   ),
                // ),
                // SizedBox(
                //   height: screenSize.height * 0.02,
                // ),
                TextFormField(
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    //    fontWeight: FontWeight.bold,
                  ),
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    //   hintText: 'Bio',
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: FontNameDefault,
                      color: Colors.grey[500],
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                // SizedBox(
                //   height: screenSize.height * 0.02,
                // ),
                // TextFormField(
                //   style: TextStyle(
                //     fontFamily: FontNameDefault,
                //     fontSize: textSubTitle(context),
                //     // fontWeight: FontWeight.bold,
                //   ),
                //   controller: _employeeController,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.grey[100],
                //     //   hintText: 'Bio',
                //     labelText: 'Employees',
                //     labelStyle: TextStyle(
                //       fontWeight: FontWeight.normal,
                //       fontFamily: FontNameDefault,
                //       color: Colors.grey[500],
                //       fontSize: textSubTitle(context),
                //       //fontWeight: FontWeight.bold,
                //     ),
                //     border: InputBorder.none,
                //     isDense: true,
                //   ),
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
                      'Employees',
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
                    value: valueEmployee,
                    items: employees.map((valueItem) {
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
                        valueEmployee = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Please select an industry';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                DateTimeField(
                  initialValue: DateTime.parse("2012-02-27"),
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                  controller: _establishmentController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    //   hintText: 'Bio',
                    labelText: 'Established year',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: FontNameDefault,
                      color: Colors.grey[500],
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
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
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                loading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        //   color: const Color(0xffffffff),
                        child: industryTextField =
                            AutoCompleteTextField<Industry>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            //   hintText: 'Bio',
                            labelText: 'Industry',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: FontNameDefault,
                              color: Colors.grey[500],
                              fontSize: textSubTitle(context),
                              //fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          controller: _industryController,
                          key: industrykey,
                          clearOnSubmit: false,
                          suggestions: industries,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            //  fontWeight: FontWeight.bold
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
                              industryTextField.textField.controller.text =
                                  item.name;
                            });
                          },
                          itemBuilder: (context, item) {
                            // ui for the autocompelete row
                            return industryrow(item);
                          },
                        ),
                      ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
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
                    fillColor: Colors.grey[100],
                    //   hintText: 'Bio',
                    labelText: 'Products and services',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: FontNameDefault,
                      color: Colors.grey[500],
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
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
                    fillColor: Colors.grey[100],
                    //   hintText: 'Bio',
                    labelText: 'Gst number',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: FontNameDefault,
                      color: Colors.grey[500],
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.05,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      submit();
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //  width: screenSize.width * 0.8,
                        decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.015),
                          child: Center(
                            child: Text(
                              'Update',
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
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:core';
// import 'package:Yujai/models/company.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:Yujai/pages/student_add_info.dart';
// import '../models/college.dart';
// import '../models/school.dart';
// import '../models/university.dart';
// import '../models/user.dart';
// import 'home.dart';
// import 'package:http/http.dart' as http;

// class StudentInfo extends StatefulWidget {
//   final String currentUserId;
//   StudentInfo({this.currentUserId});

//   @override
//   _StudentInfoState createState() => _StudentInfoState();
// }

// class _StudentInfoState extends State<StudentInfo> {
//   DateTime date;
//   TextEditingController _collegeController = new TextEditingController();
//   TextEditingController _universityController = new TextEditingController();
//   TextEditingController _schoolController = new TextEditingController();
//   TextEditingController _internController = new TextEditingController();
//   TextEditingController _startSchoolController = new TextEditingController();
//   TextEditingController _endSchoolController = new TextEditingController();
//   TextEditingController _startCollegeController = new TextEditingController();
//   TextEditingController _endCollegeController = new TextEditingController();
//   TextEditingController _startUniversityController =
//       new TextEditingController();
//   TextEditingController _endUniversityController = new TextEditingController();
//   TextEditingController _startInternController = new TextEditingController();
//   TextEditingController _endInternController = new TextEditingController();
//   AutoCompleteTextField schoolTextField;
//   AutoCompleteTextField collegeTextField;
//   AutoCompleteTextField universityTextField;
//   AutoCompleteTextField companyTextField;
//   GlobalKey<AutoCompleteTextFieldState<Company>> ikey = new GlobalKey();
//   GlobalKey<AutoCompleteTextFieldState<School>> skey = new GlobalKey();
//   GlobalKey<AutoCompleteTextFieldState<College>> ckey = new GlobalKey();
//   GlobalKey<AutoCompleteTextFieldState<University>> ukey = new GlobalKey();
//   static List<School> schools = new List<School>();
//   static List<College> colleges = new List<College>();
//   static List<University> universities = new List<University>();
//   static List<Company> companies = new List<Company>();
//   User user;
//   bool isLoading = false;
//    final format = DateFormat('yyyy');
//   var myFormat = DateFormat.y();
//   bool _collegeValid = true;
//   bool _universityValid = true;
//   bool _schoolValid = true;
//   bool _skillValid = true;
//   bool _internValid = true;
//   bool loading = true;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     getCompany();
//     getSchool();
//     getCollege();
//     getUniversity();
//   }

 
//   void getSchool() async {
//     try {
//       final response =
//           await http.get("https://kuldeeprawat64.github.io/data/school.json");
//       if (response.statusCode == 200) {
//         schools = loadSchool(response.body);
//         //  print('Location: ${schools.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //   print("Error getting School.");
//       }
//     } catch (e) {
//       //  print("Error getting School.");
//     }
//   }

//   static List<School> loadSchool(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<School>((json) => School.fromJson(json)).toList();
//   }

//   Widget srow(School school) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           school.name,
//           style: TextStyle(fontSize: 14.0),
//         ),
//         SizedBox(
//           width: 10.0,
//         ),
//         // Text(
//         //   user.email,
//         // ),
//       ],
//     );
//   }

//   void getCollege() async {
//     try {
//       final response =
//           await http.get("https://kuldeeprawat64.github.io/data/college.json");
//       if (response.statusCode == 200) {
//         colleges = loadCollege(response.body);
//         //  print('College: ${colleges.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //   print("Error getting College.");
//       }
//     } catch (e) {
//       //   print("Error getting College.");
//     }
//   }

//   static List<College> loadCollege(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<College>((json) => College.fromJson(json)).toList();
//   }

//   Widget crow(College college) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           college.name,
//           style: TextStyle(fontSize: 14.0),
//         ),
//         SizedBox(
//           width: 10.0,
//         ),
//         // Text(
//         //   user.email,
//         // ),
//       ],
//     );
//   }

//   void getUniversity() async {
//     try {
//       final response = await http
//           .get("https://kuldeeprawat64.github.io/data/university.json");
//       if (response.statusCode == 200) {
//         universities = loadUniversity(response.body);
//         //  print('University: ${universities.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //  print("Error getting University.");
//       }
//     } catch (e) {
//       //  print("Error getting University.");
//     }
//   }

//   static List<University> loadUniversity(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<University>((json) => University.fromJson(json)).toList();
//   }

//   Widget urow(University university) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           university.name,
//           style: TextStyle(fontSize: 14.0),
//         ),
//         SizedBox(
//           width: 10.0,
//         ),
//         // Text(
//         //   user.email,
//         // ),
//       ],
//     );
//   }

//   void getCompany() async {
//     try {
//       final response =
//           await http.get("https://kuldeeprawat64.github.io/data/company.json");
//       if (response.statusCode == 200) {
//         companies = loadCompany(response.body);
//         //   print('Company: ${companies.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //   print("Error getting Company.");
//       }
//     } catch (e) {
//       //  print("Error getting Company.");
//     }
//   }

//   static List<Company> loadCompany(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<Company>((json) => Company.fromJson(json)).toList();
//   }

//   Widget irow(Company company) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           company.name,
//           style: TextStyle(fontSize: 14.0),
//         ),
//         SizedBox(
//           width: 10.0,
//         ),
//         // Text(
//         //   user.email,
//         // ),
//       ],
//     );
//   }

//   submit() async {
//     FirebaseUser currentUser = await _auth.currentUser();
//     setState(() {
//       _collegeController.text.isEmpty
//           ? _collegeValid = false
//           : _collegeValid = true;
//       _universityController.text.isEmpty
//           ? _universityValid = false
//           : _universityValid = true;
//       _schoolController.text.isEmpty
//           ? _schoolValid = false
//           : _schoolValid = true;
//       _internController.text.isEmpty
//           ? _internValid = false
//           : _internValid = true;
//     });
//     if (_collegeValid &&
//         _universityValid &&
//         _schoolValid &&
//         _skillValid &&
//         _internValid) {
//       usersRef.document(currentUser.uid).updateData({
//         "school": _schoolController.text,
//         "startSchool": _startSchoolController.text,
//         "endSchool": _endSchoolController.text,
//         "college": _collegeController.text,
//         "startCollege": _startCollegeController.text,
//         "endCollege": _endCollegeController.text,
//         "university": _universityController.text,
//         "startUniversity": _startUniversityController.text,
//         "endUniversity": _endUniversityController.text,
//         "internship": _internController.text,
//         "startIntership": _startInternController.text,
//         "endIntership": _endInternController.text,
//       });
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => StudentAddInfo(
//                   //   currentUserId: currentUser.uid,
//                   )));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//           child: Scaffold(
//         body: ListView(
//           padding: EdgeInsets.fromLTRB(
//             screenSize.width / 11,
//             screenSize.height * 0.055,
//             screenSize.width / 11,
//             screenSize.height * 0.015,
//           ),
//           children: <Widget>[
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     'Students Info',
//                     style: TextStyle(
//                       fontSize: screenSize.height * 0.03,
//                       // fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
//                     child: Text(
//                       'Fill the details below to continue',
//                       style: TextStyle(
//                         fontSize: screenSize.height * 0.025,
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   loading
//                       ? CircularProgressIndicator()
//                       : Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenSize.height * 0.012),
//                           child: Container(
//                             height: screenSize.height * 0.09,
//                             child: schoolTextField =
//                                 AutoCompleteTextField<School>(
//                               controller: _schoolController,
//                               key: skey,
//                               clearOnSubmit: false,
//                               suggestions: schools,
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: screenSize.height * 0.022),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 hintText: "School",
//                               ),
//                               itemFilter: (item, query) {
//                                 return item.name
//                                     .toLowerCase()
//                                     .startsWith(query.toLowerCase());
//                               },
//                               itemSorter: (a, b) {
//                                 return a.name.compareTo(b.name);
//                               },
//                               itemSubmitted: (item) {
//                                 setState(() {
//                                   schoolTextField.textField.controller.text =
//                                       item.name;
//                                 });
//                               },
//                               itemBuilder: (context, item) {
//                                 // ui for the autocompelete row
//                                 return srow(item);
//                               },
//                             ),
//                           ),
//                         ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _startSchoolController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'Start Year',
//                               labelStyle:
//                                   TextStyle(fontSize: screenSize.height * 0.022)),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _endSchoolController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'End Year',
//                               labelStyle: TextStyle(
//                                 fontSize: screenSize.height * 0.022,
//                               )),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   loading
//                       ? CircularProgressIndicator()
//                       : Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenSize.height * 0.012),
//                           child: Container(
//                             height: screenSize.height * 0.09,
//                             child: collegeTextField =
//                                 AutoCompleteTextField<College>(
//                               controller: _collegeController,
//                               key: ckey,
//                               clearOnSubmit: false,
//                               suggestions: colleges,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: screenSize.height * 0.022,
//                               ),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 hintText: "College",
//                                 labelStyle: TextStyle(
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                               ),
//                               itemFilter: (item, query) {
//                                 return item.name
//                                     .toLowerCase()
//                                     .startsWith(query.toLowerCase());
//                               },
//                               itemSorter: (a, b) {
//                                 return a.name.compareTo(b.name);
//                               },
//                               itemSubmitted: (item) {
//                                 setState(() {
//                                   collegeTextField.textField.controller.text =
//                                       item.name;
//                                 });
//                               },
//                               itemBuilder: (context, item) {
//                                 // ui for the autocompelete row
//                                 return crow(item);
//                               },
//                             ),
//                           ),
//                         ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _startCollegeController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'Start Year',
//                               labelStyle: TextStyle(
//                                 fontSize: screenSize.height * 0.022,
//                               )),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _endCollegeController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'End Year',
//                               labelStyle: TextStyle(
//                                 fontSize: screenSize.height * 0.022,
//                               )),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   loading
//                       ? CircularProgressIndicator()
//                       : Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenSize.height * 0.012),
//                           child: Container(
//                             height: screenSize.height * 0.09,
//                             child: universityTextField =
//                                 AutoCompleteTextField<University>(
//                               controller: _universityController,
//                               key: ukey,
//                               clearOnSubmit: false,
//                               suggestions: universities,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: screenSize.height * 0.022,
//                               ),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 hintText: "University",
//                                 labelStyle: TextStyle(
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                               ),
//                               itemFilter: (item, query) {
//                                 return item.name
//                                     .toLowerCase()
//                                     .startsWith(query.toLowerCase());
//                               },
//                               itemSorter: (a, b) {
//                                 return a.name.compareTo(b.name);
//                               },
//                               itemSubmitted: (item) {
//                                 setState(() {
//                                   universityTextField.textField.controller.text =
//                                       item.name;
//                                 });
//                               },
//                               itemBuilder: (context, item) {
//                                 // ui for the autocompelete row
//                                 return urow(item);
//                               },
//                             ),
//                           ),
//                         ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _startUniversityController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'Start Year',
//                               labelStyle: TextStyle(
//                                 fontSize: screenSize.height * 0.022,
//                               )),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _endUniversityController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             labelText: 'End Year',
//                             labelStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                           ),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   loading
//                       ? CircularProgressIndicator()
//                       : Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenSize.height * 0.012),
//                           child: Container(
//                             height: screenSize.height * 0.09,
//                             child: companyTextField =
//                                 AutoCompleteTextField<Company>(
//                               controller: _internController,
//                               key: ikey,
//                               clearOnSubmit: false,
//                               suggestions: companies,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: screenSize.height * 0.022,
//                               ),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 hintText: "Name of company",
//                                 labelText: 'Intership',
//                                 labelStyle: TextStyle(
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                               ),
//                               itemFilter: (item, query) {
//                                 return item.name
//                                     .toLowerCase()
//                                     .startsWith(query.toLowerCase());
//                               },
//                               itemSorter: (a, b) {
//                                 return a.name.compareTo(b.name);
//                               },
//                               itemSubmitted: (item) {
//                                 setState(() {
//                                   companyTextField.textField.controller.text =
//                                       item.name;
//                                 });
//                               },
//                               itemBuilder: (context, item) {
//                                 // ui for the autocompelete row
//                                 return irow(item);
//                               },
//                             ),
//                           ),
//                         ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _startInternController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'Start Year',
//                               labelStyle: TextStyle(
//                                 fontSize: screenSize.height * 0.022,
//                               )),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                       Container(
//                         height: screenSize.height * 0.075,
//                         width: screenSize.width / 2.55,
//                         alignment: Alignment.center,
//                         child: DateTimeField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _endInternController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               labelText: 'End Year',
//                               labelStyle: TextStyle(
//                                 fontSize: screenSize.height * 0.022,
//                               )),
//                           format: format,
//                           onShowPicker: (context, currentValue) {
//                             return showDatePicker(
//                                 initialDatePickerMode: DatePickerMode.year,
//                                 context: context,
//                                 firstDate: DateTime(1900),
//                                 initialDate: currentValue ?? DateTime.now(),
//                                 lastDate: DateTime(2100));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   _schoolController.text.isNotEmpty &&
//                               _startSchoolController.text.isNotEmpty &&
//                               _endSchoolController.text.isNotEmpty ||
//                           _collegeController.text.isNotEmpty &&
//                               _startCollegeController.text.isNotEmpty &&
//                               _endCollegeController.text.isNotEmpty ||
//                           _universityController.text.isNotEmpty &&
//                               _startUniversityController.text.isNotEmpty &&
//                               _endUniversityController.text.isNotEmpty ||
//                           _startInternController.text.isNotEmpty &&
//                               _endInternController.text.isNotEmpty &&
//                               _internController.text.isNotEmpty
//                       ? Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenSize.height * 0.015),
//                           child: GestureDetector(
//                             onTap: submit,
//                             child: Container(
//                               alignment: Alignment.bottomCenter,
//                               height: screenSize.height * 0.07,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).primaryColor,
//                                 borderRadius: BorderRadius.circular(60.0),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Next",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: screenSize.height * 0.025,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       : Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenSize.height * 0.015),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => StudentAddInfo()));
//                             },
//                             child: Container(
//                               alignment: Alignment.bottomCenter,
//                               height: screenSize.height * 0.07,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).primaryColor,
//                                 borderRadius: BorderRadius.circular(60.0),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Skip",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: screenSize.height * 0.025,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

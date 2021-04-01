// import 'dart:convert';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:Yujai/models/designation.dart';
// import 'package:Yujai/models/industry.dart';
// import 'package:Yujai/pages/home.dart';
// import 'package:Yujai/pages/professional_interests.dart';

// class ProfessionalAddInfo extends StatefulWidget {
//   final String currentUserId;
//   ProfessionalAddInfo({this.currentUserId});

//   @override
//   _ProfessionalAddInfoState createState() => _ProfessionalAddInfoState();
// }

// class ProfessionalField {
//   int id;
//   String name;
//   ProfessionalField(this.id, this.name);
//   static List<ProfessionalField> getProfessionalField() {
//     return <ProfessionalField>[
//       ProfessionalField(1, 'Select a Category'),
//       ProfessionalField(2, 'Information & Technology'),
//       ProfessionalField(3, 'Lieutenant general'),
//       ProfessionalField(4, 'Major General'),
//       ProfessionalField(5, 'Brigadier'),
//       ProfessionalField(6, 'Colonel'),
//       ProfessionalField(7, 'Lieutenant Colonel'),
//       ProfessionalField(8, 'Major'),
//       ProfessionalField(9, 'Captain'),
//       ProfessionalField(10, 'Lieutenant'),
//     ];
//   }
// }

// class _ProfessionalAddInfoState extends State<ProfessionalAddInfo> {
//   TextEditingController _portfolioController = new TextEditingController();
//   TextEditingController _projectController = new TextEditingController();
//   TextEditingController _industryController = new TextEditingController();
//   TextEditingController _designationController = new TextEditingController();
//   TextEditingController _bioController = new TextEditingController();
//   GlobalKey<AutoCompleteTextFieldState<Industry>> inkey = new GlobalKey();
//   GlobalKey<AutoCompleteTextFieldState<Designation>> deskey = new GlobalKey();
//   static List<Designation> designations = new List<Designation>();
//   AutoCompleteTextField industryTextField;
//   AutoCompleteTextField designationTextField;
//   bool _portfolioValid = true;
//   bool _industryValid = true;
//   static List<Industry> industries = new List<Industry>();
//   bool loading = true;
//   bool _designationValid = true;
//   bool _bioValid = true;
//   bool _projectValid = true;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     getIndustry();
//     getDesignation();

//   }

//   @override
//   void dispose() {
//     _bioController.dispose();
//     super.dispose();
//   }

//   List<DropdownMenuItem<ProfessionalField>> buildDropDownMenuProfessionalField(
//       List professionalFields) {
//     List<DropdownMenuItem<ProfessionalField>> items = List();
//     for (ProfessionalField professionalField in professionalFields) {
//       items.add(
//         DropdownMenuItem(
//           value: professionalField,
//           child: Text(professionalField.name),
//         ),
//       );
//     }
//     return items;
//   }

//   onChangeDropDownProfessionalField(
//       ProfessionalField selectedProfessionalField) {
//     setState(() {
//     //  _selectedProfessionalField = selectedProfessionalField;
//     });
//   }

//   void getIndustry() async {
//     try {
//       final response =
//           await http.get("https://kuldeeprawat64.github.io/data/industry.json");
//       if (response.statusCode == 200) {
//         industries = loadIndustry(response.body);
//         //  print('Industry: ${industries.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //   print("Error getting Industry.");
//       }
//     } catch (e) {
//       //  print("Error getting Industry.");
//     }
//   }

//   static List<Industry> loadIndustry(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<Industry>((json) => Industry.fromJson(json)).toList();
//   }

//   Widget irow(Industry industry) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           industry.name,
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

//   void getDesignation() async {
//     try {
//       final response = await http
//           .get("https://kuldeeprawat64.github.io/data/profession.json");
//       if (response.statusCode == 200) {
//         designations = loadDesignation(response.body);
//         // print('Profession: ${designations.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //  print("Error getting Profession.");
//       }
//     } catch (e) {
//       // print("Error getting profession.");
//     }
//   }

//   static List<Designation> loadDesignation(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed
//         .map<Designation>((json) => Designation.fromJson(json))
//         .toList();
//   }

//   Widget drow(Designation designation) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           designation.name,
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
//       _portfolioController.text.isEmpty
//           ? _portfolioValid = false
//           : _portfolioValid = true;
//       _industryController.text.isEmpty
//           ? _industryValid = false
//           : _industryValid = true;
//       _designationController.text.isEmpty
//           ? _designationValid = false
//           : _designationValid = true;
//       _bioController.text.isEmpty ? _bioValid = false : _bioValid = true;
//     });
//     if (_bioValid && _industryValid && _designationValid) {
//       usersRef.document(currentUser.uid).updateData({
//         "industry": _industryController.text,
//         "designation": _designationController.text,
//         "portfolio": _portfolioController.text,
//         "bio": _bioController.text,
//         "projects": _projectController.text,
//       });
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ProfessionalInterests(
//                   // currentUserId: currentUser.uid,
//                   )));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//           child: Scaffold(
//         body: ListView(
//             padding: EdgeInsets.fromLTRB(
//               screenSize.width / 11,
//               screenSize.height * 0.055,
//               screenSize.width / 11,
//               0,
//             ),
//             children: [
//               Container(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Additional Info',
//                       style: TextStyle(
//                         fontSize: screenSize.height * 0.03,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
//                       child: Text(
//                         'Fill the details below to continue',
//                         style: TextStyle(
//                           fontSize: screenSize.height * 0.025,
//                           color: Colors.black54,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                       child: Container(
//                         height: screenSize.height * 0.09,
//                         child: TextFormField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _projectController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0)),
//                             labelText: 'Projects',
//                             hintText:
//                                 'Enter your github url e.g. https://github.com',
//                             hintStyle:
//                                 TextStyle(fontSize: screenSize.height * 0.022),
//                             labelStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                             errorText:
//                                 _projectValid ? null : "Enter your Website",
//                           ),
//                         ),
//                       ),
//                     ),
//                     loading
//                         ? CircularProgressIndicator()
//                         : Padding(
//                             padding:
//                                 EdgeInsets.only(top: screenSize.height * 0.012),
//                             child: Container(
//                               height: screenSize.height * 0.09,
//                               child: industryTextField =
//                                   AutoCompleteTextField<Industry>(
//                                 controller: _industryController,
//                                 key: inkey,
//                                 clearOnSubmit: false,
//                                 suggestions: industries,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   hintText: "Enter your field e.g. Finance",
//                                   hintStyle: TextStyle(
//                                     fontSize: screenSize.height * 0.022,
//                                   ),
//                                   labelText: 'Industry',
//                                   labelStyle: TextStyle(
//                                     fontSize: screenSize.height * 0.022,
//                                   ),
//                                 ),
//                                 itemFilter: (item, query) {
//                                   return item.name
//                                       .toLowerCase()
//                                       .startsWith(query.toLowerCase());
//                                 },
//                                 itemSorter: (a, b) {
//                                   return a.name.compareTo(b.name);
//                                 },
//                                 itemSubmitted: (item) {
//                                   setState(() {
//                                     industryTextField.textField.controller.text =
//                                         item.name;
//                                   });
//                                 },
//                                 itemBuilder: (context, item) {
//                                   // ui for the autocompelete row
//                                   return irow(item);
//                                 },
//                               ),
//                             ),
//                           ),
//                     loading
//                         ? CircularProgressIndicator()
//                         : Padding(
//                             padding:
//                                 EdgeInsets.only(top: screenSize.height * 0.012),
//                             child: Container(
//                               height: screenSize.height * 0.09,
//                               child: designationTextField =
//                                   AutoCompleteTextField<Designation>(
//                                 controller: _designationController,
//                                 key: deskey,
//                                 clearOnSubmit: false,
//                                 suggestions: designations,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   hintText:
//                                       "Enter your designation e.g. Accountant",
//                                   hintStyle: TextStyle(
//                                     fontSize: screenSize.height * 0.022,
//                                   ),
//                                   labelText: 'Designation',
//                                   labelStyle: TextStyle(
//                                     fontSize: screenSize.height * 0.022,
//                                   ),
//                                 ),
//                                 itemFilter: (item, query) {
//                                   return item.name
//                                       .toLowerCase()
//                                       .startsWith(query.toLowerCase());
//                                 },
//                                 itemSorter: (a, b) {
//                                   return a.name.compareTo(b.name);
//                                 },
//                                 itemSubmitted: (item) {
//                                   setState(() {
//                                     designationTextField
//                                         .textField.controller.text = item.name;
//                                   });
//                                 },
//                                 itemBuilder: (context, item) {
//                                   // ui for the autocompelete row
//                                   return drow(item);
//                                 },
//                               ),
//                             ),
//                           ),
//                     Padding(
//                       padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                       child: Container(
//                         height: screenSize.height * 0.09,
//                         child: TextFormField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _portfolioController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0)),
//                             labelText: 'Portfolio',
//                             hintText:
//                                 'Enter your website e.g. www.yourwebsite.com',
//                             hintStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                             labelStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                             errorText:
//                                 _portfolioValid ? null : "Enter your Website",
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                       child: Container(
                   
//                         child: TextFormField(
//                           style: TextStyle(
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _bioController,
//                           keyboardType: TextInputType.multiline,
//                           minLines: 5,
//                           maxLines: 5,
//                           maxLengthEnforced: true,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             labelText: 'Bio',
//                             hintText: 'Tell us about yourself',
//                             hintStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                             labelStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     _portfolioController.text.isNotEmpty &&
//                             _industryController.text.isNotEmpty &&
//                             _designationController.text.isNotEmpty &&
//                             _bioController.text.isNotEmpty
//                         ? Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: screenSize.height * 0.05),
//                             child: GestureDetector(
//                               onTap: submit,
//                               child: Container(
//                                 alignment: Alignment.bottomCenter,
//                                 height: screenSize.height * 0.07,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   borderRadius: BorderRadius.circular(60.0),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "Next",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: screenSize.height * 0.025,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: screenSize.height * 0.05),
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             ProfessionalInterests()));
//                               },
//                               child: Container(
//                                 alignment: Alignment.bottomCenter,
//                                 height: screenSize.height * 0.07,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   borderRadius: BorderRadius.circular(60.0),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "Skip",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: screenSize.height * 0.025,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                   ],
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
// }

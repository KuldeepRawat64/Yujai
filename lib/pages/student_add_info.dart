// import 'dart:convert';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:Yujai/models/industry.dart';
// import 'package:Yujai/models/skill.dart';
// import 'package:http/http.dart' as http;
// import 'package:Yujai/pages/home.dart';
// import 'package:Yujai/pages/student_interests.dart';

// class StudentAddInfo extends StatefulWidget {
//   final String currentUserId;
//   StudentAddInfo({this.currentUserId});

//   @override
//   _StudentAddInfoState createState() => _StudentAddInfoState();
// }

// class _StudentAddInfoState extends State<StudentAddInfo> {
//   TextEditingController _skillController = new TextEditingController();
//   TextEditingController _industryController = new TextEditingController();
//   TextEditingController _portfolioController = new TextEditingController();
//   TextEditingController _bioController = new TextEditingController();
//   TextEditingController _projectController = new TextEditingController();
//   GlobalKey<AutoCompleteTextFieldState<Industry>> inkey = new GlobalKey();
//   AutoCompleteTextField skillTextField;
//   AutoCompleteTextField industryTextField;
//   GlobalKey<AutoCompleteTextFieldState<Skill>> skillkey = new GlobalKey();
//   static List<Skill> skills = new List<Skill>();
//   static List<Industry> industries = new List<Industry>();
//   bool loading = true;
//   bool _skillValid = true;
//   bool _portfolioVaid = true;
//   bool _industryValid = true;
//   bool _bioValid = true;
//   bool _projectValid = true;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     getSkill();
//     getIndustry();
//   }

//   void getSkill() async {
//     try {
//       final response =
//           await http.get("https://kuldeeprawat64.github.io/data/skill.json");
//       if (response.statusCode == 200) {
//         skills = loadSkill(response.body);
//         //  print('Skill: ${skills.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //  print("Error getting Skill.");
//       }
//     } catch (e) {
//       //  print("Error getting Skill.");
//     }
//   }

//   static List<Skill> loadSkill(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<Skill>((json) => Skill.fromJson(json)).toList();
//   }

//   Widget skillrow(Skill skill) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           skill.name,
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

//   submit() async {
//     FirebaseUser currentUser = await _auth.currentUser();
//     setState(() {
//       _projectController.text.isEmpty
//           ? _projectValid = false
//           : _projectValid = true;
//       _skillController.text.isEmpty ? _skillValid = false : _skillValid = true;
//       _portfolioController.text.isEmpty
//           ? _portfolioVaid = false
//           : _portfolioVaid = true;
//       _industryController.text.isEmpty
//           ? _industryValid = false
//           : _industryValid = true;
//       _bioController.text.isEmpty ? _bioValid = false : _bioValid = true;
//     });
//     if (_skillValid && _portfolioVaid && _industryValid && _bioValid) {
//       usersRef.document(currentUser.uid).updateData({
//         "skill": _skillController.text,
//         "portfolio": _portfolioController.text,
//         "industry": _industryController.text,
//       });
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => StudentInterests(
               
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
//               screenSize.height * 0.025,
//             ),
//             children: [
//               Container(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Additional Info',
//                       style: TextStyle(fontSize: screenSize.height * 0.03),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
//                       child: Text(
//                         'Fill the details below to continue',
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: screenSize.height * 0.025,
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
//                             hintText: 'Enter website url e.g. www.github.com',
//                             hintStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
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
//                               child: skillTextField =
//                                   AutoCompleteTextField<Skill>(
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                                 controller: _skillController,
//                                 key: skillkey,
//                                 clearOnSubmit: false,
//                                 suggestions: skills,
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   hintText: "Enter your skill",
//                                   labelText: 'Skill',
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
//                                     skillTextField.textField.controller.text =
//                                         item.name;
//                                   });
//                                 },
//                                 itemBuilder: (context, item) {
//                                   // ui for the autocompelete row
//                                   return skillrow(item);
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
//                             color: Colors.black,
//                             fontSize: screenSize.height * 0.022,
//                           ),
//                           controller: _portfolioController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0)),
//                             labelText: 'Portfolio',
//                             hintText: 'Enter your website url',
//                             labelStyle: TextStyle(
//                               fontSize: screenSize.height * 0.022,
//                             ),
//                             errorText:
//                                 _portfolioVaid ? null : "Enter your Website",
//                           ),
//                         ),
//                       ),
//                     ),
//                     loading
//                         ? CircularProgressIndicator()
//                         : Container(
//                             padding:
//                                 EdgeInsets.only(top: screenSize.height * 0.012),
//                             child: industryTextField =
//                                 AutoCompleteTextField<Industry>(
//                               controller: _industryController,
//                               key: inkey,
//                               clearOnSubmit: false,
//                               suggestions: industries,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: screenSize.height * 0.022,
//                               ),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 hintText: "Enter your field e.g. Finance",
//                                 hintStyle: TextStyle(
//                                   fontSize: screenSize.height * 0.022,
//                                 ),
//                                 labelText: 'Industry',
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
//                                   industryTextField.textField.controller.text =
//                                       item.name;
//                                 });
//                               },
//                               itemBuilder: (context, item) {
//                                 // ui for the autocompelete row
//                                 return irow(item);
//                               },
//                             ),
//                           ),
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
//                     _projectController.text.isNotEmpty &&
//                             _skillController.text.isNotEmpty &&
//                             _portfolioController.text.isNotEmpty &&
//                             _industryController.text.isNotEmpty &&
//                             _bioController.text.isNotEmpty
//                         ? Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: screenSize.height * 0.05),
//                             child: GestureDetector(
//                               onTap: submit,
//                               child: Container(
//                                 alignment: Alignment.bottomCenter,
//                                 height: screenSize.height * 0.07,
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   borderRadius: BorderRadius.circular(60.0),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "Next",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: screenSize.height * 0.025,
//                                      ),
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
//                                             StudentInterests()));
//                               },
//                               child: Container(
//                                 alignment: Alignment.bottomCenter,
//                                 height: screenSize.height * 0.07,
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                    color: Theme.of(context).primaryColor,
//                                   borderRadius: BorderRadius.circular(60.0),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "Skip",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: screenSize.height * 0.025,
//                                       ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
// }

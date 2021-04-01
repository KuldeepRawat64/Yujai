// import 'package:Yujai/pages/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../models/user.dart';

// class CompanyPurpose extends StatefulWidget {
//   final String currentUserId;
//   final String title;
//   CompanyPurpose({this.currentUserId, this.title});

//   @override
//   _CompanyPurposeState createState() => _CompanyPurposeState();
// }

// class _CompanyPurposeState extends State<CompanyPurpose>
//     with SingleTickerProviderStateMixin {
//   GlobalKey<ScaffoldState> _key;
//   List<Purpose> _purposes;
//   List<String> _filters;
//   bool isLoading = false;
//   bool isSelected = false;
//   User user;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     //getUser();
//     _key = GlobalKey<ScaffoldState>();
//     _filters = <String>[];
//     _purposes = <Purpose>[
//       const Purpose('Full-time Jobs'),
//       const Purpose('Part-time Jobs'),
//       const Purpose('Event-based Jobs'),
//       const Purpose('Task-based Jobs'),
//       const Purpose('Freelancing'),
//     ];
//   }



//   submit() async {
//     FirebaseUser currentUser = await _auth.currentUser();
//     usersRef.document(currentUser.uid).updateData({
//       "purpose": _filters,
//     });
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       key: _key,
//       body: Container(
//         alignment: Alignment.center,
//         child: ListView(
//           padding: EdgeInsets.only(top: screenSize.height * 0.055),
//           children: [
//             Column(
//               children: <Widget>[
//                 Text(
//                   'Choose your Purpose',
//                   style: TextStyle(
//                     fontSize: screenSize.height * 0.03,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     bottom: screenSize.height * 0.01,
//                   ),
//                   child: Text(
//                     '* You can choose any 5 options from below',
//                     style: TextStyle(
//                       fontSize: screenSize.height * 0.025,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Wrap(
//                   alignment: WrapAlignment.center,
//                   children: interestWidgets.toList(),
//                 ),
//                 SizedBox(
//                   height: 18.0,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: isSelected
//           ? GestureDetector(
//               onTap: submit,
//               child: Container(
//                 alignment: Alignment.bottomCenter,
//                 height: screenSize.height * 0.07,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(0.0),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Next",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: screenSize.height * 0.025,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           : GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => Home()));
//               },
//               child: Container(
//                 alignment: Alignment.bottomCenter,
//                 height: screenSize.height * 0.07,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Skip",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: screenSize.height * 0.025,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Iterable<Widget> get interestWidgets sync* {
//     var screenSize = MediaQuery.of(context).size;
//     for (Purpose purpose in _purposes) {
//       yield Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: FilterChip(
//           backgroundColor: Colors.grey[200],
//           elevation: 12.0,
//           selectedColor: Colors.grey[400],
//           avatar: CircleAvatar(
//             child: Text(purpose.name[0].toUpperCase()),
//           ),
//           label: Text(purpose.name),
//           labelStyle: TextStyle(
//             fontSize: screenSize.height * 0.022,
//             color: Colors.black54,
//             fontWeight: FontWeight.bold,
//           ),
//           selected: _filters.contains(purpose.name),
//           onSelected: (bool selected) {
//             setState(() {
//               if (selected) {
//                 _filters.add(purpose.name);
//                 isSelected = selected;
//               } else {
//                 _filters.removeWhere((String name) {
//                   return name == purpose.name;
//                 });
//                 isSelected = false;
//               }
//             });
//           },
//         ),
//       );
//     }
//   }

//   Widget chip(String label, Color color) {
//     return Chip(
//       labelPadding: EdgeInsets.all(5.0),
//       avatar: CircleAvatar(
//         backgroundColor: Colors.blueAccent,
//         child: Text(label[0].toUpperCase()),
//       ),
//       label: Text(
//         label,
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: color,
//       elevation: 12.0,
//       shadowColor: Colors.grey[60],
//       padding: EdgeInsets.all(6.0),
//     );
//   }
// }

// class Purpose {
//   const Purpose(this.name);
//   final String name;
// }

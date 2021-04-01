
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import 'home.dart';
// import 'company_purpose.dart';

// class CompanyInterests extends StatefulWidget {
//   final String title;
//   final String currentUserId;
//   CompanyInterests({this.title, this.currentUserId});

//   @override
//   _CompanyInterestsState createState() => _CompanyInterestsState();
// }

// class _CompanyInterestsState extends State<CompanyInterests>
//     with SingleTickerProviderStateMixin {
//   GlobalKey<ScaffoldState> _key;
//   List<Interest> _interests;
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
//     _interests = <Interest>[
//       const Interest('Hardware'),
//       const Interest('Software'),
//       const Interest('Networking'),
//       const Interest('Finance'),
//       const Interest('Management'),
//     ];
//   }


//   submit() async {
//     FirebaseUser currentUser = await _auth.currentUser();
//     usersRef.document(currentUser.uid).updateData({
//       "interests": _filters,
//     });
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CompanyPurpose(
//                 //    currentUserId: currentUser.uid,
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//           child: Scaffold(
//         backgroundColor: Colors.white,
//         key: _key,
//         body: Container(
//           alignment: Alignment.center,
//           child: ListView(
//             padding: EdgeInsets.only(top: screenSize.height * 0.055),
//             children: [
//               Column(
//                 children: <Widget>[
//                   Text(
//                     'Choose your Interests',
//                     style: TextStyle(
//                       fontSize: screenSize.height * 0.03,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       bottom: screenSize.height * 0.01,
//                     ),
//                     child: Text(
//                       '* You can choose any 5 options from below',
//                       style: TextStyle(
//                         fontSize: screenSize.height * 0.025,
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Wrap(
//                     alignment: WrapAlignment.center,
//                     children: interestWidgets.toList(),
//                   ),
//                   SizedBox(
//                     height: 18.0,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         bottomSheet: isSelected
//             ? GestureDetector(
//                 onTap: submit,
//                 child: Container(
//                   alignment: Alignment.bottomCenter,
//                   height: screenSize.height * 0.07,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(0.0),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Next",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: screenSize.height * 0.025,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : GestureDetector(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => CompanyPurpose()));
//                 },
//                 child: Container(
//                   alignment: Alignment.bottomCenter,
//                   height: screenSize.height * 0.07,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Skip",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: screenSize.height * 0.025,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Iterable<Widget> get interestWidgets sync* {
//     var screenSize = MediaQuery.of(context).size;
//     for (Interest interest in _interests) {
//       yield Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: FilterChip(
//           backgroundColor: Colors.grey[200],
//           elevation: 12.0,
//           selectedColor: Colors.grey[400],
//           avatar: CircleAvatar(
//             child: Text(interest.name[0].toUpperCase()),
//           ),
//           label: Text(interest.name),
//           labelStyle: TextStyle(
//             fontSize: screenSize.height * 0.022,
//             color: Colors.black54,
//             fontWeight: FontWeight.bold,
//           ),
//           selected: _filters.contains(interest.name),
//           onSelected: (bool selected) {
//             setState(() {
//               if (selected) {
//                 _filters.add(interest.name);
//                 isSelected = selected;
//               } else {
//                 _filters.removeWhere((String name) {
//                   return name == interest.name;
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

// class Interest {
//   const Interest(this.name);
//   final String name;
// }

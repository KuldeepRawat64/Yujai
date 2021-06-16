// import 'dart:io';
// import 'dart:math';
// import 'package:Yujai/resources/repository.dart';
// import 'package:Yujai/style.dart';
// import 'package:image/image.dart' as Im;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class EditGroupInfo extends StatefulWidget {
//   final String photoUrl, email, bio, name, phone, website;

//   EditGroupInfo(
//       {this.photoUrl,
//       this.email,
//       this.bio,
//       this.name,
//       this.phone,
//       this.website});

//   @override
//   _EditGroupInfoState createState() => _EditGroupInfoState();
// }

// class _EditGroupInfoState extends State<EditGroupInfo> {
//   var _repository = Repository();
//   FirebaseUser currentUser;
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _websiteController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.name;
//     _bioController.text = widget.bio;
//     _emailController.text = widget.email;
//     _phoneController.text = widget.phone;
//     _websiteController.text = widget.website;
//     _repository.getCurrentUser().then((user) {
//       setState(() {
//         currentUser = user;
//       });
//     });
//   }

//   File imageFile;

//   submit() {
//     _repository
//         .updateDetails(
//             currentUser.uid,
//             _nameController.text,
//             _bioController.text,
//             _emailController.text,
//             _phoneController.text,
//             _websiteController.text,
//             _locationController.text,
//             )
//         .then((v) {
//       //Navigator.pop(context);
//       Navigator.pop(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: new Color(0xfff6f6f6),
//         appBar: AppBar(
//           elevation: 0.5,
//           backgroundColor: Colors.white,
//           title: Text(
//             'Edit Group Info',
//             style: TextStyle(
//               fontFamily: FontNameDefault,
//               fontSize: textAppTitle(context),
//               color: Colors.black54,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           leading: GestureDetector(
//             child: Icon(Icons.keyboard_arrow_left,
//                 color: Colors.black54, size: screenSize.height * 0.045),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           actions: <Widget>[
//             _nameController.text.isNotEmpty ||
//                     _bioController.text.isNotEmpty ||
//                     _emailController.text.isNotEmpty ||
//                     _phoneController.text.isNotEmpty ||
//                     _websiteController.text.isNotEmpty
//                 ? Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: screenSize.height * 0.02,
//                       horizontal: screenSize.width / 50,
//                     ),
//                     child: GestureDetector(
//                       onTap: submit,
//                       child: Container(
//                         width: screenSize.width * 0.15,
//                         child: Center(
//                             child: Text(
//                           'Save',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontFamily: FontNameDefault,
//                             color: Colors.white,
//                             fontSize: textButton(context),
//                           ),
//                         )),
//                         decoration: ShapeDecoration(
//                           color: Theme.of(context).primaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(60.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container(),
//           ],
//         ),
//         body: ListView(
//           padding: EdgeInsets.fromLTRB(
//             screenSize.width / 11,
//             screenSize.height * 0.05,
//             screenSize.width / 11,
//             screenSize.height * 0.02,
//           ),
//           children: <Widget>[
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   //   color: const Color(0xffffffff),
//                   child: TextField(
//                     textCapitalization: TextCapitalization.words,
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textBody1(context),
//                     ),
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xffffffff),
//                       hintText: 'Name',
//                       labelText: 'Name',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenSize.height * 0.02,
//                 ),
//                 Container(
//                   //      color: const Color(0xffffffff),
//                   child: TextField(
//                     autocorrect: true,
//                     textCapitalization: TextCapitalization.sentences,
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textBody1(context),
//                     ),
//                     controller: _bioController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xffffffff),
//                         hintText: 'Bio',
//                         labelText: 'Bio'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenSize.height * 0.02,
//                 ),
//                 Divider(),
//                 Text(
//                   'Private Information',
//                   style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       color: Colors.black54,
//                       fontSize: textSubTitle(context),
//                       fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: screenSize.height * 0.02,
//                 ),
//                 Container(
//                   //    color: const Color(0xffffffff),
//                   child: TextField(
//                     readOnly: true,
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textBody1(context),
//                     ),
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xffffffff),
//                         hintText: 'Email address',
//                         labelText: 'Email address'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenSize.height * 0.02,
//                 ),
//                 Container(
//                   //     color: const Color(0xffffffff),
//                   child: TextField(
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textBody1(context),
//                     ),
//                     controller: _phoneController,
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xffffffff),
//                         hintText: 'Phone Number',
//                         labelText: 'Phone Number'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenSize.height * 0.02,
//                 ),
//                 Container(
//                   //    color: const Color(0xffffffff),
//                   child: TextField(
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textBody1(context),
//                     ),
//                     controller: _websiteController,
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xffffffff),
//                         hintText: 'https://website',
//                         labelText: 'Portfolio'),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void compressImage() async {
//     print('starting compression');
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     int rand = Random().nextInt(10000);

//     Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
//     //Im.copyResize(image, 500);

//     var newim2 = new File('$path/img_$rand.jpg')
//       ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

//     setState(() {
//       imageFile = newim2;
//     });
//     print('done');
//   }
// }

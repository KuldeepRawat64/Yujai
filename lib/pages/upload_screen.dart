// import 'dart:io';
// import 'package:Yujai/pages/home.dart';
// import 'package:Yujai/resources/repository.dart';
// import 'package:Yujai/style.dart';
// import 'package:Yujai/widgets/progress.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image/image.dart' as Im;
// import 'package:path_provider/path_provider.dart';
// import 'dart:math';

// // ignore: must_be_immutable
// class InstaUploadPhotoScreen extends StatefulWidget {
//   File imageFile;
//   InstaUploadPhotoScreen({this.imageFile});

//   @override
//   _InstaUploadPhotoScreenState createState() => _InstaUploadPhotoScreenState();
// }

// class _InstaUploadPhotoScreenState extends State<InstaUploadPhotoScreen> {
//   var _locationController;
//   var _captionController;
//   final _repository = Repository();

//   @override
//   void initState() {
//     super.initState();
//     _locationController = TextEditingController();
//     _captionController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _locationController?.dispose();
//     _captionController?.dispose();
//   }

//   bool _visibility = true;

//   void _changeVisibility(bool visibility) {
//     setState(() {
//       _visibility = visibility;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color(0xfff6f6f6),
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(
//               Icons.keyboard_arrow_left,
//               color: Colors.black54,
//               size: screenSize.height * 0.045,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           elevation: 0.5,
//           title: Text(
//             'New Post',
//             style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54,
//                 fontSize: textAppTitle(context)),
//           ),
//           backgroundColor: const Color(0xffffffff),
//           actions: <Widget>[
//             _visibility
//                 ? Padding(
//                     padding: EdgeInsets.only(
//                       right: screenSize.width / 30,
//                     ),
//                     child: GestureDetector(
//                       child: Icon(
//                         Icons.send,
//                         size: screenSize.height * 0.035,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       onTap: () {
//                         // To show the CircularProgressIndicator
//                         _changeVisibility(false);

//                         _repository.getCurrentUser().then((currentUser) {
//                           if (currentUser != null) {
//                             compressImage();
//                             _repository
//                                 .retreiveUserDetails(currentUser)
//                                 .then((user) {
//                               _repository
//                                   .uploadImageToStorage(widget.imageFile)
//                                   .then((url) {
//                                 _repository
//                                     .addPostToDb(
//                                         user,
//                                         url,
//                                         _captionController.text,
//                                         _locationController.text)
//                                     .then((value) {
//                                   print("Post added to db");
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: ((context) => Home())));
//                                 }).catchError((e) => print(
//                                         "Error adding current post to db : $e"));
//                               }).catchError((e) {
//                                 print("Error uploading image to storage : $e");
//                               });
//                             });
//                           } else {
//                             print("Current User is null");
//                           }
//                         });
//                       },
//                     ),
//                   )
//                 : Container()
//           ],
//         ),
//         body: ListView(
//           children: <Widget>[
//             !_visibility ? linearProgress() : Container(),
//             Column(children: [
//               widget.imageFile != null
//                   ? Container(
//                       height: screenSize.height * 0.5,
//                       child: Center(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: FileImage(widget.imageFile),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container(),
//               Padding(
//                 padding: EdgeInsets.only(top: screenSize.height * 0.012),
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.person,
//                   color: Theme.of(context).accentColor,
//                   size: screenSize.height * 0.04,
//                 ),
//                 title: Container(
//                   height: screenSize.height * 0.09,
//                   width: screenSize.width,
//                   child: TextField(
//                     autocorrect: true,
//                     textCapitalization: TextCapitalization.sentences,
//                     style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textBody1(context)),
//                     controller: _captionController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xffffffff),
//                       hintText: "Write a caption...",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(
//                   Icons.location_on,
//                   color: Theme.of(context).accentColor,
//                   size: screenSize.height * 0.04,
//                 ),
//                 title: Container(
//                   height: screenSize.height * 0.09,
//                   width: screenSize.width,
//                   child: TextField(
//                     autocorrect: true,
//                     textCapitalization: TextCapitalization.sentences,
//                     style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textBody1(context)),
//                     controller: _locationController,
//                     decoration: InputDecoration(
//                       hintText: "Where was this photo taken?",
//                       filled: true,
//                       fillColor: const Color(0xffffffff),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: screenSize.width,
//                 height: screenSize.height * 0.09,
//                 alignment: Alignment.center,
//                 child: RaisedButton.icon(
//                   label: Text(
//                     "Use Current Location",
//                     style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textSubTitle(context),
//                         color: Colors.white),
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(screenSize.height * 0.05),
//                   ),
//                   color: Theme.of(context).accentColor,
//                   onPressed: getUserLocation,
//                   icon: Icon(
//                     Icons.my_location,
//                     size: screenSize.height * 0.04,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ]),
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
//     Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
//     //Im.copyResize(image, height: 500);
//     var newim2 = new File('$path/img_$rand.jpg')
//       ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
//     setState(() {
//       widget.imageFile = newim2;
//     });
//     print('done');
//   }

//   getUserLocation() async {
//     Position position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     List<Placemark> placemarks = await Geolocator()
//         .placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark placemark = placemarks[0];
//     String completeAddress =
//         '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
//     print(completeAddress);
//     String formattedAddress = "${placemark.locality}, ${placemark.country}";
//     _locationController.text = formattedAddress;
//   }
// }

import 'dart:io';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:Yujai/models/group.dart';

import '../style.dart';

// ignore: must_be_immutable
class GroupUploadForum extends StatefulWidget {
  final String gid;
  final String name;
  File imageFile;
  final Group group;

  GroupUploadForum({this.gid, this.name, this.imageFile, this.group});
  @override
  _GroupUploadForumState createState() => _GroupUploadForumState();
}

class _GroupUploadForumState extends State<GroupUploadForum> {
  var _locationController;
  var _captionController;
  final _repository = Repository();
  String latitude;
  String longitude;
  var locationMessage = "";
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          //  centerTitle: true,
          title: Text(
            'New Post',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          actions: <Widget>[
            _visibility
                ? Padding(
                    padding: EdgeInsets.only(
                      right: screenSize.width / 30,
                    ),
                    child: GestureDetector(
                      child: Icon(
                        Icons.send,
                        size: screenSize.height * 0.035,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        // To show the CircularProgressIndicator
                        _changeVisibility(false);

                        _repository.getCurrentUser().then((currentUser) {
                          if (currentUser != null &&
                                  currentUser.uid ==
                                      widget.group.currentUserUid ||
                              widget.group.isPrivate == false) {
                            compressImage();
                            _repository
                                .retreiveUserDetails(currentUser)
                                .then((user) {
                              _repository
                                  .uploadImageToStorage(widget.imageFile)
                                  .then((url) {
                                _repository
                                    .addPostToForum(
                                        widget.gid,
                                        user,
                                        url,
                                        _captionController.text,
                                        _locationController.text)
                                    .then((value) {
                                  print("Post added to db");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => GroupPage(
                                                isMember: false,
                                                currentUser: user,
                                                gid: widget.gid,
                                                name: widget.name,
                                              ))));
                                }).catchError((e) => print(
                                        "Error adding current post to db : $e"));
                              }).catchError((e) {
                                print("Error uploading image to storage : $e");
                              });
                            });
                          } else {
                            compressImage();
                            _repository
                                .retreiveUserDetails(currentUser)
                                .then((user) {
                              _repository
                                  .uploadImageToStorage(widget.imageFile)
                                  .then((url) {
                                _repository
                                    .addPostToReview(
                                        widget.gid,
                                        user,
                                        url,
                                        _captionController.text,
                                        _locationController.text,
                                        'post')
                                    .then((value) {
                                  print("Post added to review");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => GroupPage(
                                                isMember: false,
                                                currentUser: user,
                                                gid: widget.gid,
                                                name: widget.name,
                                              ))));
                                }).catchError((e) => print(
                                        "Error adding current post to db : $e"));
                              }).catchError((e) {
                                print("Error uploading image to storage : $e");
                              });
                            });
                          }
                        });
                      },
                    ),
                  )
                : Container()
          ],
        ),
        body: ListView(
          children: <Widget>[
            !_visibility ? linearProgress() : Container(),
            Column(children: [
              widget.imageFile != null
                  ? Container(
                      height: screenSize.height * 0.5,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(widget.imageFile),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.012),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).accentColor,
                  size: screenSize.height * 0.04,
                ),
                title: Container(
                  //   color: const Color(0xffffffff),
                  width: screenSize.width,
                  child: TextField(
                    minLines: 1,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context)),
                    controller: _captionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: "Write a title...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(
                  //   height: 0,
                  ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).accentColor,
                      size: screenSize.height * 0.04,
                    ),
                    title: Container(
                      //   color: const Color(0xffffffff),
                      width: screenSize.width,
                      child: TextField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                        controller: _locationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: "Where was this photo taken?",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.09,
                    alignment: Alignment.center,
                    child: RaisedButton.icon(
                      label: Text(
                        "Use Current Location",
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.height * 0.05),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: _getCurrentPosition,
                      icon: Icon(
                        Icons.my_location,
                        size: screenSize.height * 0.04,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      widget.imageFile = newim2;
    });
    print('done');
  }

  Future<void> _getCurrentPosition() async {
    // verify permissions
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    }
    // get current position
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // get address
    String _currentAddress = await _getGeolocationAddress(_currentPosition);
    _locationController.text = _currentAddress;
  }

  // Method to get Address from position:

  Future<String> _getGeolocationAddress(Position position) async {
    // geocoding
    var places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (places != null && places.isNotEmpty) {
      final Placemark place = places.first;
      return "${place.thoroughfare}, ${place.locality}";
    }

    return "No address available";
  }
}

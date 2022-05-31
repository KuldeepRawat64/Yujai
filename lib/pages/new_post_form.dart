import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
//import 'package:location/location.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';

import '../style.dart';

class NewPostForm extends StatefulWidget {
  final Group group;
  final UserModel currentUser;

  const NewPostForm({Key key, this.group, this.currentUser}) : super(key: key);
  @override
  _NewPostFormState createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  // var _locationController;
  var _captionController;
  final _repository = Repository();
  String location = '';
  Position _currentPosition;
  // final Geolocator geolocator = Geolocator();
//  final Location location = Location();

// LocationData _location;
// String _error;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
              child: Container(
                height: screenSize.height * 0.25,
                width: screenSize.width,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: imageFile != null
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                            height: screenSize.height * 0.25,
                            width: screenSize.width,
                          ),
                          Positioned(
                            right: 5.0,
                            top: 5.0,
                            child: InkResponse(
                              onTap: () {
                                if (imageFile != null) {
                                  setState(() {
                                    imageFile = null;
                                  });
                                }
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _pickImage('Gallery').then((selectedImage) {
                                setState(() {
                                  imageFile = selectedImage;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/picture.png',
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width * 0.01,
                  right: screenSize.width * 0.01,
                  top: screenSize.height * 0.01),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                maxLength: 350,
                minLines: 1,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                controller: _captionController,
                key: Key("nameField"),
                //   onSaved: (val) => post.caption = val,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  // suffix: Row(
                  //   children: [

                  //     FlatButton(
                  //       child: Icon(Icons.photo),
                  //       onPressed: () {
                  //         _pickImage('Gallery').then((selectedImage) {
                  //           setState(() {
                  //             imageFile = selectedImage;
                  //           });
                  //         });
                  //       },
                  //     ),
                  //     FlatButton(
                  //       child: Icon(Icons.location_on_rounded),
                  //       onPressed: getUserLocation,
                  //     ),
                  //   ],
                  // ),
                  //   labelText: "Discussion",
                  hintText: 'Say something',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: FontNameDefault,
                    fontSize: textAppTitle(context),
                    //      fontWeight: FontWeight.bold,
                  ),
                  // border: OutlineInputBorder(
                  //   borderRadius: new BorderRadius.circular(10),
                  // ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter a text for your post";
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: screenSize.width * 0.01),
              child: Row(
                children: [
                  InkWell(
                    child: Icon(Icons.location_on_rounded),
                    onTap: _getCurrentPosition,
                  ),
                  location != ''
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            //      crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: screenSize.width * 0.6,
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    location = '';
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: _getCurrentPosition,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: Container(
                                width: screenSize.width * 0.6,
                                child: Text(
                                  'Add current location',
                                  //maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.02,
                  left: screenSize.width * 0.01,
                  right: screenSize.width * 0.01),
              child: InkWell(
                onTap: () {
                  _submitForm(context);
                },
                child: Container(
                    height: screenSize.height * 0.07,
                    width: screenSize.width * 0.8,
                    decoration: ShapeDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.height * 0.015),
                      child: Center(
                        child: Text(
                          'Create',
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

            // FlatButton(
            //     child: Text('Submit'),
            //     onPressed: () {
            //       _submitForm(context);
            //     }),
          ],
        ),
      ),
    );
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      imageFile = newim2;
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
    setState(() {
      location = _currentAddress;
    });
    print('Location: $location');
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

  _submitForm(BuildContext context) {
    //
    if (_formKey.currentState.validate()) {
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null &&
                currentUser.uid == widget.group.currentUserUid ||
            widget.group.isPrivate == false) {
          if (imageFile == null) {
            _repository
                .addDiscussionToForum(widget.group.uid, widget.currentUser,
                    _captionController.text)
                .catchError(
                    (e) => print("Error adding current discussion to group$e"));
          } else {
            compressImage();
            _repository.retreiveUserDetails(currentUser).then((user) {
              _repository.uploadImageToStorage(imageFile).then((url) {
                _repository
                    .addPostToForum(widget.group.uid, user, url,
                        _captionController.text, location)
                    .catchError(
                        (e) => print("Error adding current post to db : $e"));
              }).catchError((e) {
                print("Error uploading image to storage : $e");
              });
            });
          }
        } else {
          if (imageFile == null) {
            _repository
                .addDiscussionToForum(widget.group.uid, widget.currentUser,
                    _captionController.text)
                .catchError(
                    (e) => print("Error adding current discussion to group$e"));
          } else {
            compressImage();
            _repository.retreiveUserDetails(currentUser).then((user) {
              _repository.uploadImageToStorage(imageFile).then((url) {
                _repository
                    .addPostToReview(widget.group.uid, user, url,
                        _captionController.text, location, 'post')
                    .catchError(
                        (e) => print("Error adding current post to db : $e"));
              }).catchError((e) {
                print("Error uploading image to storage : $e");
              });
            });
          }
        }
      });
      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }
}

import 'package:Yujai/models/group.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:Yujai/resources/repository.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class EditPhotoUrl extends StatefulWidget {
  final String photoUrl;
  final Group group;
  const EditPhotoUrl({this.photoUrl, this.group});
  @override
  _EditPhotoUrlState createState() => _EditPhotoUrlState();
}

class _EditPhotoUrlState extends State<EditPhotoUrl> {
  var _repository = Repository();
  User currentUser;

  @override
  void initState() {
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    super.initState();
  }

  File imageFile;
  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);

    return File(selectedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: screenSize.height * 0.022,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: GestureDetector(
            child: Icon(Icons.keyboard_arrow_left,
                color: Colors.black54, size: screenSize.height * 0.045),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     vertical: screenSize.height * 0.015,
            //     horizontal: screenSize.width / 50,
            //   ),
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: Container(
            //       height: screenSize.height * 0.055,
            //       width: screenSize.width / 5,
            //       child: Center(
            //           child: Text(
            //         'Save',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: screenSize.height * 0.022,
            //         ),
            //       )),
            //       decoration: ShapeDecoration(
            //         color: Theme.of(context).primaryColor,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(60.0),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            screenSize.width / 11,
            screenSize.height * 0.05,
            screenSize.width / 11,
            screenSize.height * 0.02,
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                          width: 110.0,
                          height: 110.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            image: DecorationImage(
                                image: widget.photoUrl.isEmpty
                                    ? AssetImage(
                                        'assets/images/group_no-image.png')
                                    : CachedNetworkImageProvider(
                                        widget.group.groupProfilePhoto),
                                fit: BoxFit.cover),
                          )),
                    ),
                    onTap: _showImageDialog),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text('Change Photo',
                        style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  onTap: _showImageDialog,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, widget.group.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, widget.group.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}

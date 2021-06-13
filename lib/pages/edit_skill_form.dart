import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';

class EditSkillForm extends StatefulWidget {
  final User currentUser;

  EditSkillForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditSkillForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  FirebaseUser currentUser;
  final _skillController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  double number = 5;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  File imageFile;

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .updateData({
        'skills': FieldValue.arrayUnion([
          {
            'skill': _skillController.text,
            'level': number,
          }
        ])
      }).then((value) {
        _skillController.clear();
      });
      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.04,
            screenSize.height * 0.05,
            screenSize.width * 0.04,
            screenSize.height * 0.1,
          ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  key: Key('nameField'),
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _skillController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    //    hintText: 'Name',
                    labelText: 'Skill',
                    labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textAppTitle(context),
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a skill";
                    } else {
                      if (widget.currentUser.skills
                          .any((e) => e['skill'].contains(value))) {
                        return 'Skill already exist';
                      }

                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.03,
                ),
                Text(
                  'Level : ${number <= 3 ? 'Beginner' : number >= 3 && number <= 7 ? 'Intermediate' : number >= 8 ? 'Expert' : 'Beginner'}',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                    value: number,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: number.round().toString(),
                    onChanged: (double val) {
                      setState(() {
                        number = val;
                      });
                    }),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.05,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      submit(context);
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //  width: screenSize.width * 0.8,
                        decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.015),
                          child: Center(
                            child: Text(
                              'Add skill',
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
              ],
            )
          ],
        ),
      ),
    );
  }

  // void compressImage() async {
  //   print('starting compression');
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   int rand = Random().nextInt(10000);

  //   Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
  //   //Im.copyResize(image, 500);

  //   var newim2 = new File('$path/img_$rand.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

  //   setState(() {
  //     imageFile = newim2;
  //   });
  //   print('done');
  // }
}

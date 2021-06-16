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

import 'home.dart';

class EditPurposeForm extends StatefulWidget {
  final UserModel currentUser;

  EditPurposeForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class Purpose {
  const Purpose(this.name);
  final String name;
}

class _EditProfileScreenState extends State<EditPurposeForm>
    with SingleTickerProviderStateMixin {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  User currentUser;
  List<Purpose> _purposes;
  List<String> _filters;
  final _skillController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  double number = 5;
  int index = 0;
  GlobalKey<ScaffoldState> _key;
  bool isLoading = false;
  bool isSelected = false;
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    _key = GlobalKey<ScaffoldState>();
    _filters = <String>[];
    _purposes = <Purpose>[
      const Purpose('Full-time jobs'),
      const Purpose('Part-time jobs'),
      const Purpose('Event-based jobs'),
      const Purpose('Task-based jobs'),
      const Purpose('Freelancing'),
      const Purpose('Mentoring'),
      const Purpose('Research & Development'),
      const Purpose('Seeking help'),
      const Purpose('Social work'),
      const Purpose('Promote yourself'),
      const Purpose('Build network'),
      const Purpose('Find opportunities'),
      const Purpose('Career switch'),
    ];
  }

  File imageFile;

  // submit(BuildContext context) {
  //   if (_formKey.currentState.validate()) {
  //     Firestore.instance
  //         .collection('users')
  //         .document(currentUser.uid)
  //         .updateData({
  //       'skills': FieldValue.arrayUnion([
  //         {
  //           'skill': _skillController.text,
  //           'level': number,
  //         }
  //       ])
  //     }).then((value) {
  //       _skillController.clear();
  //     });
  //     _formKey.currentState.save();
  //     Navigator.pop(context);
  //   }
  // }

  submit() async {
    User currentUser = await _auth.currentUser;
    usersRef.doc(currentUser.uid).update({
      "purpose": FieldValue.arrayUnion(_filters),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.only(top: screenSize.height * 0.012),
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenSize.height * 0.01,
                    ),
                    child: Text(
                      'Purpose',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textHeader(context),
                        //   color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: purposeWidgets.toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.01,
                      bottom: screenSize.height * 0.03,
                    ),
                    child: InkWell(
                      onTap: submit,
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
                                'Update',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Iterable<Widget> get purposeWidgets sync* {
    var screenSize = MediaQuery.of(context).size;
    for (Purpose purpose in _purposes) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Colors.grey[200],
          elevation: 0.0,
          selectedColor: Colors.grey[400],
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
//fontSize: textBody1(context),
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          avatar: CircleAvatar(
            child: Text(purpose.name[0].toUpperCase()),
          ),
          label: Text(purpose.name),
          selected: _filters.contains(purpose.name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(purpose.name);
                isSelected = selected;
              } else {
                _filters.removeWhere((String name) {
                  return name == purpose.name;
                });
                isSelected = false;
              }
            });
          },
        ),
      );
    }
  }

  Widget chip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(6.0),
    );
  }
}

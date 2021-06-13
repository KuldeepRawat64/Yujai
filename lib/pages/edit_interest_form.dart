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

class EditInterestForm extends StatefulWidget {
  final User currentUser;

  EditInterestForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class Interest {
  const Interest(this.name);
  final String name;
}

class _EditProfileScreenState extends State<EditInterestForm>
    with SingleTickerProviderStateMixin {
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
  GlobalKey<ScaffoldState> _key;
  List<Interest> _interests;
  List<String> _filters;
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
    _interests = <Interest>[
      const Interest('Computers'),
      const Interest('Software'),
      const Interest('Finance'),
      const Interest('Management'),
      const Interest('Video Games'),
      const Interest('Artificial Intelligence'),
      const Interest('Creative Writing'),
      const Interest('Renewable Energy'),
      const Interest('Space Exploration'),
      const Interest('Mindfulness'),
      const Interest('Theater'),
      const Interest('Recycling'),
      const Interest('Fashion'),
      const Interest('Food'),
      const Interest('Music'),
      const Interest('Lifestyle'),
      const Interest('Fitness'),
      const Interest('DIY'),
      const Interest('Politics'),
      const Interest('Parenting'),
      const Interest('Business'),
      const Interest('News'),
      const Interest('Caligraphy'),
      const Interest('Travelling'),
      const Interest('Solar Energy'),
      const Interest('Mountain Climbing'),
      const Interest('Photography'),
      const Interest('Design'),
      const Interest('Creative Art'),
      const Interest('Sketching'),
      const Interest('Writing'),
      const Interest('Blogging'),
      const Interest('Podcasting'),
      const Interest('Marketing'),
      const Interest('Sports'),
      const Interest('Reading'),
      const Interest('Public Speaking'),
      const Interest('Camping'),
      const Interest('Exploring other cultures'),
      const Interest('Local meetups'),
      const Interest('Dancing'),
      const Interest('Language classes'),
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
    FirebaseUser currentUser = await _auth.currentUser();
    usersRef.document(currentUser.uid).updateData({
      "interests": FieldValue.arrayUnion(_filters),
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
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     bottom: screenSize.height * 0.01,
                  //   ),
                  //   child: Text(
                  //     'Interest',
                  //     style: TextStyle(
                  //       fontFamily: FontNameDefault,
                  //       fontSize: textHeader(context),
                  //       //   color: Colors.black54,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: interestWidgets.toList(),
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

  Iterable<Widget> get interestWidgets sync* {
    var screenSize = MediaQuery.of(context).size;
    for (Interest interest in _interests) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Colors.grey[50],
          elevation: 0.0,
          selectedColor: Colors.grey[200],
          avatar: CircleAvatar(
            child: Text(interest.name[0].toUpperCase()),
          ),
          label: Text(interest.name),
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
//fontSize: textBody1(context),
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          selected: _filters.contains(interest.name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(interest.name);
                isSelected = selected;
              } else {
                _filters.removeWhere((String name) {
                  return name == interest.name;
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
      elevation: 12.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(6.0),
    );
  }
}

import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'create_group.dart';

class GroupSettings extends StatefulWidget {
  final String gid;
  final String name;
  final String description;
  final List<dynamic> rules;
  final bool isPrivate;
  final bool isHidden;
  final Group group;
  final Team team;
  final UserModel currentuser;
  const GroupSettings({
    this.gid,
    this.name,
    this.group,
    this.currentuser,
    this.team,
    this.description,
    this.rules,
    this.isPrivate,
    this.isHidden,
  });
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  Group _group;
  bool isPrivate = false;
  bool isHidden = false;
  UserModel _user;
  var _repository = Repository();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  List<String> reportList = [
    "Be Kind and Courteous",
    "No Hate Speech or Bullying",
    "No Promotions or Spam",
    "Respect Everyone's Privacy",
    "No 18+ content",
    "It’s OK to agree to disagree",
    "Confidentiality"
  ];

  List<dynamic> selectedReportList = List();

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Group Rules",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textHeader(context)),
            ),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
                submit(context);
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black),
                ),
                onPressed: () {
                  //  print('$selectedReportList');
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.white),
                ),
                onPressed: () {
                  print('$selectedReportList');
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }).then((val) {
      retrieveGroupDetails();
      if (!mounted) return;
      setState(() {
        _group = _group;
      });
    });
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
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 25));
    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  retrieveGroupDetails() async {
    //FirebaseUser currentUser = await _repository.getCurrentUser();
    Group group = await _repository.retreiveGroupDetails(widget.gid);
    if (!mounted) return;
    setState(() {
      _group = group;
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveGroupDetails();
    if (!mounted) return;
    _nameController.text = widget.name;
    _descriptionController.text = widget.description;
    selectedReportList = widget.rules;
    if (!mounted) return;
    setState(() {
      isPrivate = widget.isPrivate;
      isHidden = widget.isHidden;
    });
  }

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      groupsRef.doc(_group.uid).update({
        "isPrivate": isPrivate,
        "isHidden": isHidden,
        "groupName": _nameController.text,
        "description": _descriptionController.text,
        "rules": selectedReportList,
      });

      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  // retrieveGroupDetails() async {
  //   FirebaseUser currentUser = await _repository.getCurrentUser();
  //   Group group = await _repository.retreiveGroupDetails(currentUser);
  //   if (!mounted) return;
  //   setState(() {
  //     _group = group;
  //     isPrivate = user.isPrivate;
  //     isHidden = user.isHidden;
  //   });
  // }
  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: strings.isNotEmpty
          ? strings
              .map((items) => Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.01),
                    child: chip(items, Colors.white),
                  ))
              .toList()
          : Container(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      // labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FontNameDefault,
          color: Colors.black,
          fontSize: textbody2(context),
        ),
      ),
      backgroundColor: color,
      elevation: 0.0,
      shadowColor: Colors.grey[60],
      // padding: EdgeInsets.only(screenSize.height * 0.01),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          title: Text(
            'Group Settings',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.fromLTRB(
                screenSize.width / 11,
                screenSize.height * 0.025,
                screenSize.width / 11,
                screenSize.height * 0.025,
              ),
              children: [
                _group != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Basic Info',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  //color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textHeader(context)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    stream:
                                        groupsRef.doc(widget.gid).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.connectionState ==
                                              ConnectionState.active ||
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        if (snapshot.hasError) {
                                          return CircleAvatar(
                                            radius: screenSize.height * 0.045,
                                            backgroundImage: AssetImage(
                                                'assets/images/error.png'),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: screenSize.height * 0.045,
                                            backgroundImage: NetworkImage(
                                                snapshot
                                                    .data['groupProfilePhoto']),
                                          );
                                        }
                                      }

                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }),
                                SizedBox(
                                  width: screenSize.width * 0.08,
                                ),
                                InkWell(
                                  onTap: () {
                                    _pickImage('Gallery').then((selectedImage) {
                                      setState(() {
                                        imageFile = selectedImage;
                                      });
                                      compressImage();
                                      _repository
                                          .uploadImageToStorage(imageFile)
                                          .then((url) {
                                        groupsRef.doc(widget.gid).update({
                                          'groupProfilePhoto': url
                                        }).catchError((e) => print(
                                            'Error changing team icon : $e'));
                                      }).catchError((e) => print(
                                              'Error upload icon to storage : $e'));
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                width: 0.3,
                                                color: Colors.grey))),
                                    child: Text(
                                      'Change Profile Photo',
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        // fontSize: textSubTitle(context)
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            //   color: const Color(0xffffffff),
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please enter a group name';
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold),
                              controller: _nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  hintText: 'Name',
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.grey,
                                      //   fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context))),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          Container(
                            //      color: const Color(0xffffffff),
                            child: TextField(
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold),
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  hintText: 'Description',
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.grey,
                                      //   fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context))),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          _group.rules.isEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: screenSize.height * 0.02),
                                      child: Text(
                                        'Group Rules',
                                        style: TextStyle(
                                          //color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontNameDefault,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Select Group Rules",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize:
                                                          textHeader(context)),
                                                ),
                                                content: MultiSelectChip(
                                                  reportList,
                                                  onSelectionChanged:
                                                      (selectedList) {
                                                    setState(() {
                                                      selectedReportList =
                                                          selectedList;
                                                    });
                                                    submit(context);
                                                  },
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize:
                                                              textSubTitle(
                                                                  context),
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      //  print('$selectedReportList');
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.0)),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize:
                                                              textSubTitle(
                                                                  context),
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          '$selectedReportList');
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            }).then((val) {
                                          retrieveGroupDetails();
                                          if (!mounted) return;
                                          setState(() {
                                            _group = _group;
                                          });
                                        });
                                      },
                                      child: Container(
                                        height: screenSize.height * 0.045,
                                        width: screenSize.width / 6,
                                        child: Center(
                                            child: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black54,
                                        )),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 0.1,
                                                color: Colors.black54),
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: screenSize.height * 0.02),
                                          child: Text(
                                            'Group Rules',
                                            style: TextStyle(
                                              //      color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: FontNameDefault,
                                              fontSize: textSubTitle(context),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _showReportDialog,
                                          child: Container(
                                            height: screenSize.height * 0.045,
                                            width: screenSize.width / 6,
                                            child: Center(
                                                child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: FontNameDefault,
                                                color: Colors.black,
                                                fontSize: textButton(context),
                                              ),
                                            )),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1.5,
                                                    color: Colors.black54),
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        _group != null
                                            ? getTextWidgets(_group.rules)
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          Divider(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              'Privacy Info',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  //       color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textHeader(context)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0)),
                            height: screenSize.height * 0.07,
                            width: screenSize.width,
                            padding: EdgeInsets.only(
                                left: screenSize.width / 30,
                                top: screenSize.height * 0.012,
                                bottom: screenSize.height * 0.012),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Private Group',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context)),
                                ),
                                Switch(
                                  value: isPrivate,
                                  onChanged: (value) {
                                    setState(() {
                                      isPrivate = value;
                                      print(isPrivate);
                                    });
                                    submit(context);
                                  },
                                  activeColor: Colors.green,
                                  activeTrackColor: Colors.greenAccent,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          isPrivate
                              ? Text(
                                  'Your group activity, information are private. This will hide  all the above informations. Users will now have to request you to join the group to see group details.',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black54,
                                      fontSize: textBody1(context)),
                                )
                              : Text(
                                  'Your group activity and group information are public.',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black54,
                                      fontSize: textBody1(context)),
                                ),
                          SizedBox(
                            height: screenSize.height * 0.03,
                          ),
                        ],
                      )
                    : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Account Info',
                    //   style: TextStyle(
                    //       fontFamily: FontNameDefault,
                    //       color: Colors.black54,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: textAppTitle(context)),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      height: screenSize.height * 0.07,
                      width: screenSize.width,
                      padding: EdgeInsets.only(
                          left: screenSize.width / 30,
                          top: screenSize.height * 0.012,
                          bottom: screenSize.height * 0.012),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Group Hidden',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context)),
                          ),
                          Switch(
                            value: isHidden,
                            onChanged: (value) {
                              setState(() {
                                isHidden = value;
                                print(isHidden);
                              });
                              submit(context);
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    isHidden
                        ? Text(
                            'Your group and all activities are hidden throughout the app.',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black54,
                                fontSize: textBody1(context)),
                          )
                        : Text(
                            'Your group is visible.',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black54,
                                fontSize: textBody1(context)),
                          ),

                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Divider(),
                    InkWell(
                      onTap: deleteDialog,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'Delete Group',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: textHeader(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenSize.height * 0.02,
                          left: screenSize.width * 0.01,
                          right: screenSize.width * 0.01),
                      child: InkWell(
                        onTap: () {
                          submit(context);
                        },
                        child: Container(
                            //  height: screenSize.height * 0.07,
                            width: screenSize.width * 0.3,
                            decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenSize.height * 0.012),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenSize.height * 0.02,
                          left: screenSize.width * 0.01,
                          right: screenSize.width * 0.01),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            //  height: screenSize.height * 0.07,
                            width: screenSize.width * 0.3,
                            decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey[300]),
                                    borderRadius: BorderRadius.circular(8.0))),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenSize.height * 0.012),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }

  deleteDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              //    overflow: Overflow.visible,
              children: [
                Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Group',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textHeader(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: screenSize.height * 0.09,
                        child: Text(
                          'Are you sure you want to delete this group? This action will delete this group and all the data in this group permanently!',
                          style: TextStyle(color: Colors.black54),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('groups')
                                  .doc(widget.gid)
                                  .delete()
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.currentuser.uid)
                                    .collection('groups')
                                    .doc(widget.gid)
                                    .delete();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              });
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }
}

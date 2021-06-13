import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';

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
  final User currentuser;
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
  User _user;
  var _repository = Repository();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
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
                submit();
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

  submit() {
    groupsRef.document(_group.uid).updateData({
      "isPrivate": isPrivate,
      "isHidden": isHidden,
      "groupName": _nameController.text,
      "description": _descriptionController.text,
      "rules": selectedReportList,
    });
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
        body: ListView(
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
                        Container(
                          //   color: const Color(0xffffffff),
                          child: TextField(
                            onSubmitted: (val) {
                              submit();
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
                            onSubmitted: (val) {
                              submit();
                            },
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
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: FontNameDefault,
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
                                                  submit();
                                                },
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontSize: textSubTitle(
                                                            context),
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    //  print('$selectedReportList');
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.0)),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontSize: textSubTitle(
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
                                  submit();
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
                            submit();
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
            ]),
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
                              Firestore.instance
                                  .collection('groups')
                                  .document(widget.gid)
                                  .delete()
                                  .then((value) {
                                Firestore.instance
                                    .collection('users')
                                    .document(widget.currentuser.uid)
                                    .collection('groups')
                                    .document(widget.gid)
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

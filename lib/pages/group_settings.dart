import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';

class GroupSettings extends StatefulWidget {
  final String gid;
  final String name;
  final Group group;
  final Team team;
  final User currentuser;
  const GroupSettings({
    this.gid,
    this.name,
    this.group,
    this.currentuser,
    this.team,
  });
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  bool isPrivate = false;
  bool isHidden = false;
  User _user;
  var _repository = Repository();
  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  submit() {
    usersRef.document(_user.uid).updateData({
      "isPrivate": isPrivate,
      "isHidden": isHidden,
    });
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
      isPrivate = user.isPrivate;
      isHidden = user.isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
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
              screenSize.height * 0.055,
              screenSize.width / 11,
              screenSize.height * 0.025,
            ),
            children: [
              _user != null && _user.accountType != 'Company'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Group Info',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: textHeader(context)),
                        ),
                        Container(
                          height: screenSize.height * 0.07,
                          width: screenSize.width,
                          color: Colors.white,
                          padding: EdgeInsets.only(
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
                    height: screenSize.height * 0.07,
                    width: screenSize.width,
                    color: Colors.white,
                    padding: EdgeInsets.only(
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
                ],
              ),
            ]),
      ),
    );
  }
}

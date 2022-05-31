import 'package:Yujai/pages/edit_skill_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';

class EditProfileSkill extends StatefulWidget {
  final UserModel currentUser;

  const EditProfileSkill({Key key, this.currentUser}) : super(key: key);

  @override
  _EditProfileSkillState createState() => _EditProfileSkillState();
}

class _EditProfileSkillState extends State<EditProfileSkill> {
  bool isOnline = false;
  bool isClicked = false;
  int _widgetId = 1;
  Map<String, dynamic> currentSkill;
  var _repository = Repository();
  User currentUser;
  UserModel _user;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  getPercent(double level) {
    if (level == 0) {
      return 0.0;
    } else {
      return level / 10 * 1.0;
    }
  }

  Widget getSkills(List<dynamic> skill) {
    return Column(
      children: skill != null
          ? skill
              .map((e) => Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: Colors.grey[100])
                        ]),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          isClicked = true;
                          _widgetId = 1;
                          currentSkill = e;
                        });
                      },
                      //  isThreeLine: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textAppTitle(context),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['skill'],
                            style: TextStyle(
                              //   color: Colors.black,
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Level : ${e['level'] <= 3 ? 'Beginner' : e['level'] >= 3 && e['level'] <= 7 ? 'Intermediate' : e['level'] >= 8 ? 'Expert' : 'Beginner'}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              //    fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                  ))
              .toList()
          : Container(),
    );
  }

  Widget getSkillsListView(List<dynamic> skills) {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skills[index]['skill'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textAppTitle(context),
                  //     color: Colors.white,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  LinearPercentIndicator(
                    width: screenSize.width * 0.65,
                    backgroundColor: Colors.grey[100],
                    //  lineHeight: 10.0,
                    animation: true,
                    animationDuration: 500,
                    progressColor: Theme.of(context).primaryColor,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    //   fillColor: Theme.of(context).primaryColor,
                    percent: getPercent(skills[index]['level']),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUser.uid)
                          .update({
                        'skills': FieldValue.arrayRemove([skills[index]])
                      }).then((value) {
                        retrieveUserDetails();
                        setState(() {
                          _user = _user;
                        });
                      });
                    },
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return _user != null
        ? SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: screenSize.height * 0.95,
                child: Column(
                  // shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: screenSize.height * 0.01,
                              top: screenSize.height * 0.02,
                              left: screenSize.width * 0.05,
                              right: screenSize.width * 0.05),
                          child: !isClicked
                              ? Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textHeader(context),
                                      fontWeight: FontWeight.bold),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      isClicked = !isClicked;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[200],
                                    child: Icon(
                                      Icons.keyboard_arrow_left,
                                      color: Colors.black54,
                                    ),
                                  )
                                  //  Text(
                                  //   'Cancel',
                                  //   style: TextStyle(
                                  //     fontFamily: FontNameDefault,
                                  //     fontSize: textSubTitle(context),
                                  //     //fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: screenSize.height * 0.01,
                              top: screenSize.height * 0.02,
                              left: screenSize.width * 0.05,
                              right: screenSize.width * 0.05),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[200],
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                              )
                              //  Text(
                              //   'Cancel',
                              //   style: TextStyle(
                              //     fontFamily: FontNameDefault,
                              //     fontSize: textSubTitle(context),
                              //     //fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              ),
                        )
                      ],
                    ),
                    !isClicked
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: screenSize.height * 0.05,
                                      left: screenSize.width * 0.05,
                                      right: screenSize.width * 0.05),
                                  child: _user.skills.isEmpty
                                      ? Text(
                                          'Add skills so people will know about it.',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textAppTitle(context),
                                            //  fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      :
                                      //_buildList(context)
                                      // getSkills(widget.currentUser.skills),
                                      getSkillsListView(_user.skills)),
                              _user.skills.length < 5
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: screenSize.height * 0.05,
                                          left: screenSize.width * 0.05,
                                          right: screenSize.width * 0.05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isClicked = true;
                                            _widgetId = 2;
                                          });
                                        },
                                        child: Container(
                                            //    width: screenSize.width * 0.8,
                                            decoration: ShapeDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0))),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  screenSize.height * 0.015),
                                              child: Center(
                                                child: Text(
                                                  'Add skill',
                                                  style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textAppTitle(context),
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'You can only add upto 5 skills for now',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          //     fontSize: textAppTitle(context),
                                          //    color: Colors.white,
                                          //   fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        : _renderWidget(),
                    // Container(
                    //   child: EditSkillForm(
                    //     currentUser: widget.currentUser,
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _renderWidget1() {
    return Container(
      key: Key('First'),
      child: EditSkillForm(
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _renderWidget2() {
    return Container(
      key: Key('Second'),
      child: EditSkillForm(
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _renderWidget1() : _renderWidget2();
  }
}

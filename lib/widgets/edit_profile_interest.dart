import 'package:Yujai/pages/edit_interest_form.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';

class EditProfileInterest extends StatefulWidget {
  final UserModel currentUser;

  const EditProfileInterest({Key key, this.currentUser}) : super(key: key);

  @override
  _EditProfileInterestState createState() => _EditProfileInterestState();
}

class _EditProfileInterestState extends State<EditProfileInterest> {
  bool isOnline = false;
  bool isClicked = false;
  int _widgetId = 1;
  // Map<String, dynamic> currentSkill;
  var _repository = Repository();
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

  Widget getInterestsListView(List<dynamic> interests) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: interests.length,
        itemBuilder: (context, index) {
          return Wrap(
            direction: Axis.horizontal,
            //  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                onDeleted: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentUser.uid)
                      .update({
                    'interests': FieldValue.arrayRemove([interests[index]])
                  }).then((value) {
                    retrieveUserDetails();
                    setState(() {
                      _user = _user;
                    });
                  });
                },
                label: Text(
                  interests[index],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textAppTitle(context),
                    //     color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                  //shrinkWrap: true,
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
                                  'Edit interests',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textAppTitle(context),
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
                        ? Container(
                            height: screenSize.height * 0.85,
                            child: ListView(
                              shrinkWrap: true,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height * 0.05,
                                        left: screenSize.width * 0.05,
                                        right: screenSize.width * 0.05),
                                    child: _user.interests.isEmpty
                                        ? Text(
                                            'Add interests so people will know about it.',
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textAppTitle(context),
                                              //  fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        :
                                        //_buildList(context)
                                        // getinterests(widget.currentUser.interests),
                                        getInterestsListView(_user.interests)),
                                // _user.interests.length < 5
                                //     ?
                                Padding(
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0))),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              screenSize.height * 0.015),
                                          child: Center(
                                            child: Text(
                                              'Add intersts',
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
                                // : Padding(
                                //   //   padding: const EdgeInsets.all(20.0),
                                //   //   child: Text(
                                //   //     'You can only add upto 5 interests for now',
                                //   //     style: TextStyle(
                                //   //       fontFamily: FontNameDefault,
                                //   //       //     fontSize: textAppTitle(context),
                                //   //       //    color: Colors.white,
                                //   //       //   fontWeight: FontWeight.bold,
                                //   //     ),
                                //   //   ),
                                //   // ),
                              ],
                            ),
                          )
                        : _renderWidget(),
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
      child: EditInterestForm(
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _renderWidget2() {
    return Container(
      key: Key('Second'),
      child: EditInterestForm(
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _renderWidget1() : _renderWidget2();
  }
}

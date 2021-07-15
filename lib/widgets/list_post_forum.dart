import 'dart:async';
import 'dart:math';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/like.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/vote.dart';
import 'package:Yujai/pages/comment_group.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/pages/likes_screen.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:transparent_image/transparent_image.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPostForum extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final UserModel currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;
  ListPostForum({
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.group,
  });

  @override
  _ListPostForumState createState() => _ListPostForumState();
}

class _ListPostForumState extends State<ListPostForum> {
  var _repository = Repository();
  bool _isLiked = false;
  bool _selected1 = false;
  bool _selected2 = false;
  bool _selected3 = false;
  bool _selected4 = false;
  bool _selected5 = false;
  bool _selected6 = false;
  int timeInMillis = 1586348737122;
  int counter = 0;
  String selectedSubject;
  final _bodyController = TextEditingController();
  bool _isVoted = false;
  //bool _isExpired = false;
  List<DocumentSnapshot> listVotes = [];
  List<DocumentSnapshot> listVotes2 = [];
  List<DocumentSnapshot> listVotes3 = [];
  List<DocumentSnapshot> listVotes4 = [];
  List<DocumentSnapshot> listVotes5 = [];
  List<DocumentSnapshot> listVotes6 = [];
  List<DocumentSnapshot> totalVotes = [];
  bool _displayFront;
  bool _flipXAxis;
  bool seeMore = false;

  Widget commentWidget(DocumentReference reference) {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              '${snapshot.data.length}',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreenGroup(
                            group: widget.group,
                            snapshot: widget.documentSnapshot,
                            followingUser: widget.currentuser,
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: Container());
        }
      }),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text +
          '\n Owner ID : ${widget.documentSnapshot.data()['ownerUid']}' +
          '\ Post ID : ${widget.documentSnapshot.data()['postId']}' +
          '\n Sent from Yujai',
      subject: selectedSubject,
      recipients: ['animusitmanagement@gmail.com'],
      //attachmentPaths: [widget.documentSnapshot.data['imgUrl']],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print('$platformResponse');
    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(platformResponse),
    // ));
  }

  buildPollDetail() {
    _repository
        .checkIfUserVotedOrNot(widget.currentuser.uid,
            widget.documentSnapshot.reference, 'option1')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _selected1 = value;
      });
    });

    _repository
        .checkIfUserVotedOrNot(
            widget.currentuser.uid, widget.documentSnapshot.reference, 'votes')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _isVoted = value;
      });
    });

    _repository
        .checkIfUserVotedOrNot(widget.currentuser.uid,
            widget.documentSnapshot.reference, 'option2')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _selected2 = value;
      });
    });
    _repository
        .checkIfUserVotedOrNot(widget.currentuser.uid,
            widget.documentSnapshot.reference, 'option3')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _selected3 = value;
      });
    });
    _repository
        .checkIfUserVotedOrNot(widget.currentuser.uid,
            widget.documentSnapshot.reference, 'option4')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _selected4 = value;
      });
    });

    _repository
        .fetchPerVotes(widget.documentSnapshot.reference, 'option1')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          listVotes = value;
        });
      }
    });
    _repository
        .fetchPerVotes(widget.documentSnapshot.reference, 'option2')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          listVotes2 = value;
        });
      }
    });
    _repository
        .fetchPerVotes(widget.documentSnapshot.reference, 'option3')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          listVotes3 = value;
        });
      }
    });

    _repository
        .fetchPerVotes(widget.documentSnapshot.reference, 'option4')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          listVotes4 = value;
        });
      }
    });

    _repository
        .fetchPerVotes(widget.documentSnapshot.reference, 'votes')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          totalVotes = value;
        });
      }
    });
    // checkPollTimeStatus(widget.documentSnapshot.data()['pollLength']);
  }

  checkPollLength(int time) {
    if (DateTime.now().millisecondsSinceEpoch >= time) {
      if (!mounted) return;
      setState(() {
        _isVoted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
    // checkPollValidity(widget.documentSnapshot.data()['pollLength']);
    buildPollDetail();

    // checkPollLength(widget.documentSnapshot.data()['pollLength']);
    _displayFront = true;
    _flipXAxis = true;
    _repository
        .checkIfUserLikedOrNot(
            widget.currentuser.uid, widget.documentSnapshot.reference)
        .then((value) {
      if (!mounted) return;
      setState(() {
        _isLiked = value;
      });
    });
  }

  setSelectedSubject(String val) {
    setState(() {
      selectedSubject = val;
    });
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      direction: Axis.vertical,
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.006),
                child: Container(
                  height: screenSize.height * 0.05,
                  width: screenSize.width / 1.2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                      child: Text(
                    items,
                    style: TextStyle(
                        fontSize: textBody1(context),
                        fontFamily: FontNameDefault,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ))
          .toList(),
    );
  }

  Widget option1Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text('${_getPercentage()}'.substring(0, 3).replaceAll('.', ''),
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
          Text(' % ',
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Widget option2Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text('${_getPercentage2()}'.substring(0, 3).replaceAll('.', ''),
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
          Text(' % ',
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Widget option3Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text('${_getPercentage3()}'.substring(0, 3).replaceAll('.', ''),
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
          Text(' % ',
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Widget option4Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text('${_getPercentage4()}'.substring(0, 3).replaceAll('.', ''),
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
          Text(' % ',
              //  .replaceAll('.0', ' %  ')
              //   .replaceAll('NaN', ' %  ')
              //   .replaceAll('Infinity', ' %  '),
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context),
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FontNameDefault,
          color: Colors.white,
          fontSize: textBody1(context),
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.01),
    );
  }

  _getPercentage4() => (listVotes4.length / totalVotes.length) * 100;
  _getPercentage() => (listVotes.length / totalVotes.length) * 100;
  _getPercentage2() => (listVotes2.length / totalVotes.length) * 100;
  _getPercentage3() => (listVotes3.length / totalVotes.length) * 100;

  _percent1() {
    if (totalVotes.length != 0) {
      if (listVotes.length / totalVotes.length * 1.0 == double.nan) {
      } else {
        return listVotes.length / totalVotes.length * 1.0;
      }
    } else {
      return 0.0;
    }
  }

  _percent2() {
    if (totalVotes.length != 0) {
      return listVotes2.length / totalVotes.length * 1.0;
    } else {
      return 0.0;
    }
  }

  _percent3() {
    if (totalVotes.length != 0) {
      return listVotes3.length / totalVotes.length * 1.0;
    } else {
      return 0.0;
    }
  }

  _percent4() {
    if (totalVotes.length != 0) {
      return listVotes4.length / totalVotes.length * 1.0;
    } else {
      return 0.0;
    }
  }

  checkPollStatus(int time) {
    if (DateTime.now().millisecondsSinceEpoch >= time) {
      setState(() {
        _isVoted = true;
      });
      return Text(
        'Expired',
        style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textBody1(context)),
      );
    } else {
      return Text(
        'Ends ${convertDate(time)}',
        style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textBody1(context)),
      );
    }
  }

  checkPollTimeStatus(int time) {
    if (DateTime.now().millisecondsSinceEpoch >= time) {
      if (!mounted) return;
      setState(() {
        _isVoted = true;
      });
    }
  }

  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.MMMd().add_jm().format(date);
    return formattedDate;
  }

  Widget _buildLayout({
    Key key,
    Color backgroundColor,
    Color containerColor,
  }) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      key: key,
      margin: const EdgeInsets.fromLTRB(
        12.0,
        0.0,
        12.0,
        8.0,
      ),
      decoration: ShapeDecoration(

          // borderRadius: BorderRadius.circular(12.0),
          color: backgroundColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black54, width: 0.1),
              borderRadius: BorderRadius.circular(12.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //     Divider(),
          Padding(
            padding: EdgeInsets.only(
              top: screenSize.height * 0.01,
              left: screenSize.width * 0.025,
              right: screenSize.width * 0.025,
            ),
            child: Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0))),
              padding: EdgeInsets.only(
                  bottom: screenSize.height * 0.01,
                  top: screenSize.height * 0.01,
                  left: screenSize.width / 30),
              child: Text(
                widget.documentSnapshot.data()['caption'],
                style: TextStyle(
                    //   color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textAppTitle(context)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenSize.width / 30,
              0,
              screenSize.width / 30,
              screenSize.height * 0.01,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    //     SizedBox(height: screenSize.height * 0.01),
                    InkWell(
                      onTap: () {
                        if (!_isVoted && !_selected1) {
                          setState(() {
                            _isVoted = true;
                          });
                          postVote(widget.documentSnapshot.reference);
                          addVoteToSelectedOption(
                              widget.documentSnapshot.reference,
                              widget.currentuser,
                              'option1');
                          buildPollDetail();
                        }
                      },
                      child: Container(
                          height: screenSize.height * 0.05,
                          width: screenSize.width / 1.2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepPurple[50]),
                            color: _selected1 ? containerColor : Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: !_isVoted
                              ? Center(
                                  child: Text(
                                  widget.documentSnapshot.data()['option1'],
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ))
                              : Container(
                                  margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                  width: double.infinity,
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.deepPurple[50],
                                    animation: true,
                                    lineHeight: 38.0,
                                    animationDuration: 500,
                                    percent: _percent1(),
                                    center: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.documentSnapshot['option1'],
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textBody1(context)),
                                        ),
                                        option1Widget()
                                      ],
                                    ),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: _selected1
                                        ? Colors.deepPurple[300]
                                        : Colors.deepPurple[100],
                                  ),
                                )),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.01),
                    InkWell(
                      onTap: () {
                        if (!_isVoted && !_selected2) {
                          setState(() {
                            _isVoted = true;
                          });

                          postVote(widget.documentSnapshot.reference);
                          addVoteToSelectedOption(
                              widget.documentSnapshot.reference,
                              widget.currentuser,
                              'option2');
                          buildPollDetail();
                        }
                      },
                      child: Container(
                        height: screenSize.height * 0.05,
                        width: screenSize.width / 1.2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple[50]),
                          color: _selected2 ? containerColor : Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: !_isVoted
                            ? Center(
                                child: Text(
                                widget.documentSnapshot.data()['option2'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textBody1(context)),
                              ))
                            : Container(
                                margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                width: double.infinity,
                                child: LinearPercentIndicator(
                                  backgroundColor: Colors.deepPurple[50],
                                  animation: true,
                                  lineHeight: 38.0,
                                  animationDuration: 500,
                                  percent: _percent2(),
                                  center: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.documentSnapshot
                                            .data()['option2'],
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: textBody1(context)),
                                      ),
                                      option2Widget()
                                    ],
                                  ),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: _selected2
                                      ? Colors.deepPurple[300]
                                      : Colors.deepPurple[100],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.01),
                    InkWell(
                      onTap: () {
                        if (!_isVoted && !_selected3) {
                          setState(() {
                            _isVoted = true;
                          });

                          postVote(widget.documentSnapshot.reference);
                          addVoteToSelectedOption(
                              widget.documentSnapshot.reference,
                              widget.currentuser,
                              'option3');
                          buildPollDetail();
                        }
                      },
                      child: Container(
                        height: screenSize.height * 0.05,
                        width: screenSize.width / 1.2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple[50]),
                          color: _selected3 ? containerColor : Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: !_isVoted
                            ? Center(
                                child: Text(
                                widget.documentSnapshot.data()['option3'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textBody1(context)),
                              ))
                            : Container(
                                margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                width: double.infinity,
                                child: LinearPercentIndicator(
                                  backgroundColor: Colors.deepPurple[50],
                                  animation: true,
                                  lineHeight: 38.0,
                                  animationDuration: 500,
                                  percent: _percent3(),
                                  center: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.documentSnapshot
                                            .data()['option3'],
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: textBody1(context)),
                                      ),
                                      option3Widget()
                                    ],
                                  ),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: _selected3
                                      ? Colors.deepPurple[300]
                                      : Colors.deepPurple[100],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.01),
                    InkWell(
                      onTap: () {
                        if (!_isVoted && !_selected4) {
                          setState(() {
                            _isVoted = true;
                          });

                          postVote(widget.documentSnapshot.reference);
                          addVoteToSelectedOption(
                              widget.documentSnapshot.reference,
                              widget.currentuser,
                              'option4');
                          buildPollDetail();
                        }
                      },
                      child: Container(
                        height: screenSize.height * 0.05,
                        width: screenSize.width / 1.2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple[50]),
                          color: _selected4 ? containerColor : Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: !_isVoted
                            ? Center(
                                child: Text(
                                widget.documentSnapshot.data()['option4'],
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context)),
                              ))
                            : Container(
                                margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                width: double.infinity,
                                child: LinearPercentIndicator(
                                  backgroundColor: Colors.deepPurple[50],
                                  animation: true,
                                  lineHeight: 38.0,
                                  animationDuration: 500,
                                  percent: _percent4(),
                                  center: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.documentSnapshot
                                            .data()['option4'],
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: textBody1(context)),
                                      ),
                                      option4Widget()
                                    ],
                                  ),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: _selected4
                                      ? Colors.deepPurple[300]
                                      : Colors.deepPurple[100],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.01,
                      horizontal: screenSize.width / 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      checkPollStatus(
                        widget.documentSnapshot.data()['pollLength'],
                      ),
                      Text(
                        '${totalVotes.length} Total votes',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          //  Divider(),
        ],
      ),
    );
  }

  Widget _buildFront() {
    return _buildLayout(
        key: ValueKey(_isVoted),
        backgroundColor: Colors.white,
        containerColor: Colors.deepPurple[200]);
  }

  Widget _buildRear() {
    return _buildLayout(
        key: ValueKey(_isVoted),
        backgroundColor: Colors.white,
        containerColor: Colors.white);
  }

  Widget _buildFlipAnimation() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 600),
      transitionBuilder: __transitionBuilder,
      layoutBuilder: (widget, list) => Stack(
        children: [widget, ...list],
      ),
      child: _isVoted ? _buildFront() : _buildRear(),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_isVoted) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build list');
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            // side: BorderSide(color: Colors.grey[300]),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  radius: screenSize.height * 0.03,
                  backgroundImage: CachedNetworkImageProvider(
                      widget.documentSnapshot.data()['postOwnerPhotoUrl'])),
              title: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendProfileScreen(
                              uid: widget.documentSnapshot.data()['ownerUid'],
                              name: widget.documentSnapshot
                                  .data()['postOwnerName'])));
                },
                child: new Text(
                  widget.documentSnapshot.data()['postOwnerName'],
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(
                  //   left: screenSize.width / 30,
                  top: screenSize.height * 0.002,
                ),
                child: Text(
                    widget.documentSnapshot.data()['time'] != null
                        ? timeago.format(
                            widget.documentSnapshot.data()['time'].toDate())
                        : '',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        //   fontSize: textbody2(context),
                        color: Colors.grey)),
              ),
              trailing: widget.currentuser.uid ==
                          widget.documentSnapshot.data()['ownerUid'] ||
                      widget.group != null &&
                          widget.group.currentUserUid == widget.currentuser.uid
                  ? InkWell(
                      onTap: () {
                        //    showDelete(widget.documentSnapshot);
                        showDelete(widget.documentSnapshot);
                      },
                      child: Container(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(
                                //          borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54)),
                            //color: Theme.of(context).accentColor,
                          ),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.005,
                                horizontal: screenSize.width * 0.02,
                              ),
                              child: Icon(Icons.more_horiz_outlined))),
                    )
                  : InkWell(
                      onTap: () {
                        showReport(widget.documentSnapshot);
                      },
                      child: Container(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(
                                //          borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54)),
                            //color: Theme.of(context).accentColor,
                          ),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.005,
                                horizontal: screenSize.width * 0.02,
                              ),
                              child: Icon(Icons.more_horiz_outlined))),
                    ),
            ),
            widget.documentSnapshot.data()['postType'] == 'poll'
                ? Container(
                    // constraints: BoxConstraints.tight(Size.square(screenSize.height)),
                    child: _buildFlipAnimation())
                : widget.documentSnapshot.data()['imgUrl'] == null ||
                        widget.documentSnapshot.data()['imgUrl'] == ''
                    ? Container()
                    : Center(
                        child: FadeInImage.assetNetwork(
                          fadeInDuration: const Duration(milliseconds: 300),
                          placeholder: 'assets/images/placeholder.png',
                          placeholderScale: 10,
                          image: widget.documentSnapshot['imgUrl'],
                        ),
                      ),
            widget.documentSnapshot.data()['location'] != '' &&
                    widget.documentSnapshot.data()['location'] != null
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        new Text(
                          widget.documentSnapshot.data()['location'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              //    fontSize: textBody1(context),
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Container(),
            widget.documentSnapshot.data()['postType'] == 'poll'
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.01,
                    ),
                    child: Container(
                      // decoration: ShapeDecoration(
                      //     color: Colors.grey[50],
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(40.0))),
                      padding: EdgeInsets.only(
                          bottom: screenSize.height * 0.01,
                          top: screenSize.height * 0.01,
                          left: screenSize.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          seeMore
                              ? Linkify(
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      throw 'Could not launch $link';
                                    }
                                  },
                                  text:
                                      widget.documentSnapshot.data()['caption'],
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    // fontWeight: FontWeight.bold
                                  ),
                                )
                              : Linkify(
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      throw 'Could not launch $link';
                                    }
                                  },
                                  text:
                                      widget.documentSnapshot.data()['caption'],
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                          widget.documentSnapshot
                                      .data()['caption']
                                      .toString()
                                      .length >
                                  250
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      seeMore = !seeMore;
                                    });
                                  },
                                  child: Text(
                                    !seeMore ? 'Read more...' : 'See less',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      //  fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ))
                              : Container()
                        ],
                      ),
                    ),
                  ),

            ListTile(
              leading: GestureDetector(
                  child: _isLiked
                      ? Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60.0),
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54)),
                            //color: Theme.of(context).accentColor,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 6.0,
                                bottom: 6.0,
                              ),
                              child: Icon(Icons.thumb_up_alt)))
                      : Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60.0),
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54)),
                            //color: Theme.of(context).accentColor,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 6.0,
                                bottom: 6.0,
                              ),
                              child: Icon(Icons.thumb_up_alt_outlined))),
                  onTap: () {
                    if (!_isLiked) {
                      setState(() {
                        _isLiked = true;
                      });

                      postLike(widget.documentSnapshot.reference);
                      addLikeToActivityFeed(
                          widget.documentSnapshot, widget.currentuser);
                    } else {
                      setState(() {
                        _isLiked = false;
                      });

                      postUnlike(widget.documentSnapshot.reference);
                      removeLikeFromActivityFeed(
                          widget.documentSnapshot, widget.currentuser);
                    }
                  }),
              title: FutureBuilder(
                future: _repository
                    .fetchPostLikes(widget.documentSnapshot.reference),
                builder: ((context,
                    AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                  if (likesSnapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LikesScreen(
                                      user: widget.currentuser,
                                      documentReference:
                                          widget.documentSnapshot.reference,
                                    ))));
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: likesSnapshot.data.length > 0
                              ? SizedBox(
                                  height: screenSize.height * 0.06,
                                  width: screenSize.width * 0.2,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: Colors.black,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                likesSnapshot.data[0]
                                                    ['ownerPhotoUrl']),
                                      ),
                                      likesSnapshot.data.length > 1
                                          ? Positioned(
                                              left: 15.0,
                                              child: CircleAvatar(
                                                radius: 15.0,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        likesSnapshot.data[1]
                                                            ['ownerPhotoUrl']),
                                              ),
                                            )
                                          : Container(),
                                      likesSnapshot.data.length > 2
                                          ? Positioned(
                                              left: 30.0,
                                              child: CircleAvatar(
                                                radius: 15.0,
                                                backgroundColor: Colors.grey,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        likesSnapshot.data[2]
                                                            ['ownerPhotoUrl']),
                                              ),
                                            )
                                          : Container(),
                                      likesSnapshot.data.length > 3
                                          ? Positioned(
                                              left: 30.0,
                                              child: CircleAvatar(
                                                radius: 15.0,
                                                backgroundColor: Colors.grey,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        likesSnapshot.data[3]
                                                            ['ownerPhotoUrl']),
                                              ),
                                            )
                                          : Container(),
                                      likesSnapshot.data.length > 4
                                          ? Positioned(
                                              left: 30.0,
                                              child: CircleAvatar(
                                                radius: 15.0,
                                                backgroundColor: Colors.grey,
                                                child: Text(
                                                    '${likesSnapshot.data.length}'),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )

                              //  Text(
                              //     "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                              //     style: TextStyle(
                              //         fontFamily: FontNameDefault,
                              //         fontSize: textBody1(context),
                              //         fontWeight: FontWeight.bold),
                              //   )
                              : Text(
                                  "0 ",
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context)),
                                ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Container());
                  }
                }),
              ),
              trailing: SizedBox(
                height: 40,
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CommentsScreenGroup(
                                  group: widget.group,
                                  snapshot: widget.documentSnapshot,
                                  followingUser: widget.currentuser,
                                  documentReference:
                                      widget.documentSnapshot.reference,
                                  user: widget.currentuser,
                                ))));
                  },
                  child: Container(
                    // decoration: ShapeDecoration(
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(60.0),
                    //       side: BorderSide(width: 0.1, color: Colors.black54)),
                    //   //color: Theme.of(context).accentColor,
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        commentWidget(widget.documentSnapshot.reference),
                        SizedBox(
                          width: 8.0,
                        ),
                        Icon(Icons.messenger_outline_sharp),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding:
            //       EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           GestureDetector(
            //               child: _isLiked
            //                   ? Container(
            //                       decoration: ShapeDecoration(
            //                         shape: RoundedRectangleBorder(
            //                             borderRadius:
            //                                 BorderRadius.circular(60.0),
            //                             side: BorderSide(
            //                                 width: 0.1, color: Colors.black54)),
            //                         //color: Theme.of(context).accentColor,
            //                       ),
            //                       child: Padding(
            //                           padding: const EdgeInsets.only(
            //                             left: 8.0,
            //                             right: 8.0,
            //                             top: 6.0,
            //                             bottom: 6.0,
            //                           ),
            //                           child: Icon(Icons.thumb_up_alt)))
            //                   : Container(
            //                       decoration: ShapeDecoration(
            //                         shape: RoundedRectangleBorder(
            //                             borderRadius:
            //                                 BorderRadius.circular(60.0),
            //                             side: BorderSide(
            //                                 width: 0.1, color: Colors.black54)),
            //                         //color: Theme.of(context).accentColor,
            //                       ),
            //                       child: Padding(
            //                           padding: const EdgeInsets.only(
            //                             left: 8.0,
            //                             right: 8.0,
            //                             top: 6.0,
            //                             bottom: 6.0,
            //                           ),
            //                           child:
            //                               Icon(Icons.thumb_up_alt_outlined))),
            //               onTap: () {
            //                 if (!_isLiked) {
            //                   setState(() {
            //                     _isLiked = true;
            //                   });

            //                   postLike(widget.documentSnapshot.reference);
            //                   addLikeToActivityFeed(
            //                       widget.documentSnapshot, widget.currentuser);
            //                 } else {
            //                   setState(() {
            //                     _isLiked = false;
            //                   });

            //                   postUnlike(widget.documentSnapshot.reference);
            //                   removeLikeFromActivityFeed(
            //                       widget.documentSnapshot, widget.currentuser);
            //                 }
            //               }),
            //           FutureBuilder(
            //             future: _repository
            //                 .fetchPostLikes(widget.documentSnapshot.reference),
            //             builder: ((context,
            //                 AsyncSnapshot<List<DocumentSnapshot>>
            //                     likesSnapshot) {
            //               if (likesSnapshot.hasData) {
            //                 return GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: ((context) => LikesScreen(
            //                                   user: widget.currentuser,
            //                                   documentReference: widget
            //                                       .documentSnapshot.reference,
            //                                 ))));
            //                   },
            //                   child: Container(
            //                     child: Padding(
            //                       padding: EdgeInsets.all(8.0),
            //                       child: likesSnapshot.data.length > 0
            //                           ? SizedBox(
            //                               height: screenSize.height * 0.06,
            //                               width: screenSize.width * 0.2,
            //                               child: Stack(
            //                                 children: [
            //                                   CircleAvatar(
            //                                     radius: 15.0,
            //                                     backgroundColor: Colors.black,
            //                                     backgroundImage:
            //                                         CachedNetworkImageProvider(
            //                                             likesSnapshot
            //                                                     .data[0].data[
            //                                                 'ownerPhotoUrl']),
            //                                   ),
            //                                   likesSnapshot.data.length > 1
            //                                       ? Positioned(
            //                                           left: 15.0,
            //                                           child: CircleAvatar(
            //                                             radius: 15.0,
            //                                             backgroundImage:
            //                                                 CachedNetworkImageProvider(
            //                                                     likesSnapshot
            //                                                             .data[1]
            //                                                             .data[
            //                                                         'ownerPhotoUrl']),
            //                                           ),
            //                                         )
            //                                       : Container(),
            //                                   likesSnapshot.data.length > 2
            //                                       ? Positioned(
            //                                           left: 30.0,
            //                                           child: CircleAvatar(
            //                                             radius: 15.0,
            //                                             backgroundColor:
            //                                                 Colors.grey,
            //                                             backgroundImage:
            //                                                 CachedNetworkImageProvider(
            //                                                     likesSnapshot
            //                                                             .data[2]
            //                                                             .data[
            //                                                         'ownerPhotoUrl']),
            //                                           ),
            //                                         )
            //                                       : Container(),
            //                                   likesSnapshot.data.length > 3
            //                                       ? Positioned(
            //                                           left: 30.0,
            //                                           child: CircleAvatar(
            //                                             radius: 15.0,
            //                                             backgroundColor:
            //                                                 Colors.grey,
            //                                             backgroundImage:
            //                                                 CachedNetworkImageProvider(
            //                                                     likesSnapshot
            //                                                             .data[3]
            //                                                             .data[
            //                                                         'ownerPhotoUrl']),
            //                                           ),
            //                                         )
            //                                       : Container(),
            //                                   likesSnapshot.data.length > 4
            //                                       ? Positioned(
            //                                           left: 30.0,
            //                                           child: CircleAvatar(
            //                                             radius: 15.0,
            //                                             backgroundColor:
            //                                                 Colors.grey,
            //                                             child: Text(
            //                                                 '${likesSnapshot.data.length}'),
            //                                           ),
            //                                         )
            //                                       : Container(),
            //                                 ],
            //                               ),
            //                             )

            //                           //  Text(
            //                           //     "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
            //                           //     style: TextStyle(
            //                           //         fontFamily: FontNameDefault,
            //                           //         fontSize: textBody1(context),
            //                           //         fontWeight: FontWeight.bold),
            //                           //   )
            //                           : Text(
            //                               "0 ",
            //                               style: TextStyle(
            //                                   fontFamily: FontNameDefault,
            //                                   fontSize: textBody1(context)),
            //                             ),
            //                     ),
            //                   ),
            //                 );
            //               } else {
            //                 return Center(child: Container());
            //               }
            //             }),
            //           ),
            //         ],
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: ((context) => CommentsScreen(
            //                         group: widget.group,
            //                         isGroupFeed: true,
            //                         snapshot: widget.documentSnapshot,
            //                         followingUser: widget.currentuser,
            //                         documentReference:
            //                             widget.documentSnapshot.reference,
            //                         user: widget.currentuser,
            //                       ))));
            //         },
            //         child: Container(
            //             decoration: ShapeDecoration(
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(60.0),
            //                   side: BorderSide(
            //                       width: 0.1, color: Colors.black54)),
            //               //color: Theme.of(context).accentColor,
            //             ),
            //             child: Padding(
            //                 padding: const EdgeInsets.only(
            //                   left: 8.0,
            //                   right: 8.0,
            //                   top: 6.0,
            //                   bottom: 6.0,
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     commentWidget(
            //                         widget.documentSnapshot.reference),
            //                     SizedBox(
            //                       width: 4.0,
            //                     ),
            //                     Icon(Icons.messenger_outline_sharp),
            //                   ],
            //                 ))),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: screenSize.height * 0.005,
            ),
            // Padding(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: screenSize.width / 30,
            //       vertical: screenSize.height * 0.005,
            //     ),
            //     child: commentWidget(widget.documentSnapshot.reference)),
          ],
        ),
      ),
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .doc(widget.currentuser.uid)
        .set(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postVote(DocumentReference reference) {
    var _vote = Vote(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection('votes')
        .doc(widget.currentuser.uid)
        .set(_vote.toMap(_vote))
        .then((value) {
      print("Post Voted");
    });
  }

  void addVoteToSelectedOption(
      DocumentReference reference, UserModel currentUser, String option) {
    var _vote = Vote(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection(option)
        .doc(widget.currentuser.uid)
        .set(_vote.toMap(_vote))
        .then((value) {
      print("Option Voted");
    });
  }

  showDelete(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Delete',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  deleteDialog(snapshot);
                  //   Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  deleteDialog(DocumentSnapshot snapshot) {
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
                            'Delete Post',
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
                          'Are you sure you want to delete this post?',
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
                              Navigator.pop(context);
                              deletePost(snapshot);
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

  showReport(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Report this post',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  _showFormDialog(context);
                  //   Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _showFormDialog(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: ((BuildContext context, setState) {
            return AlertDialog(
              content: Form(
                child: Wrap(
                  //    mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text(
                          'Spam',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Spam',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Pornographic',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Pornographic',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Misleading',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Misleading',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Hacked',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Hacked',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Offensive',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Offensive',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: Text('Comment'),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: TextFormField(
                    //     controller: _bodyController,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: screenSize.width / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              send()
                                  .then((value) => Navigator.pop(context))
                                  .then((value) => Navigator.pop(context));
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        }));
  }

  deletePost(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.gid)
        .collection('posts')
        // .document()
        // .delete();
        .doc(snapshot['postId'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        // Navigator.pop(context);

        print('post deleted');
      } else {
        return print('not owner');
      }
    });
  }

  void addLikeToActivityFeed(
      DocumentSnapshot<Map<String, dynamic>> snapshot, UserModel currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (widget.currentuser.uid == snapshot.data()['ownerUid']) {
      return print('Owner liked');
    } else {
      var _feed = Feed(
        gid: widget.gid,
        postOwnerUid: snapshot.data()['ownerUid'],
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: 'like',
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: snapshot.data()['imgUrl'],
        postId: snapshot.data()['postId'],
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.gid)
          .collection('inbox')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(snapshot.data()['postId'])
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Group Feed added');
      });
    }
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .doc(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }

  void removeLikeFromActivityFeed(
      DocumentSnapshot<Map<String, dynamic>> snapshot, UserModel currentUser) {
    //  bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (currentUser.uid == snapshot.data()['ownerUid']) {
      return print('Owner feed');
    } else {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.gid)
          .collection('inbox')
          //.where('postId',isEqualTo:snapshot['postId'])
          // .document(currentuser.uid)
          // .collection('likes')
          .doc(snapshot.data()['postId'])
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }
}

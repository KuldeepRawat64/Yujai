import 'dart:async';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/like.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/team_feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/vote.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/discussion_comment.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/pages/likes_screen.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class ListItemDiscussions extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User currentuser;
  final int index;
  final String gid;
  final String name;
  final Team group;
  ListItemDiscussions({
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.group,
  });

  @override
  _ListItemDiscussionsState createState() => _ListItemDiscussionsState();
}

class _ListItemDiscussionsState extends State<ListItemDiscussions> {
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
  List<DocumentSnapshot> listVotes = [];
  List<DocumentSnapshot> listVotes2 = [];
  List<DocumentSnapshot> listVotes3 = [];
  List<DocumentSnapshot> listVotes4 = [];
  List<DocumentSnapshot> listVotes5 = [];
  List<DocumentSnapshot> listVotes6 = [];
  List<DocumentSnapshot> totalVotes = [];
  String actId = Uuid().v4();

  Widget commentWidget(DocumentReference reference) {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} comments',
              style: TextStyle(
                  fontSize: screenSize.height * 0.017, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => DiscussionComments(
                            gid: widget.gid,
                            snapshot: widget.documentSnapshot,
                            followingUser: widget.currentuser,
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text +
          '\n Owner ID : ${widget.documentSnapshot.data['ownerUid']}' +
          '\ Post ID : n${widget.documentSnapshot.data['postId']}' +
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
        .checkIfUserVotedOrNot(widget.currentuser.uid,
            widget.documentSnapshot.reference, 'option5')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _selected5 = value;
      });
    });
    _repository
        .checkIfUserVotedOrNot(widget.currentuser.uid,
            widget.documentSnapshot.reference, 'option6')
        .then((value) {
      print("VALUE : $value");
      if (!mounted) return;
      setState(() {
        _selected6 = value;
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
        .fetchPerVotes(widget.documentSnapshot.reference, 'option5')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          listVotes5 = value;
        });
      }
    });
    _repository
        .fetchPerVotes(widget.documentSnapshot.reference, 'option6')
        .then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          listVotes6 = value;
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
  }

  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
    buildPollDetail();
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
                        color: Theme.of(context).primaryColor,
                        fontFamily: FontNameDefault,
                        fontWeight: FontWeight.bold,
                        fontSize: textBody1(context)),
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
      child: Text(
          _getPercentage() == double.nan
              ? ''
              : '${_getPercentage()}'
                  .replaceAll('.0', ' %  ')
                  .replaceAll('NaN', ' %  ')
                  .replaceAll('Infinity', ' %  '),
          style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.bold,
              fontSize: textBody1(context),
              color: Colors.black54)),
    );
  }

  Widget option2Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Text(
          _getPercentage2() == double.nan
              ? ''
              : '${_getPercentage2()}'
                  .replaceAll('.0', ' %  ')
                  .replaceAll('NaN', ' %  ')
                  .replaceAll('Infinity', ' %  '),
          style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.bold,
              fontSize: textBody1(context),
              color: Colors.black54)),
    );
  }

  Widget option3Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Text(
          _getPercentage3() == double.nan
              ? ''
              : '${_getPercentage3()}'
                  .replaceAll('.0', ' %  ')
                  .replaceAll('NaN', ' %  ')
                  .replaceAll('Infinity', ' %  '),
          style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.bold,
              fontSize: textBody1(context),
              color: Colors.black54)),
    );
  }

  Widget option4Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Text(
          _getPercentage4() == double.nan
              ? ''
              : '${_getPercentage4()}'
                  .replaceAll('.0', ' %  ')
                  .replaceAll('NaN', ' %  ')
                  .replaceAll('Infinity', ' %  '),
          style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.bold,
              fontSize: textBody1(context),
              color: Colors.black54)),
    );
  }

  Widget option5Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Text(
          _getPercentage5() == double.nan
              ? ''
              : '${_getPercentage5()}'
                  .replaceAll('.0', ' %  ')
                  .replaceAll('NaN', ' %  ')
                  .replaceAll('Infinity', ' %  '),
          style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.bold,
              fontSize: textBody1(context),
              color: Colors.black54)),
    );
  }

  Widget option6Widget() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Text(
          _getPercentage6() == double.nan
              ? ''
              : '${_getPercentage6()}'
                  .replaceAll('.0', ' %  ')
                  .replaceAll('NaN', ' %  ')
                  .replaceAll('Infinity', ' %  '),
          style: TextStyle(
              fontFamily: FontNameDefault,
              fontWeight: FontWeight.bold,
              fontSize: textBody1(context),
              color: Colors.black54)),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenSize.height * 0.02,
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
  _getPercentage5() => (listVotes5.length / totalVotes.length) * 100;
  _getPercentage6() => (listVotes6.length / totalVotes.length) * 100;

  @override
  Widget build(BuildContext context) {
    print('build list');
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: Container(
        decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
                //  side: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(12.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenSize.width / 30,
                screenSize.height * 0.012,
                screenSize.width / 50,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new CircleAvatar(
                          radius: screenSize.height * 0.02,
                          backgroundImage: CachedNetworkImageProvider(widget
                              .documentSnapshot.data['postOwnerPhotoUrl'])),
                      new SizedBox(
                        width: screenSize.width / 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FriendProfileScreen(
                                          uid: widget.documentSnapshot
                                              .data['ownerUid'],
                                          name: widget.documentSnapshot
                                              .data['postOwnerName'])));
                            },
                            child: new Text(
                              widget.documentSnapshot.data['postOwnerName'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          widget.documentSnapshot.data['location'] != null
                              ? new Text(
                                  widget.documentSnapshot.data['location'],
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                      color: Colors.grey),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                  widget.currentuser.uid ==
                              widget.documentSnapshot.data['ownerUid'] ||
                          widget.group.currentUserUid == widget.currentuser.uid
                      ? InkWell(
                          onTap: () {
                            showDelete(widget.documentSnapshot);
                          },
                          child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                    side: BorderSide(
                                        width: 1.5, color: Colors.deepPurple)),
                                //color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 6.0,
                                  bottom: 6.0,
                                ),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textButton(context),
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        )
                      : InkWell(
                          onTap: () {
                            showReport(widget.documentSnapshot);
                          },
                          child: Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                    side: BorderSide(
                                        width: 1.5, color: Colors.deepPurple)),
                                //color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 6.0,
                                  bottom: 6.0,
                                ),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textButton(context),
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        )
                ],
              ),
            ),
            widget.documentSnapshot.data['postType'] == 'poll'
                ? _isVoted == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.height * 0.005,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              showCategory(widget.documentSnapshot, context),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  backgroundColor: Colors.blue[50],
                                  label: Text(
                                    widget.documentSnapshot.data['pollType'],
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenSize.height * 0.01,
                            ),
                            child: Container(
                              decoration: ShapeDecoration(
                                  color: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0))),
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.01,
                                  top: screenSize.height * 0.01,
                                  left: screenSize.width / 30),
                              child: Text(
                                widget.documentSnapshot.data['caption'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              screenSize.width / 30,
                              screenSize.height * 0.01,
                              screenSize.width / 30,
                              screenSize.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                widget.documentSnapshot.data['option1'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVoted = true;
                                              });

                                              postVote(widget
                                                  .documentSnapshot.reference);
                                              addVoteToSelectedOption(
                                                  widget.documentSnapshot
                                                      .reference,
                                                  widget.currentuser,
                                                  'option1');
                                              buildPollDetail();
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option1'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option2'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVoted = true;
                                              });

                                              postVote(widget
                                                  .documentSnapshot.reference);
                                              addVoteToSelectedOption(
                                                  widget.documentSnapshot
                                                      .reference,
                                                  widget.currentuser,
                                                  'option2');
                                              buildPollDetail();
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option2'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option3'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVoted = true;
                                              });

                                              postVote(widget
                                                  .documentSnapshot.reference);
                                              addVoteToSelectedOption(
                                                  widget.documentSnapshot
                                                      .reference,
                                                  widget.currentuser,
                                                  'option3');
                                              buildPollDetail();
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option3'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option4'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVoted = true;
                                              });

                                              postVote(widget
                                                  .documentSnapshot.reference);
                                              addVoteToSelectedOption(
                                                  widget.documentSnapshot
                                                      .reference,
                                                  widget.currentuser,
                                                  'option4');
                                              buildPollDetail();
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option4'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option5'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVoted = true;
                                              });

                                              postVote(widget
                                                  .documentSnapshot.reference);
                                              addVoteToSelectedOption(
                                                  widget.documentSnapshot
                                                      .reference,
                                                  widget.currentuser,
                                                  'option5');
                                              buildPollDetail();
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option5'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option6'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVoted = true;
                                              });

                                              postVote(widget
                                                  .documentSnapshot.reference);
                                              addVoteToSelectedOption(
                                                  widget.documentSnapshot
                                                      .reference,
                                                  widget.currentuser,
                                                  'option6');
                                              buildPollDetail();
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option6'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.height * 0.005,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              showCategory(widget.documentSnapshot, context),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  backgroundColor: Colors.blue[50],
                                  label: Text(
                                    widget.documentSnapshot.data['pollType'],
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenSize.height * 0.01,
                            ),
                            child: Container(
                              decoration: ShapeDecoration(
                                  color: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0))),
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.01,
                                  top: screenSize.height * 0.01,
                                  left: screenSize.width / 30),
                              child: Text(
                                widget.documentSnapshot.data['caption'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              screenSize.width / 30,
                              screenSize.height * 0.01,
                              screenSize.width / 30,
                              screenSize.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                widget.documentSnapshot.data['option1'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {
                                              // setState(() {
                                              //   _isVoted = false;
                                              // });
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: _selected1 == false
                                                    ? Colors.white
                                                    : Colors.deepPurple[200],
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              screenSize.width /
                                                                  30),
                                                      child: Text(
                                                        widget.documentSnapshot
                                                            .data['option1'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontNameDefault,
                                                            fontSize: textBody1(
                                                                context),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  option1Widget()
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option2'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: _selected2 == false
                                                  ? Colors.white
                                                  : Colors.deepPurple[200],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: screenSize.width /
                                                          30),
                                                  child: Text(
                                                    widget.documentSnapshot
                                                        .data['option2'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontSize:
                                                            textBody1(context),
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                option2Widget()
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option3'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: _selected3 == false
                                                  ? Colors.white
                                                  : Colors.deepPurple[200],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: screenSize.width /
                                                            30),
                                                    child: Text(
                                                      widget.documentSnapshot
                                                          .data['option3'],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: textBody1(
                                                              context),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                option3Widget()
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option4'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: _selected4 == false
                                                  ? Colors.white
                                                  : Colors.deepPurple[200],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: screenSize.width /
                                                            30),
                                                    child: Text(
                                                      widget.documentSnapshot
                                                          .data['option4'],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: textBody1(
                                                              context),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                option4Widget()
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option5'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: _selected5 == false
                                                  ? Colors.white
                                                  : Colors.deepPurple[200],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: screenSize.width /
                                                            30),
                                                    child: Text(
                                                      widget.documentSnapshot
                                                          .data['option5'],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: textBody1(
                                                              context),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                option5Widget()
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option6'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: _selected6 == false
                                                  ? Colors.white
                                                  : Colors.deepPurple[200],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: screenSize.width /
                                                            30),
                                                    child: Text(
                                                      widget.documentSnapshot
                                                          .data['option6'],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: textBody1(
                                                              context),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                option6Widget()
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      )
                : widget.documentSnapshot.data['imgUrl'] != null
                    ? Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.01),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageDetail(
                                          image: widget
                                              .documentSnapshot.data['imgUrl'],
                                        )));
                          },
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.medium,
                            fadeInCurve: Curves.easeIn,
                            fadeOutCurve: Curves.easeOut,
                            imageUrl: widget.documentSnapshot.data['imgUrl'],
                            placeholder: ((context, s) => Center(
                                  child: CircularProgressIndicator(),
                                )),
                            width: screenSize.width,
                            height: screenSize.height * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(),
            widget.documentSnapshot.data['caption'] != '' &&
                    widget.documentSnapshot.data['postType'] != 'poll'
                ? widget.documentSnapshot.data['imgUrl'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenSize.height * 0.01,
                                left: screenSize.width / 30),
                            child: Text(
                              widget.documentSnapshot.data['caption'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context)),
                            ),
                          ),
                          // commentWidget(widget.documentSnapshot.reference)
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenSize.height * 0.01,
                            ),
                            child: Container(
                              decoration: ShapeDecoration(
                                  color: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0))),
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.01,
                                  top: screenSize.height * 0.01,
                                  left: screenSize.width / 30),
                              child: Text(
                                widget.documentSnapshot.data['caption'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                          ),
                        ],
                      )
                : Container(),
            Padding(
              padding: EdgeInsets.all(screenSize.height * 0.012),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          child: _isLiked
                              ? Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Colors.deepPurple)),
                                    //color: Theme.of(context).accentColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 6.0,
                                      bottom: 6.0,
                                    ),
                                    child: Text(
                                      'Liked',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textButton(context),
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              : Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Colors.deepPurple)),
                                    //color: Theme.of(context).accentColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 6.0,
                                      bottom: 6.0,
                                    ),
                                    child: Text(
                                      'Like',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textButton(context),
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
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
                      new SizedBox(
                        width: screenSize.width / 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        snapshot: widget.documentSnapshot,
                                        followingUser: widget.currentuser,
                                        documentReference:
                                            widget.documentSnapshot.reference,
                                        user: widget.currentuser,
                                      ))));
                        },
                        child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.deepPurple)),
                              //color: Theme.of(context).accentColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 6.0,
                                bottom: 6.0,
                              ),
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textButton(context),
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future:
                  _repository.fetchPostLikes(widget.documentSnapshot.reference),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width / 30),
                      child: likesSnapshot.data.length > 1
                          ? Text(
                              "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              likesSnapshot.data.length == 1
                                  ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
                                  : "0 Likes",
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context)),
                            ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 30,
                  vertical: screenSize.height * 0.005,
                ),
                child: commentWidget(widget.documentSnapshot.reference)),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                bottom: screenSize.height * 0.012,
              ),
              child: Text(
                  widget.documentSnapshot.data['time'] != null
                      ? timeago
                          .format(widget.documentSnapshot.data['time'].toDate())
                      : '',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textbody2(context),
                      color: Colors.grey)),
            ),
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
        .document(widget.currentuser.uid)
        .setData(_like.toMap(_like))
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
        .document(widget.currentuser.uid)
        .setData(_vote.toMap(_vote))
        .then((value) {
      print("Post Voted");
    });
  }

  void addVoteToSelectedOption(
      DocumentReference reference, User currentUser, String option) {
    var _vote = Vote(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection(option)
        .document(widget.currentuser.uid)
        .setData(_vote.toMap(_vote))
        .then((value) {
      print("Option Voted");
    });
  }

  showDelete(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Confirm delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  deletePost(snapshot);
                  //  Navigator.pop(context);
                  //   Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  showCategory(DocumentSnapshot snapshot, BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (snapshot.data['category'] == 'Entertainment') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.tv,
            color: Colors.green,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.green),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Social') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.group,
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.blue),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Science') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.spaceStation,
            color: Colors.orange,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.orange),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Politics') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.pollBox,
            color: Colors.brown,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.brown),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Technology') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.robot,
            color: Colors.pink,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.pink),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Other') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.more,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.grey),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Environment') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.tree,
            color: Colors.greenAccent,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.greenAccent),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Sports') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.tennisBall,
            color: Colors.purple,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.purple),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.more,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          label: Text(
            'Other',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.grey),
          ),
        ),
      );
    }
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
                      fontSize: textSubTitle(context),
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
                    //   child: Text('Comment',sty),
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
                                    fontSize: textBody1(context),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              send().then((value) => Navigator.pop(context));
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
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
    Firestore.instance
        .collection('groups')
        .document(widget.gid)
        .collection('posts')
        // .document()
        // .delete();
        .document(snapshot.data['postId'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        Navigator.pop(context);

        print('post deleted');
      } else {
        return print('not owner');
      }
    });
  }

  void addLikeToActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (widget.currentuser.uid == snapshot.data['ownerUid']) {
      return print('Owner liked');
    } else {
      var _feed = TeamFeed(
        assigned: [snapshot.data['ownerUid']],
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: 'like',
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: snapshot['imgUrl'],
        postId: snapshot.data['postId'],
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      Firestore.instance
          .collection('teams')
          .document(widget.gid)
          .collection('inbox')
          // .document(currentUser.uid)
          // .collection('likes')
          .document(snapshot.data['postId'])
          .setData(_feed.toMap(_feed))
          .then((value) {
        // actId = Uuid().v4();
        print('Feed added');
      });
    }
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }

  void removeLikeFromActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    //  bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (currentUser.uid == snapshot.data['ownerUid']) {
      return print('Owner feed');
    } else {
      Firestore.instance
          .collection('teams')
          .document(widget.gid)
          .collection('inbox')
          //.where('postId',isEqualTo:snapshot['postId'])
          // .document(currentuser.uid)
          // .collection('likes')
          .document(snapshot.data['postId'])
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }
}

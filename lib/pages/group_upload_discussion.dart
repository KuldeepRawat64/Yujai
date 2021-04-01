import 'dart:io';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/group.dart';

import '../style.dart';

class GroupUploadDiscussion extends StatefulWidget {
  final String gid;
  final String name;
  final Group group;

  const GroupUploadDiscussion({
    this.gid,
    this.name,
    this.group,
  });
  @override
  _GroupUploadDiscussionState createState() => _GroupUploadDiscussionState();
}

class _GroupUploadDiscussionState extends State<GroupUploadDiscussion> {
  var _locationController;
  var _captionController;
  final _repository = Repository();
  File imageFile;
  bool _text = false;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'New Discussion',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          actions: <Widget>[
            _visibility && _text
                ? Padding(
                    padding: EdgeInsets.only(
                      right: screenSize.width / 30,
                    ),
                    child: GestureDetector(
                      child: Icon(
                        Icons.send,
                        size: screenSize.height * 0.035,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        // To show the CircularProgressIndicator
                        _changeVisibility(false);

                        _repository.getCurrentUser().then((currentUser) {
                          if (currentUser != null &&
                                  currentUser.uid ==
                                      widget.group.currentUserUid ||
                              widget.group.isPrivate == false) {
                            _repository
                                .retreiveUserDetails(currentUser)
                                .then((user) {
                              _repository
                                  .addDiscussionToForum(
                                widget.gid,
                                user,
                                _captionController.text,
                              )
                                  .then((value) {
                                print("Discussion added to db");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => GroupPage(
                                              currentUser: user,
                                              isMember: false,
                                              gid: widget.gid,
                                              name: widget.name,
                                            ))));
                              }).catchError((e) => print(
                                      "Error adding current post to db : $e"));
                            });
                          } else {
                            _repository
                                .retreiveUserDetails(currentUser)
                                .then((user) {
                              _repository
                                  .addDiscussionToReview(widget.gid, user,
                                      _captionController.text, 'post')
                                  .then((value) {
                                print("Discussion added to review");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => GroupPage(
                                              currentUser: user,
                                              isMember: false,
                                              gid: widget.gid,
                                              name: widget.name,
                                            ))));
                              }).catchError((e) => print(
                                      "Error adding current post to db : $e"));
                            });
                          }
                        });
                      },
                    ),
                  )
                : Container()
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            screenSize.width / 30,
            screenSize.height * 0.05,
            screenSize.width / 30,
            screenSize.height * 0.012,
          ),
          children: <Widget>[
            !_visibility ? linearProgress() : Container(),
            Column(children: [
              Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title for discussion',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    //    color: const Color(0xffffffff),
                    width: screenSize.width,
                    child: TextField(
                      onChanged: (val) {
                        if (_captionController.text.length > 10) {
                          setState(() {
                            _text = true;
                          });
                        } else {
                          setState(() {
                            _text = false;
                          });
                        }
                      },
                      minLines: 4,
                      maxLines: 4,
                      // maxLength: 250,
                      keyboardType: TextInputType.multiline,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context)),
                      controller: _captionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        hintText: "Write a title...",
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Text(
                'Discussion should have atleast 50 characters.',
                style: TextStyle(
                    fontSize: textBody1(context),
                    fontFamily: FontNameDefault,
                    color: Colors.black54),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/group.dart';

import '../style.dart';

class GroupUploadPoll extends StatefulWidget {
  final String gid;
  final String name;
  final Group group;

  const GroupUploadPoll({this.gid, this.name, this.group});
  @override
  _GroupUploadPollState createState() => _GroupUploadPollState();
}

class PollType {
  int id;
  String name;
  PollType(this.id, this.name);
  static List<PollType> getPollType() {
    return <PollType>[
      PollType(1, 'Select Type'),
      PollType(2, 'Poll'),
      PollType(3, 'Prediction'),
      PollType(4, 'Survey'),
      PollType(5, 'Quiz'),
    ];
  }
}

class PollLength {
  int id;
  String name;
  PollLength(this.id, this.name);
  static List<PollLength> getPollLength() {
    return <PollLength>[
      PollLength(1, 'Select Category'),
      PollLength(2, 'Entertainment'),
      PollLength(3, 'Science'),
      PollLength(4, 'Technology'),
      PollLength(5, 'Politics'),
      PollLength(6, 'Social'),
      PollLength(7, 'Sports'),
      PollLength(8, 'Environment'),
      PollLength(9, 'Other'),
    ];
  }
}

class _GroupUploadPollState extends State<GroupUploadPoll> {
  List<PollType> _pollType = PollType.getPollType();
  List<DropdownMenuItem<PollType>> _dropDownMenuPollType;
  PollType _selectedPollType;
  List<PollLength> _pollLength = PollLength.getPollLength();
  List<DropdownMenuItem<PollLength>> _dropDownMenuPollLength;
  PollLength _selectedPollLength;
  bool option3, option4, option5, option6 = false;
  int counter = 0;
  TextEditingController _option1Controller = new TextEditingController();
  TextEditingController _option2Controller = new TextEditingController();
  TextEditingController _option3Controller = new TextEditingController();
  TextEditingController _option4Controller = new TextEditingController();
  TextEditingController _option5Controller = new TextEditingController();
  TextEditingController _option6Controller = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  bool loading = false;
  final _repository = Repository();

  List<DropdownMenuItem<PollType>> buildDropDownMenuPollType(List pollTypes) {
    List<DropdownMenuItem<PollType>> items = List();
    for (PollType pollType in pollTypes) {
      items.add(
        DropdownMenuItem(
          value: pollType,
          child: Text(pollType.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownPollType(PollType selectedPollType) {
    setState(() {
      _selectedPollType = selectedPollType;
    });
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  List<DropdownMenuItem<PollLength>> buildDropDownMenuPollLength(
      List pollLengths) {
    List<DropdownMenuItem<PollLength>> items = List();
    for (PollLength pollLength in pollLengths) {
      items.add(
        DropdownMenuItem(
          value: pollLength,
          child: Text(pollLength.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownPollLength(PollLength selectedPollLength) {
    setState(() {
      _selectedPollLength = selectedPollLength;
    });
  }

  func() {
    if (_titleController.text.length > 200) {
      setState(() {
        loading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dropDownMenuPollType = buildDropDownMenuPollType(_pollType);
    _selectedPollType = _dropDownMenuPollType[0].value;
    _dropDownMenuPollLength = buildDropDownMenuPollLength(_pollLength);
    _selectedPollLength = _dropDownMenuPollLength[0].value;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
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
          //   centerTitle: true,
          title: Text(
            'Create Poll',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          actions: <Widget>[
            _visibility &&
                    _titleController.text.isNotEmpty &&
                    _option1Controller.text.isNotEmpty &&
                    _option2Controller.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                      right: screenSize.width / 30,
                    ),
                    child: GestureDetector(
                      child: loading == true
                          ? circularProgress()
                          : Icon(
                              Icons.send,
                              size: screenSize.height * 0.035,
                              color: Theme.of(context).primaryColor,
                            ),
                      onTap: () {
                        //  To show the CircularProgressIndicator
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
                                  .addPollToForum(
                                widget.gid,
                                user,
                                _titleController.text,
                                _selectedPollLength.name,
                                _selectedPollType.name,
                                'poll',
                                _option1Controller.text,
                                _option2Controller.text,
                                _option3Controller.text,
                                _option4Controller.text,
                                _option5Controller.text,
                                _option6Controller.text,
                              )
                                  .then((value) {
                                print("Poll added to db");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => GroupPage(
                                              isMember: false,
                                              currentUser: user,
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
                                  .addPollToReview(
                                widget.gid,
                                user,
                                _titleController.text,
                                _selectedPollLength.name,
                                _selectedPollType.name,
                                'poll',
                                _option1Controller.text,
                                _option2Controller.text,
                                _option3Controller.text,
                                _option4Controller.text,
                                _option5Controller.text,
                                _option6Controller.text,
                              )
                                  .then((value) {
                                print("Poll added to review");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => GroupPage(
                                              isMember: false,
                                              currentUser: user,
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
              screenSize.height * 0.01,
              screenSize.width / 30,
              screenSize.height * 0.012,
            ),
            children: [
              !_visibility ? linearProgress() : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    onChanged: (val) {
                      if (_titleController.text.length > 200) {
                        setState(() {
                          loading = true;
                        });
                      } else if (_titleController.text.length <= 200) {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color:
                          loading == true ? Colors.redAccent : Colors.black87,
                    ),
                    minLines: 2,
                    maxLines: 2,
                    controller: _titleController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        hintText: 'Poll Title'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButton(
                              underline: Container(color: Colors.white),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black87,
                              ),
                              iconSize: screenSize.height * 0.05,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Theme.of(context).primaryColor),
                              value: _selectedPollType,
                              items: _dropDownMenuPollType,
                              onChanged: onChangeDropDownPollType),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButton(
                              underline: Container(color: Colors.white),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black87,
                              ),
                              iconSize: screenSize.height * 0.05,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Theme.of(context).primaryColor),
                              value: _selectedPollLength,
                              items: _dropDownMenuPollLength,
                              onChanged: onChangeDropDownPollLength),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  Row(
                    children: [
                      Container(
                        height: screenSize.height * 0.1,
                        width: screenSize.width / 1.8,
                        child: TextField(
                          controller: _option1Controller,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              hintText: 'Option 1'),
                          maxLength: 25,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                setState(() {
                                  counter = counter + 1;
                                  if (counter == 0) {
                                    setState(() {
                                      option3 = false;
                                      option4 = false;
                                      option5 = false;
                                      option6 = false;
                                    });
                                  } else if (counter == 1) {
                                    setState(() {
                                      option3 = true;
                                    });
                                  } else if (counter == 2) {
                                    setState(() {
                                      option4 = true;
                                    });
                                  } else if (counter == 3) {
                                    setState(() {
                                      option5 = true;
                                    });
                                  } else if (counter >= 4) {
                                    setState(() {
                                      option6 = true;
                                    });
                                  }
                                });
                              }),
                          counter >= 1
                              ? IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      if (counter == 1) {
                                        setState(() {
                                          option3 = false;
                                          counter = counter - 1;
                                        });
                                      } else if (counter == 2) {
                                        setState(() {
                                          option4 = false;
                                          counter = counter - 1;
                                        });
                                      } else if (counter == 3) {
                                        setState(() {
                                          option5 = false;
                                          counter = counter - 1;
                                        });
                                      } else if (counter >= 4) {
                                        setState(() {
                                          option6 = false;
                                          counter = counter - 1;
                                        });
                                      }
                                    });
                                  })
                              : Container(),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.005,
                  ),
                  Container(
                    height: screenSize.height * 0.1,
                    width: screenSize.width / 1.8,
                    child: TextField(
                      controller: _option2Controller,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: 'Option 2'),
                      maxLength: 25,
                    ),
                  ),
                  option3 == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            Container(
                              height: screenSize.height * 0.1,
                              width: screenSize.width / 1.8,
                              child: TextField(
                                controller: _option3Controller,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffffff),
                                    hintText: 'Option 3'),
                                maxLength: 25,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  option4 == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            Container(
                              height: screenSize.height * 0.1,
                              width: screenSize.width / 1.8,
                              child: TextField(
                                controller: _option4Controller,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffffff),
                                    hintText: 'Option 4'),
                                maxLength: 25,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  option5 == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            Container(
                              height: screenSize.height * 0.1,
                              width: screenSize.width / 1.8,
                              child: TextField(
                                controller: _option5Controller,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffffff),
                                    hintText: 'Option 5'),
                                maxLength: 25,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  option6 == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            Container(
                              height: screenSize.height * 0.1,
                              width: screenSize.width / 1.8,
                              child: TextField(
                                controller: _option6Controller,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffffff),
                                    hintText: 'Option 6'),
                                maxLength: 25,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              )
            ]),
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/task_list.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/team_feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_upload_ad.dart';
import 'package:Yujai/pages/group_upload_discussion.dart';
import 'package:Yujai/pages/group_upload_forum.dart';
import 'package:Yujai/pages/group_upload_poll.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/pages/project_inbox.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/custom_radio_button.dart';
import 'package:Yujai/widgets/nested_tab_bar_project.dart';
import 'package:Yujai/widgets/nested_tab_department.dart';
import 'package:Yujai/widgets/nested_tab_team_home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import 'package:Yujai/pages/group_upload_event.dart';
import 'package:uuid/uuid.dart';

import '../style.dart';

class ProjectPage extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final UserModel currentUser;
  final String label;
  final String projectId;
  final String projectName;
  final int pIcon;
  final int pColor;

  ProjectPage({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
    this.label,
    this.projectId,
    this.projectName,
    this.pIcon,
    this.pColor,
  });
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class PollType {
  int id;
  String name;
  PollType(this.id, this.name);
  static List<PollType> getPollType() {
    return <PollType>[
      PollType(1, 'Quiz'),
      PollType(2, 'Poll'),
      PollType(3, 'Prediction'),
      PollType(4, 'Survey'),
    ];
  }
}

class ProjectType {
  int id;
  String name;
  ProjectType(this.id, this.name);
  static List<ProjectType> getProjectType() {
    return <ProjectType>[
      ProjectType(1, 'Private to project members'),
      ProjectType(2, 'Public to department'),
    ];
  }
}

class PollLength {
  int id;
  String name;
  PollLength(this.id, this.name);
  static List<PollLength> getPollLength() {
    return <PollLength>[
      PollLength(1, 'Environment'),
      PollLength(2, 'Entertainment'),
      PollLength(3, 'Science'),
      PollLength(4, 'Technology'),
      PollLength(5, 'Politics'),
      PollLength(6, 'Social'),
      PollLength(7, 'Sports'),
      PollLength(8, 'Other'),
    ];
  }
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  var _repository = Repository();
  List<DocumentSnapshot> list;
  List<Member> usersList;
  List<ProjectType> _projectType = ProjectType.getProjectType();
  List<DropdownMenuItem<ProjectType>> _dropDownMenuProjectType;
  ProjectType _selectedProjectType;
  final _formKey = GlobalKey<FormState>();
  Group _group;
  Team _team;
  IconData icon;
  Color color;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;
  String currentUserId, followingUserId;
  File imageFile;
  bool isCompany = false;
  static UserModel currentuser;
  bool isMember;
  bool userAgreed = false;
  bool valueFirst = false;
  bool isFollowing = false;
  bool isPrivate = false;
  bool isRequested;
  bool followButtonClicked = false;
  Department _department;
  Project _project;
  TaskList taskList;
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _discussionTitleController = TextEditingController();
  TextEditingController _pollTitleController = TextEditingController();
  TextEditingController _listNameController = TextEditingController();
  TextEditingController _projectNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  List<String> projectList;
  var _currentProject;
  var _currentList;
  List<PollType> _pollType = PollType.getPollType();
  List<DropdownMenuItem<PollType>> _dropDownMenuPollType;
  PollType _selectedPollType;
  List<PollLength> _pollLength = PollLength.getPollLength();
  List<DropdownMenuItem<PollLength>> _dropDownMenuPollLength;
  PollLength _selectedPollLength;
  bool option1, option2, option3, option4, option5, option6 = false;
  int counter = 0;
  TextEditingController _option1Controller = new TextEditingController();
  TextEditingController _option2Controller = new TextEditingController();
  TextEditingController _option3Controller = new TextEditingController();
  TextEditingController _option4Controller = new TextEditingController();
  bool loading = false;
  String newTaskId = Uuid().v4();
  String newListId = Uuid().v4();
  String newPId = Uuid().v4();
  String actId = Uuid().v4();
  final GlobalKey<ScaffoldState> _scaffold1Key = new GlobalKey<ScaffoldState>();
  var _currentDate = DateTime.now();
  var threeHoursFromNow = DateTime.now().add(new Duration(hours: 3));
  var sixHoursFromNow = DateTime.now().add(new Duration(hours: 6));
  var oneDayFromNow = DateTime.now().add(new Duration(days: 1));
  var twoDaysFromNow = DateTime.now().add(new Duration(days: 2));
  List<RadioModel> sampleData = List<RadioModel>();

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    if (!mounted) return;
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
  }

  List<DropdownMenuItem<ProjectType>> buildDropDownMenuProjectType(
      List projectTypes) {
    List<DropdownMenuItem<ProjectType>> items = List();
    for (ProjectType projectType in projectTypes) {
      items.add(
        DropdownMenuItem(
          value: projectType,
          child: Text(projectType.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownProjectType(ProjectType selectedProjectType) {
    setState(() {
      _selectedProjectType = selectedProjectType;
    });
  }

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
    if (_pollTitleController.text.length > 200) {
      setState(() {
        loading = true;
      });
    }
  }

  checkPrivateVal() {
    if (_selectedProjectType.name == 'Private to project members') {
      setState(() {
        isPrivate = true;
      });
    } else {
      setState(() {
        isPrivate = false;
      });
    }
  }

  fetchUserDetailsById(String userId) async {
    Team team = await _repository.fetchTeamDetailsById(widget.gid);
    if (!mounted) return;
    setState(() {
      _team = team;
    });
    Department department =
        await _repository.fetchDepartmentDetailsById(widget.gid, widget.label);
    if (!mounted) return;
    setState(() {
      _department = department;
    });
    Project project = await _repository.fetchProjectDetailsById(
        widget.gid, widget.label, widget.projectId);
    if (!mounted) return;
    setState(() {
      _project = project;
    });
  }

  checkSelected(RadioModel _item) {
    if (_item.subText == '3h') {
      setState(() {
        _currentDate = threeHoursFromNow;
      });
    } else if (_item.subText == '6h') {
      setState(() {
        _currentDate = sixHoursFromNow;
      });
    } else if (_item.subText == '1d') {
      setState(() {
        _currentDate = oneDayFromNow;
      });
    } else if (_item.subText == '2d') {
      setState(() {
        _currentDate = twoDaysFromNow;
      });
    } else {
      setState(() {
        _currentDate = sixHoursFromNow;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isMember = false;
    isRequested = false;
    fetchUidBySearchedName(widget.projectId);

    _repository.getCurrentUser().then((user) {
      if (!mounted) return;
      setState(() {
        user = user;
      });
      _repository.fetchUserDetailsById(user.uid).then((currentUser) {
        if (!mounted) return;
        setState(() {
          currentuser = currentUser;
        });
      });

      _repository
          .checkIsMember(widget.currentUser.uid, widget.gid)
          .then((value) {
        print("VALUE : $value");
        if (!mounted) return;
        setState(() {
          isMember = value;
        });
      });

      _repository
          .checkIsRequestedGroup(widget.currentUser.uid, widget.gid)
          .then((value) {
        print("Request : $value");
        if (!mounted) return;
        setState(() {
          isRequested = value;
        });
      });
    });

    _tabController = TabController(length: 1, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _dropDownMenuPollType = buildDropDownMenuPollType(_pollType);
    _selectedPollType = _dropDownMenuPollType[1].value;
    _dropDownMenuPollLength = buildDropDownMenuPollLength(_pollLength);
    _selectedPollLength = _dropDownMenuPollLength[5].value;
    _dropDownMenuProjectType = buildDropDownMenuProjectType(_projectType);
    _selectedProjectType = _dropDownMenuProjectType[0].value;
    //_projectList();
    sampleData.add(RadioModel(false, '3 h', '3h'));
    sampleData.add(RadioModel(true, '6 h', '6h'));
    sampleData.add(RadioModel(false, '1 d', '1d'));
    sampleData.add(RadioModel(false, '2 d', '2d'));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _projectNameController.dispose();
    _listNameController.dispose();
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              elevation: 0.5,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: screenSize.height * 0.023,
                    child: InkWell(
                      onTap: widget.currentUser != null && _team != null
                          ? checkUser
                          : null,
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    optionProject();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
              title: Row(
                children: [
                  Container(
                    width: screenSize.width * 0.1,
                    height: screenSize.height * 0.06,
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.height * 0.01),
                      child: Icon(
                        Icons.work_outline,
                        //   IconData(widget.pIcon, fontFamily: 'MaterialIcons'),
                        color: Colors.white,
                      ),
                    ),
                    decoration: ShapeDecoration(
                      color: Color(widget.pColor),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.height * 0.01),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  widget.projectName != null
                      ? Text(
                          widget.projectName,
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: textAppTitle(context)),
                        )
                      : Container(),
                ],
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black54,
                    size: screenSize.height * 0.045,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: Colors.white,
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    [_team != null ? buildButtonBar() : Container()]))
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   heroTag: null,
        //   child: Icon(
        //     Icons.add,
        //     size: screenSize.height * 0.05,
        //   ),
        //   onPressed:
        //       widget.currentUser != null && _team != null ? checkUser : null,
        // ),
      ),
    );
  }

  checkUser() {
    if (widget.currentUser.uid == _team.currentUserUid ||
        widget.currentUser.uid == _department.currentUserUid) {
      return _onButtonPressedAdmin();
    } else {
      return _onButtonPressedUser();
    }
  }

  optionProject() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                  content: Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Project',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectInbox(
                                      dept: _department,
                                      team: _team,
                                      project: _project,
                                      currentuser: currentuser,
                                      gid: widget.gid,
                                      name: widget.name)));
                        },
                        leading: Icon(Icons.notifications_outlined,
                            color: Colors.black),
                        title: Text(
                          'Inbox',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          //     addToDeptAdmin();
                        },
                        leading: Icon(Icons.remove_circle_outline,
                            color: Colors.black),
                        title: Text(
                          'Delete',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
            }),
          );
        }));
  }

  void _onButtonPressedUser() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.42,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.list_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'List',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showListDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Task',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showFormDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.commentOutline,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Discussion',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showDiscussionDialog()
                        .then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.poll_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Poll',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showPollDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.closeCircleOutline,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _onButtonPressedJoin() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.18,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    MdiIcons.receipt,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Report Group',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: _showImageDialogAd,
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _showProjectDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'New Project',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textHeader(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: screenSize.height * 0.09,
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Project name',
                            ),
                            onChanged: (val) {
                              if (_projectNameController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _projectNameController,
                          ),
                        ),
                        Text(
                          'Privacy',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: textSubTitle(context)),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButton(
                              underline: Container(color: Colors.white),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black87,
                              ),
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Theme.of(context).primaryColor),
                              //iconSize: 30,
                              isExpanded: true,
                              value: _selectedProjectType,
                              items: _dropDownMenuProjectType,
                              onChanged: (ProjectType selectedProjectType) {
                                setState(() {
                                  _selectedProjectType = selectedProjectType;
                                });
                              },
                            ),
                          ),
                        ),
                        valueFirst
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    _repository
                                        .getCurrentUser()
                                        .then((currentuser) {
                                      if (currentuser != null) {
                                        _repository
                                            .retreiveUserDetails(currentuser)
                                            .then((user) {
                                          _repository
                                              .addProjectToDept(
                                                  user,
                                                  _team.uid,
                                                  _department.uid,
                                                  _projectNameController.text,
                                                  isPrivate,
                                                  Colors
                                                      .primaries[Random()
                                                          .nextInt(Colors
                                                              .primaries
                                                              .length)]
                                                      .value,
                                                  newPId)
                                              .then((value) {
                                            newPId = Uuid().v4();
                                            _projectNameController.text = '';
                                            valueFirst = false;
                                            print(
                                                'Project added to department');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding project: $e'));
                                        });
                                      } else {
                                        print('Current User is null');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create project',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create project',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey[600],
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            width: 0.2, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  _showListDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'New List',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textHeader(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: screenSize.height * 0.09,
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'List name',
                            ),
                            onChanged: (val) {
                              if (_listNameController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _listNameController,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .doc(_department.uid)
                                .collection('projects')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CircularProgressIndicator(),
                                );

                              return Container(
                                padding: EdgeInsets.all(5),
                                child: new DropdownButton(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: _currentProject,
                                  isDense: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem(
                                        value: doc["uid"],
                                        child: Text(
                                          doc["projectName"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: FontNameDefault,
                                            fontSize: textSubTitle(context),
                                          ),
                                        ));
                                  }).toList(),
                                  hint: Text("project",
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentProject = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        valueFirst
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    _repository
                                        .getCurrentUser()
                                        .then((currentuser) {
                                      if (currentuser != null) {
                                        _repository
                                            .retreiveUserDetails(currentuser)
                                            .then((user) {
                                          _repository
                                              .addListToProject(
                                                  newListId,
                                                  user,
                                                  _listNameController.text,
                                                  _team.uid,
                                                  _department.uid,
                                                  _currentProject != null
                                                      ? _currentProject
                                                      : _project.uid,
                                                  Colors
                                                      .primaries[Random()
                                                          .nextInt(Colors
                                                              .primaries
                                                              .length)]
                                                      .value)
                                              .then((value) {
                                            newListId = Uuid().v4();
                                            _listNameController.text = '';
                                            valueFirst = false;
                                            print('List added to project');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding list: $e'));
                                        });
                                      } else {
                                        print('Current User is null');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create list',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create list',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey[600],
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            width: 0.2, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  _showPollDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Poll title',
                            ),
                            onChanged: (val) {
                              if (_pollTitleController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _pollTitleController,
                          ),
                        ),
                        Container(
                          height: screenSize.height * 0.12,
                          width: screenSize.width,
                          // padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.045),
                                child: Divider(
                                  color: Colors.grey[300],
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                //   physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: sampleData.length,
                                itemExtent: screenSize.height * 0.12,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    // height: 60.0,
                                    width: screenSize.width * 0.22,
                                    child: InkWell(
                                      //highlightColor: Colors.red,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          sampleData.forEach((element) =>
                                              element.isSelected = false);
                                          sampleData[index].isSelected = true;
                                        });
                                        checkSelected(sampleData[index]);
                                      },
                                      child: RadioItem(sampleData[index]),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        Row(
                          children: [
                            Container(
                              height: screenSize.height * 0.07,
                              width: screenSize.width * 0.4,
                              child: TextField(
                                  onChanged: (val) {
                                    if (_option1Controller.text.isNotEmpty) {
                                      setState(() {
                                        option1 = true;
                                      });
                                    } else {
                                      setState(() {
                                        option1 = false;
                                      });
                                    }
                                  },
                                  controller: _option1Controller,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Option 1',
                                  )),
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
                          height: screenSize.height * 0.07,
                          width: screenSize.width * 0.4,
                          child: TextField(
                              controller: _option2Controller,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Option 2',
                              )),
                        ),
                        option3 == true
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: screenSize.height * 0.005,
                                  ),
                                  Container(
                                    height: screenSize.height * 0.07,
                                    width: screenSize.width * 0.4,
                                    child: TextField(
                                        controller: _option3Controller,
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          hintText: 'Option 3',
                                        )),
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
                                    height: screenSize.height * 0.07,
                                    width: screenSize.width * 0.4,
                                    child: TextField(
                                        controller: _option4Controller,
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          hintText: 'Option 4',
                                        )),
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .doc(_department.uid)
                                .collection('projects')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CircularProgressIndicator(),
                                );

                              return Container(
                                padding: EdgeInsets.all(5),
                                child: new DropdownButton(
                                  underline: Container(),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: _currentProject,
                                  isDense: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem(
                                        value: doc["uid"],
                                        child: Text(
                                          doc["projectName"],
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textSubTitle(context),
                                          ),
                                        ));
                                  }).toList(),
                                  hint: Text("project",
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentProject = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        valueFirst
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: screenSize.height * 0.015,
                                  left: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    _repository
                                        .getCurrentUser()
                                        .then((currentuser) {
                                      if (currentuser != null) {
                                        _repository
                                            .retreiveUserDetails(currentuser)
                                            .then((user) {
                                          _currentProject == null
                                              ? _repository
                                                  .addPollToDept(
                                                  _team.uid,
                                                  _department.uid,
                                                  user,
                                                  _pollTitleController.text,
                                                  _currentDate
                                                      .millisecondsSinceEpoch,
                                                  'poll',
                                                  _option1Controller.text,
                                                  _option2Controller.text,
                                                  _option3Controller.text,
                                                  _option4Controller.text,
                                                )
                                                  .then((value) {
                                                  valueFirst = false;
                                                  _pollTitleController.text =
                                                      '';
                                                  _option1Controller.text = '';
                                                  _option2Controller.text = '';
                                                  _option3Controller.text = '';
                                                  _option4Controller.text = '';
                                                  print(
                                                      'Poll added to department');
                                                  Navigator.pop(context);
                                                }).catchError((e) => print(
                                                      'Error adding poll: $e'))
                                              : _repository
                                                  .addPollToProject(
                                                  _team.uid,
                                                  _department.uid,
                                                  _currentProject != null
                                                      ? _currentProject
                                                      : _project.uid,
                                                  user,
                                                  _pollTitleController.text,
                                                  _currentDate
                                                      .millisecondsSinceEpoch,
                                                  'poll',
                                                  _option1Controller.text,
                                                  _option2Controller.text,
                                                  _option3Controller.text,
                                                  _option4Controller.text,
                                                )
                                                  .then((value) {
                                                  valueFirst = false;
                                                  _pollTitleController.text =
                                                      '';
                                                  _option1Controller.text = '';
                                                  _option2Controller.text = '';
                                                  _option3Controller.text = '';
                                                  _option4Controller.text = '';
                                                  print(
                                                      'Poll added to project');
                                                  Navigator.pop(context);
                                                }).catchError((e) => print(
                                                      'Error adding poll: $e'));
                                        });
                                      } else {
                                        print('Current User is null');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create poll',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                  top: screenSize.height * 0.015,
                                  left: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create poll',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey[600],
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            width: 0.2, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  _showDiscussionDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.max,
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'New Discussion',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textHeader(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: screenSize.height * 0.09,
                          child: TextField(
                            minLines: 1,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Title',
                            ),
                            onChanged: (val) {
                              if (_discussionTitleController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _discussionTitleController,
                          ),
                        ),
                        // Container(
                        //   child: TextField(
                        //     style: TextStyle(
                        //       fontSize: screenSize.height * 0.018,
                        //     ),
                        //     minLines: 1,
                        //     maxLines: 3,
                        //     keyboardType: TextInputType.multiline,
                        //     decoration: InputDecoration(
                        //       border: UnderlineInputBorder(),
                        //       hintText: 'Description',
                        //     ),
                        //     // onChanged: (val) {
                        //     //   if (_taskDescriptionController.text.isNotEmpty) {
                        //     //     setState(() {
                        //     //       valueFirst = true;
                        //     //     });
                        //     //   } else {
                        //     //     setState(() {
                        //     //       valueFirst = false;
                        //     //     });
                        //     //   }
                        //     // },
                        //     controller: _taskDescriptionController,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: screenSize.height * 0.02,
                        // ),
                        // Text(
                        //   'Add to',
                        // ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .doc(_department.uid)
                                .collection('projects')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CircularProgressIndicator(),
                                );

                              return Container(
                                padding: EdgeInsets.all(5),
                                child: new DropdownButton(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: _currentProject,
                                  isDense: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem(
                                        value: doc["uid"],
                                        child: Text(
                                          doc["projectName"],
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textSubTitle(context),
                                          ),
                                        ));
                                  }).toList(),
                                  hint: Text("project",
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentProject = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        valueFirst
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    _repository
                                        .getCurrentUser()
                                        .then((currentuser) {
                                      if (currentuser != null) {
                                        _repository
                                            .retreiveUserDetails(currentuser)
                                            .then((user) {
                                          _repository
                                              .addDiscussionToProject(
                                            _team.uid,
                                            _department.uid,
                                            _currentProject != null
                                                ? _currentProject
                                                : _project.uid,
                                            user,
                                            _taskNameController.text,
                                          )
                                              .then((value) {
                                            print(
                                                'Project added to department');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding project: $e'));
                                        });
                                      } else {
                                        print('Current User is null');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create discussion',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create discussion',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey[600],
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            width: 0.2, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  _showFormDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.max,
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'New Task',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textHeader(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: screenSize.height * 0.09,
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Task name',
                            ),
                            onChanged: (val) {
                              if (_taskNameController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _taskNameController,
                          ),
                        ),
                        Container(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            minLines: 1,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Description',
                            ),
                            // onChanged: (val) {
                            //   if (_taskDescriptionController.text.isNotEmpty) {
                            //     setState(() {
                            //       valueFirst = true;
                            //     });
                            //   } else {
                            //     setState(() {
                            //       valueFirst = false;
                            //     });
                            //   }
                            // },
                            controller: _taskDescriptionController,
                          ),
                        ),
                        // SizedBox(
                        //   height: screenSize.height * 0.02,
                        // ),
                        // Text(
                        //   'Add to',
                        // ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .doc(_department.uid)
                                .collection('projects')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CircularProgressIndicator(),
                                );

                              return Container(
                                padding: EdgeInsets.all(5),
                                child: new DropdownButton(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: _currentProject,
                                  isDense: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem(
                                        value: doc["uid"],
                                        child: Text(
                                          doc["projectName"],
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textSubTitle(context),
                                          ),
                                        ));
                                  }).toList(),
                                  hint: Text("project",
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentProject = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .doc(_department.uid)
                                .collection('projects')
                                .doc(widget.projectId)
                                .collection('list')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CircularProgressIndicator(),
                                );

                              return Container(
                                padding: EdgeInsets.all(5),
                                child: new DropdownButton(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: _currentList,
                                  isDense: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem(
                                        value: doc["listId"],
                                        child: Text(doc["listName"],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textSubTitle(context),
                                            )));
                                  }).toList(),
                                  hint: Text("list",
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentList = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        valueFirst && _currentList != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    _repository
                                        .getCurrentUser()
                                        .then((currentuser) {
                                      if (currentuser != null) {
                                        _repository
                                            .retreiveUserDetails(currentuser)
                                            .then((user) {
                                          _repository
                                              .addTaskToList(
                                                  newTaskId,
                                                  user,
                                                  _taskNameController.text,
                                                  _taskDescriptionController
                                                      .text,
                                                  _team.uid,
                                                  _department.uid,
                                                  _currentProject != null
                                                      ? _currentProject
                                                      : _project.uid,
                                                  _currentList)
                                              .then((value) {
                                            newTaskId = Uuid().v4();
                                            _taskNameController.text = '';
                                            _taskDescriptionController.text =
                                                '';
                                            valueFirst = false;
                                            print('Task added to list');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding task: $e'));
                                        });
                                      } else {
                                        print('Current User is null');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create task',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Create task',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey[600],
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            width: 0.2, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  leaveGroup() async {
    if (isMember == true) {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(_team.uid)
          .collection('members')
          .doc(currentuser.uid)
          .delete()
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });

      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser.uid)
          .collection('groups')
          .doc(_team.uid)
          .delete()
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  void _onButtonPressedAdmin() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.5,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.assignment_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Project',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showProjectDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.list_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'List',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showListDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Task',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showFormDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.commentOutline,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Discussion',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showDiscussionDialog()
                        .then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.poll_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Poll',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showPollDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.closeCircleOutline,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  buildButtonBar() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.96,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            child: widget.currentUser != null &&
                    _department != null &&
                    _project != null
                ? NestedTabBarProject(
                    memberlist: usersList,
                    department: _department,
                    project: _project,
                    team: _team,
                    currentUser: widget.currentUser,
                    isMember: isMember,
                    gid: widget.gid,
                    name: widget.name,
                  )
                : Container(),
          ),
        ],
        controller: _tabController,
      ),
    );
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  _showImageDialogEvent() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Upload event cover photo',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => GroupUploadEvent(
                    //               group: _team,
                    //               gid: widget.gid,
                    //               name: widget.name,
                    //               imageFile: imageFile,
                    //             ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showImageDialogAd() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GroupUploadAd(
                    //               group: _team,
                    //               gid: widget.gid,
                    //               name: widget.name,
                    //               imageFile: imageFile,
                    //             )));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void addInbox(String type, UserModel currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (currentUser.uid == _team.currentUserUid) {
      return print('Owner liked');
    } else {
      var _feed = TeamFeed(
        assigned: [_team.currentUserUid],
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: type,
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: '',
        postId: actId,
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('inbox')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(actId)
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Inbox added');
      });
    }
  }
}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}

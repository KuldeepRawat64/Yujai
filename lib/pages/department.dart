import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/team_feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/dept_inbox.dart';
import 'package:Yujai/pages/dept_invite.dart';
import 'package:Yujai/pages/dept_settings.dart';
import 'package:Yujai/pages/group_invite.dart';
import 'package:Yujai/pages/group_upload_ad.dart';
import 'package:Yujai/pages/group_upload_discussion.dart';
import 'package:Yujai/pages/group_upload_forum.dart';
import 'package:Yujai/pages/group_upload_poll.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/pages/team_invite.dart';
import 'package:Yujai/pages/team_members.dart';
import 'package:Yujai/pages/team_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/custom_radio_button.dart';
import 'package:Yujai/widgets/nested_tab_department.dart';
import 'package:Yujai/widgets/nested_tab_team_home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import 'package:Yujai/pages/group_upload_event.dart';
import 'package:uuid/uuid.dart';

import 'dept_members.dart';

class DepartmentPage extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final UserModel currentUser;
  final String dName;
  final String dId;
  final Map<String, dynamic> dIcon;
  final int dColor;

  DepartmentPage({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
    this.dName,
    this.dId,
    this.dIcon,
    this.dColor,
  });
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
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

class _DepartmentPageState extends State<DepartmentPage>
    with TickerProviderStateMixin {
  List<ProjectType> _projectType = ProjectType.getProjectType();
  List<DropdownMenuItem<ProjectType>> _dropDownMenuProjectType;
  ProjectType _selectedProjectType;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _value = 1;
  TabController _tabController;
  var _repository = Repository();
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
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _discussionTitleController = TextEditingController();
  TextEditingController _pollTitleController = TextEditingController();
  TextEditingController _listNameController = TextEditingController();
  TextEditingController _projectNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  List<PollType> _pollType = PollType.getPollType();
  List<DropdownMenuItem<PollType>> _dropDownMenuPollType;
  PollType _selectedPollType;
  List<PollLength> _pollLength = PollLength.getPollLength();
  List<DropdownMenuItem<PollLength>> _dropDownMenuPollLength;
  PollLength _selectedPollLength;
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  bool option4 = false;
  int counter = 0;
  TextEditingController _option1Controller = new TextEditingController();
  TextEditingController _option2Controller = new TextEditingController();
  TextEditingController _option3Controller = new TextEditingController();
  TextEditingController _option4Controller = new TextEditingController();
  List<String> projectList;
  var _currentProject;
  var _currentList;
  String newPId = Uuid().v4();
  String newTaskId = Uuid().v4();
  String newDId = Uuid().v4();
  String actId = Uuid().v4();
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

  fetchUserDetailsById(String userId) async {
    Team team = await _repository.fetchTeamDetailsById(widget.gid);
    if (!mounted) return;
    setState(() {
      _team = team;
    });
    Department department =
        await _repository.fetchDepartmentDetailsById(widget.gid, widget.dId);
    if (!mounted) return;
    setState(() {
      _department = department;
    });
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
    fetchUidBySearchedName(widget.gid);
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
          .checkIsMember(widget.currentUser.uid, widget.gid, false)
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
    _dropDownMenuProjectType = buildDropDownMenuProjectType(_projectType);
    _selectedProjectType = _dropDownMenuProjectType[0].value;
    _dropDownMenuPollType = buildDropDownMenuPollType(_pollType);
    _selectedPollType = _dropDownMenuPollType[1].value;
    _dropDownMenuPollLength = buildDropDownMenuPollLength(_pollLength);
    _selectedPollLength = _dropDownMenuPollLength[5].value;
    checkPrivateVal();
    sampleData.add(RadioModel(false, '3 h', '3h'));
    sampleData.add(RadioModel(true, '6 h', '6h'));
    sampleData.add(RadioModel(false, '1 d', '1d'));
    sampleData.add(RadioModel(false, '2 d', '2d'));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                            'Close Department',
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
                          'Are you sure you want to close this department? This action will delete the department permanently!',
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
                                  .collection('teams')
                                  .doc(widget.gid)
                                  .collection('departments')
                                  .doc(widget.dId)
                                  .delete()
                                  .then((value) => Navigator.pop(context));
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        key: _scaffoldKey,
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              //   collapsedHeight: screenSize.height * 0.09,
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
                widget.currentUser != null &&
                            _team != null &&
                            _department != null &&
                            widget.currentUser.uid == _team.currentUserUid ||
                        widget.currentUser != null &&
                            _team != null &&
                            _department != null &&
                            widget.currentUser.uid == _department.currentUserUid
                    ? InkWell(
                        onTap: () => _scaffoldKey.currentState.openEndDrawer(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : Container(),
              ],
              title: StreamBuilder(
                  stream: teamsRef
                      .doc(widget.gid)
                      .collection('departments')
                      .doc(widget.dId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return CircleAvatar(
                          radius: screenSize.height * 0.045,
                          backgroundImage:
                              AssetImage('assets/images/error.png'),
                        );
                      }
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            Container(
                              width: screenSize.width * 0.1,
                              height: screenSize.height * 0.06,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.height * 0.01),
                                child: Icon(
                                  deserializeIcon(
                                      snapshot.data['departmentProfilePhoto']),
                                  color: Colors.white,
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Color(snapshot.data['color']),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.height * 0.01),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Container(
                              width: screenSize.width * 0.45,
                              child: Text(
                                snapshot.data['departmentName'],
                                style: TextStyle(
                                  fontSize: screenSize.height * 0.022,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.black54, size: screenSize.height * 0.045),
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
        endDrawer: widget.currentUser != null &&
                _team != null &&
                widget.currentUser.uid == _team.currentUserUid
            ? Drawer(
                child: Container(
                  color: const Color(0xff251F34),
                  child: Column(
                    children: [
                      UserAccountsDrawerHeader(
                        arrowColor: Colors.white,
                        decoration: BoxDecoration(
                          color: const Color(0xff251F34),
                        ),
                        currentAccountPicture: Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.02),
                          child: CircleAvatar(
                            radius: screenSize.height * 0.04,
                            backgroundColor: Colors.white,
                            backgroundImage: widget.currentUser != null
                                ? CachedNetworkImageProvider(
                                    widget.currentUser.photoUrl)
                                : AssetImage('assets/images/no_image.png'),
                          ),
                        ),
                        accountName: Text(
                          widget.currentUser != null
                              ? widget.currentUser.displayName
                              : '',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context)),
                        ),
                        accountEmail: Text(
                          widget.currentUser != null
                              ? widget.currentUser.email
                              : '',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textBody1(context)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DeptMembers(
                                              group: _team,
                                              dept: _department,
                                              currentuser: currentuser,
                                              gid: widget.gid,
                                              name: widget.name,
                                            )));
                              },
                              leading: Icon(
                                Icons.people_alt_outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Members',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.white,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DeptInbox(
                                            dept: _department,
                                            team: _team,
                                            currentuser: currentuser,
                                            gid: widget.gid,
                                            name: widget.name)));
                              },
                              leading: Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.white,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Column(
                                children: <Widget>[
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeptSettings(
                                                    gid: widget.gid,
                                                    dId: widget.dId,
                                                    name: widget.dName,
                                                    team: _team,
                                                    dept: _department,
                                                    currentuser: currentuser,
                                                  )));
                                    },
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.settings_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Settings',
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              color: Colors.white,
                                              fontSize: textSubTitle(context)),
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DeptInvite(
                                                  dept: _department,
                                                  group: _team,
                                                  currentuser: currentuser,
                                                  gid: widget.gid,
                                                  name: widget.name)));
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Add member',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.white,
                                            fontSize: textSubTitle(context)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ))),
                    ],
                  ),
                ),
              )
            : widget.currentUser != null &&
                    _department != null &&
                    widget.currentUser.uid == _department.currentUserUid
                ? Drawer(
                    child: Container(
                      color: const Color(0xff251F34),
                      child: Column(
                        children: [
                          UserAccountsDrawerHeader(
                            arrowColor: Colors.white,
                            decoration: BoxDecoration(
                              color: const Color(0xff251F34),
                            ),
                            currentAccountPicture: Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.02),
                              child: CircleAvatar(
                                radius: screenSize.height * 0.04,
                                backgroundColor: Colors.white,
                                backgroundImage: widget.currentUser != null
                                    ? CachedNetworkImageProvider(
                                        widget.currentUser.photoUrl)
                                    : AssetImage('assets/images/no_image.png'),
                              ),
                            ),
                            accountName: Text(
                              widget.currentUser != null
                                  ? widget.currentUser.displayName
                                  : '',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.white,
                                  fontSize: textSubTitle(context)),
                            ),
                            accountEmail: Text(
                              widget.currentUser != null
                                  ? widget.currentUser.email
                                  : '',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.white,
                                  fontSize: textBody1(context)),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DeptMembers(
                                                  group: _team,
                                                  dept: _department,
                                                  currentuser: currentuser,
                                                  gid: widget.gid,
                                                  name: widget.name,
                                                )));
                                  },
                                  leading: Icon(
                                    Icons.people_alt_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'Members',
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.white,
                                        fontSize: textSubTitle(context)),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DeptInbox(
                                                dept: _department,
                                                team: _team,
                                                currentuser: currentuser,
                                                gid: widget.gid,
                                                name: widget.name)));
                                  },
                                  leading: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'Inbox',
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.white,
                                        fontSize: textSubTitle(context)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Column(
                                    children: <Widget>[
                                      Divider(),
                                      ListTile(
                                          leading: Icon(
                                            Icons.close_outlined,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            'Close',
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                color: Colors.white,
                                                fontSize:
                                                    textSubTitle(context)),
                                          )),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeamInvite(
                                                          group: _team,
                                                          currentuser:
                                                              currentuser,
                                                          gid: widget.gid,
                                                          name: widget.name)));
                                        },
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.account_circle_outlined,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            'Add member',
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                color: Colors.white,
                                                fontSize:
                                                    textSubTitle(context)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                  )
                : Container(),
      ),
    );
  }

  checkUser() {
    if (widget.currentUser.uid == _team.currentUserUid) {
      return _onButtonPressedAdmin();
    } else if (widget.isMember == true || isMember == true) {
      return _onButtonPressedUser();
    } else {
      return _onButtonPressedJoin();
    }
  }

  void _onButtonPressedUser() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.34,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.add_a_photo,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Project',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.white,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: _showImageDialog,
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.shopping,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Task',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.white,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showTaskDialog().then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.text_fields,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Discussion',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.white,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GroupUploadDiscussion(
                    //               group: _team,
                    //               gid: widget.gid,
                    //               name: widget.name,
                    //             )));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.poll,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Poll',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.white,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GroupUploadPoll(
                    //               group: _team,
                    //               gid: widget.gid,
                    //               name: widget.name,
                    //             )));
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
                    style: TextStyle(fontSize: screenSize.height * 0.022),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(fontSize: screenSize.height * 0.022),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontSize: textHeader(context),
                                    fontWeight: FontWeight.bold),
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
                            )),
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        Text(
                          'Privacy',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
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
                              // iconSize: 30,
                              isExpanded: true,
                              value: _selectedProjectType,
                              items: _dropDownMenuProjectType,
                              onChanged: onChangeDropDownProjectType,
                            ),
                          ),
                        ),
                        //  Text(_team.customRules),
                        valueFirst
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
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
                                            valueFirst = false;
                                            newPId = Uuid().v4();
                                            _projectNameController.text = '';
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
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
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

  // joinGroup() async {
  //   if (_team.isPrivate == false) {
  //     var _member = Member(
  //       ownerName: currentuser.displayName,
  //       ownerUid: currentuser.uid,
  //       ownerPhotoUrl: currentuser.photoUrl,
  //       accountType: '',
  //       timestamp: FieldValue.serverTimestamp(),
  //     );
  //     await Firestore.instance
  //         .collection('groups')
  //         .document(_team.uid)
  //         .collection('members')
  //         .document(currentuser.uid)
  //         .setData(_member.toMap(_member));

  //     var group = Group(
  //       uid: _team.uid,
  //       groupName: _team.groupName,
  //       groupProfilePhoto: _team.groupProfilePhoto,
  //       isPrivate: isPrivate,
  //     );
  //     return Firestore.instance
  //         .collection('users')
  //         .document(currentuser.uid)
  //         .collection('groups')
  //         .document(_team.uid)
  //         .setData(group.toMap(group))
  //         .then((value) => Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => DepartmentPage(
  //                       currentUser: currentuser,
  //                       isMember: false,
  //                       gid: _team.uid,
  //                       name: _team.groupName,
  //                     ))));
  //   } else {
  //     var _member = Member(
  //       ownerName: currentuser.displayName,
  //       ownerUid: currentuser.uid,
  //       ownerPhotoUrl: currentuser.photoUrl,
  //       accountType: '',
  //       timestamp: FieldValue.serverTimestamp(),
  //     );
  //     Firestore.instance
  //         .collection('groups')
  //         .document(_team.uid)
  //         .collection('requests')
  //         .document(currentuser.uid)
  //         .setData(_member.toMap(_member))
  //         .then((value) {
  //       setState(() {
  //         isRequested = true;
  //       });
  //     });
  //   }
  // }

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

  _showTaskDialog() {
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
                                    fontSize: textHeader(context),
                                    fontWeight: FontWeight.bold),
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
                                            fontSize: textBody1(context),
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
                                .doc(_currentProject)
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
                                              fontSize: textBody1(context),
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
                                                  _currentProject,
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

  void _onButtonPressedAdmin() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -18,
                right: 6,
                child: InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.36,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.assignment_outlined,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Project',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            //  color: Colors.white,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        _showFormDialog().then((val) => Navigator.pop(context));
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
                            //   color: Colors.white,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        _showTaskDialog().then((val) => Navigator.pop(context));
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
                            //  color: Colors.white,
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
                            //  color: Colors.white,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        _showPollDialog().then((val) => Navigator.pop(context));
                      },
                    ),
                  ],
                ),
              ),

              // ListTile(
              //   leading: Icon(
              //     Icons.cancel_outlined,
              //     size: screenSize.height * 0.04,
              //   ),
              //   title: Text(
              //     'Cancel',
              //     style: TextStyle(
              //         fontFamily: FontNameDefault,
              //         //   color: Colors.white,
              //         fontSize: textSubTitle(context)),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ],
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
            child: widget.currentUser != null && _department != null
                ? NestedTabBarDepartment(
                    department: _department,
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
                                    fontSize: textHeader(context),
                                    fontWeight: FontWeight.bold),
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
                        //   padding: EdgeInsets.all(5),
                        //   child: StreamBuilder<QuerySnapshot>(
                        //     stream: FirebaseFirestore.instance
                        //         .collection('teams')
                        //         .doc(widget.gid)
                        //         .collection('departments')
                        //         .doc(_department.uid)
                        //         .collection('projects')
                        //         .snapshots(),
                        //     builder: (context, snapshot) {
                        //       if (!snapshot.hasData)
                        //         return const Center(
                        //           child: const CircularProgressIndicator(),
                        //         );

                        //       return Container(
                        //         padding: EdgeInsets.all(5),
                        //         child: new DropdownButton(
                        //           icon: Icon(Icons.keyboard_arrow_down),
                        //           value: _currentProject,
                        //           isDense: true,
                        //           items: snapshot.data.docs
                        //               .map((DocumentSnapshot doc) {
                        //             return new DropdownMenuItem(
                        //                 value: doc["uid"],
                        //                 child: Text(
                        //                   doc["projectName"],
                        //                   style: TextStyle(
                        //                     fontFamily: FontNameDefault,
                        //                     fontSize: textBody1(context),
                        //                   ),
                        //                 ));
                        //           }).toList(),
                        //           hint: Text("project",
                        //               style: TextStyle(
                        //                 fontFamily: FontNameDefault,
                        //                 fontSize: textBody1(context),
                        //               )),
                        //           onChanged: (value) {
                        //             setState(() {
                        //               _currentProject = value;
                        //             });
                        //           },
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
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
                                          // _currentProject != null
                                          //     ? _repository
                                          //         .addDiscussionToProject(
                                          //         _team.uid,
                                          //         _department.uid,
                                          //         _currentProject,
                                          //         user,
                                          //         _discussionTitleController
                                          //             .text,
                                          //       )
                                          //     :
                                          _repository
                                              .addDiscussionToDept(
                                                  _team.uid,
                                                  _department.uid,
                                                  user,
                                                  _discussionTitleController
                                                      .text,
                                                  newDId)
                                              .then((value) {
                                            newDId = Uuid().v4();
                                            _discussionTitleController.text =
                                                '';
                                            valueFirst = false;
                                            print(
                                                'Discussion added to project');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding department: $e'));
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 5),
                        //       child: DropdownButton(
                        //           hint: Text('Type'),
                        //           underline: Container(color: Colors.white),
                        //           style: TextStyle(
                        //             fontFamily: FontNameDefault,
                        //             fontSize: textBody1(context),
                        //             color: Colors.black87,
                        //           ),
                        //           // iconSize: screenSize.height * 0.05,
                        //           icon: Icon(Icons.keyboard_arrow_down,
                        //               color: Theme.of(context).primaryColor),
                        //           value: _selectedPollType,
                        //           items: _dropDownMenuPollType,
                        //           onChanged: (PollType selectedPollType) {
                        //             setState(() {
                        //               _selectedPollType = selectedPollType;
                        //             });
                        //           }),
                        //     ),
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 5),
                        //       child: DropdownButton(
                        //           hint: Text('Category'),
                        //           underline: Container(color: Colors.white),
                        //           style: TextStyle(
                        //             fontFamily: FontNameDefault,
                        //             fontSize: textBody1(context),
                        //             color: Colors.black87,
                        //           ),
                        //           //  iconSize: screenSize.height * 0.05,
                        //           icon: Icon(Icons.keyboard_arrow_down,
                        //               color: Theme.of(context).primaryColor),
                        //           value: _selectedPollLength,
                        //           items: _dropDownMenuPollLength,
                        //           onChanged: (PollLength selectedPollLength) {
                        //             setState(() {
                        //               _selectedPollLength = selectedPollLength;
                        //             });
                        //           }),
                        //     )
                        //   ],
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                            //   bottom: screenSize.height * 0.01,
                            left: screenSize.width * 0.1,
                            top: screenSize.height * 0.01,
                          ),
                          child: Text(
                            'Choose poll length',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
                                          });
                                        } else if (counter == 1) {
                                          setState(() {
                                            option3 = true;
                                          });
                                        } else if (counter == 2) {
                                          setState(() {
                                            option4 = true;
                                          });
                                          // } else if (counter == 3) {
                                          //   setState(() {
                                          //     option5 = true;
                                          //   });
                                          // } else if (counter >= 4) {
                                          //   setState(() {
                                          //     option6 = true;
                                          //   });
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
                        // Container(
                        //   padding: EdgeInsets.all(5),
                        //   child: StreamBuilder<QuerySnapshot>(
                        //     stream: FirebaseFirestore.instance
                        //         .collection('teams')
                        //         .doc(widget.gid)
                        //         .collection('departments')
                        //         .doc(_department.uid)
                        //         .collection('projects')
                        //         .snapshots(),
                        //     builder: (context, snapshot) {
                        //       if (!snapshot.hasData)
                        //         return const Center(
                        //           child: const CircularProgressIndicator(),
                        //         );

                        //       return Container(
                        //         padding: EdgeInsets.all(5),
                        //         child: new DropdownButton(
                        //           underline: Container(),
                        //           icon: Icon(Icons.keyboard_arrow_down),
                        //           value: _currentProject,
                        //           isDense: true,
                        //           items: snapshot.data.docs
                        //               .map((DocumentSnapshot doc) {
                        //             return new DropdownMenuItem(
                        //                 value: doc["uid"],
                        //                 child: Text(
                        //                   doc["projectName"],
                        //                   style: TextStyle(
                        //                     fontFamily: FontNameDefault,
                        //                     fontSize: textBody1(context),
                        //                   ),
                        //                 ));
                        //           }).toList(),
                        //           hint: Text("project",
                        //               style: TextStyle(
                        //                 fontFamily: FontNameDefault,
                        //                 fontSize: textBody1(context),
                        //               )),
                        //           onChanged: (value) {
                        //             setState(() {
                        //               _currentProject = value;
                        //             });
                        //           },
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        valueFirst &&
                                _option1Controller.text.isNotEmpty &&
                                _option2Controller.text.isNotEmpty
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
                                          // _currentProject == null
                                          // ?
                                          _repository
                                              .addPollToDept(
                                            _team.uid,
                                            _department.uid,
                                            user,
                                            _pollTitleController.text,
                                            _currentDate.millisecondsSinceEpoch,
                                            'poll',
                                            _option1Controller.text,
                                            _option2Controller.text,
                                            _option3Controller.text,
                                            _option4Controller.text,
                                          )
                                              .then((value) {
                                            valueFirst = false;
                                            _pollTitleController.text = '';
                                            _option1Controller.text = '';
                                            _option2Controller.text = '';
                                            _option3Controller.text = '';
                                            _option4Controller.text = '';
                                            print('Poll added to department');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding poll: $e'));

                                          // :
                                          //   _repository
                                          //       .addPollToProject(
                                          //     _team.uid,
                                          //     _department.uid,
                                          //     _currentProject,
                                          //     user,
                                          //     _pollTitleController.text,
                                          //     _currentDate.millisecondsSinceEpoch,
                                          //     'poll',
                                          //     _option1Controller.text,
                                          //     _option2Controller.text,
                                          //     _option3Controller.text,
                                          //     _option4Controller.text,
                                          //   )
                                          //       .then((value) {
                                          //     valueFirst = false;
                                          //     _pollTitleController.text = '';
                                          //     _option1Controller.text = '';
                                          //     _option2Controller.text = '';
                                          //     _option3Controller.text = '';
                                          //     _option4Controller.text = '';
                                          //     print('Poll added to project');
                                          //     Navigator.pop(context);
                                          //   }).catchError((e) => print(
                                          //           'Error adding poll: $e'));
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

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  _showImageDialog() {
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
                    //         builder: (context) => GroupUploadForum(
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

  void addActivityToInbox(UserModel currentUser, String type) {
    if (widget.currentUser.uid == _team.currentUserUid) {
      return print('owner activity');
    } else {
      var _feed = TeamFeed(
        assigned: [_team.currentUserUid, _department.currentUserUid],
        ownerName: currentuser.displayName,
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
          .doc(actId)
          .set(_feed.toMap(_feed))
          .then((val) {
        print('inbox feed added');
        actId = Uuid().v4();
      });
    }
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_invite.dart';
import 'package:Yujai/pages/group_upload_ad.dart';
import 'package:Yujai/pages/group_upload_discussion.dart';
import 'package:Yujai/pages/group_upload_event.dart';
import 'package:Yujai/pages/group_upload_forum.dart';
import 'package:Yujai/pages/group_upload_poll.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/pages/team_inbox.dart';
import 'package:Yujai/pages/team_invite.dart';
import 'package:Yujai/pages/team_members.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/nested_tab_team_home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

class TeamPage extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final User currentUser;

  const TeamPage({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
  });
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with TickerProviderStateMixin {
  static User currentuser;
  TabController _tabController;
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Group _group;
  Team _team;
  IconData icon;
  Color color;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  //Offset state <-------------------------------------
  ScrollController _scrollController;
  double offset = 0.0;
  String currentUserId, followingUserId;
  File imageFile;
  bool isCompany = false;
  bool isMember;
  bool userAgreed = false;
  bool valueFirst = false;
  bool isFollowing = false;
  bool isPrivate = false;
  bool isRequested;
  bool followButtonClicked = false;
  TextEditingController _departmentNameController = TextEditingController();
  String dId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xfff6f6f6),
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              stretch: false,
              elevation: 0.5,
              actions: [
                widget.currentUser != null &&
                        _team != null &&
                        widget.currentUser.uid == _team.currentUserUid
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
                    : InkWell(
                        onTap: optionProject,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Icon(Icons.menu_outlined, color: Colors.black54),
                        ),
                      )

                // Padding(
                //     padding: EdgeInsets.symmetric(
                //       vertical: screenSize.height * 0.02,
                //       horizontal: screenSize.width / 50,
                //     ),
                //     child: GestureDetector(
                //       onTap: () {},
                //       child: Container(
                //         width: screenSize.width * 0.15,
                //         child: Center(
                //             child: Text(
                //           'Leave',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontFamily: FontNameDefault,
                //             color: Colors.white,
                //             fontSize: textButton(context),
                //           ),
                //         )),
                //         decoration: ShapeDecoration(
                //           color: Theme.of(context).primaryColor,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(60.0),
                //           ),
                //         ),
                //       ),
                //     ),
                //   )
              ],
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/team_no-image.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: screenSize.height * 0.022,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
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
        floatingActionButton: widget.currentUser != null &&
                _team != null &&
                widget.currentUser.uid == _team.currentUserUid
            ? FloatingActionButton(
                heroTag: null,
                child: Icon(
                  Icons.add,
                  size: screenSize.height * 0.05,
                ),
                onPressed: _onButtonPressedAdmin,
              )
            : Text(''),
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
                            backgroundColor: Colors.black,
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
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamMembers(
                                            group: _team,
                                            currentuser: currentuser,
                                            gid: widget.gid,
                                            name: widget.name)));
                              },
                              leading: Icon(
                                Icons.people_outline,
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
                                        builder: (context) => TeamInbox(
                                            team: _team,
                                            currentuser: currentuser,
                                            gid: widget.gid,
                                            name: widget.name)));
                              },
                              leading: Icon(
                                Icons.notifications_outlined,
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
                                  Divider(
                                    color: Colors.white,
                                    thickness: 0.1,
                                  ),
                                  InkWell(
                                      onTap: deleteDialog,
                                      child: ListTile(
                                          leading: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            'Close team',
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                color: Colors.white,
                                                fontSize:
                                                    textSubTitle(context)),
                                          ))),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TeamInvite(
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
                                        )),
                                  )
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
                            'Close Team',
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
                          'Are you sure you want to close this team? This action will delete the team permanently!',
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
                                  .collection('teams')
                                  .document(widget.gid)
                                  .delete()
                                  .then((value) {
                                Firestore.instance
                                    .collection('users')
                                    .document(widget.currentUser.uid)
                                    .collection('teams')
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
                                      color: Colors.grey[600],
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

  buildButtonBar() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
              //  height: MediaQuery.of(context).size.height * 0.75,
              child: widget.currentUser != null
                  ? NestedTabBarTeamHome(
                      team: _team,
                      currentUser: widget.currentUser,
                      isMember: isMember,
                      gid: widget.gid,
                      name: widget.name,
                    )
                  : Container()),
        ],
        controller: _tabController,
      ),
    );
  }

  checkUser() {
    if (widget.currentUser.uid == _team.currentUserUid) {
      return _onButtonPressedAdmin();
    } else {
      return _onButtonPressedUser();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
  }

  leaveTeam() async {
    await Firestore.instance
        .collection('teams')
        .document(_team.uid)
        .collection('members')
        .document(currentuser.uid)
        .delete()
        .then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    });

    return Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .collection('teams')
        .document(_team.uid)
        .delete()
        .then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  void _onButtonPressedAdmin() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.17,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.assignment_ind_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Department',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    _showDepartmentDialog()
                        .then((val) => Navigator.pop(context));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () => Navigator.pop(context),
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
                    'Upload Post',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
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
                    'Post an Ad',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: _showImageDialogAd,
                ),
                ListTile(
                  leading: Icon(
                    Icons.text_fields,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Start Discussion',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
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
                    'Create Poll',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
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

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  _showDepartmentDialog() {
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
                                'New Department',
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
                                fontSize: textBody1(context)),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Department name',
                            ),
                            onChanged: (val) {
                              if (_departmentNameController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _departmentNameController,
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
                                              .addDeptToteam(
                                                  user,
                                                  _team.uid,
                                                  dId,
                                                  _departmentNameController
                                                      .text,
                                                  isPrivate,
                                                  60152,
                                                  Colors
                                                      .primaries[Random()
                                                          .nextInt(Colors
                                                              .primaries
                                                              .length)]
                                                      .value)
                                              .then((value) {
                                            _departmentNameController.text = '';
                                            valueFirst = false;
                                            dId = Uuid().v4();
                                            print('Department added to team');
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
                                        'Create department',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.white,
                                            fontSize: textSubTitle(context)),
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
                                        'Create department',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.grey[600],
                                            fontSize: textSubTitle(context)),
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
                        'Team Options',
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
                                  builder: (context) => TeamInbox(
                                      //   dept: _department,
                                      team: _team,
                                      //   project: _project,
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
                          'Leave Team',
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
}

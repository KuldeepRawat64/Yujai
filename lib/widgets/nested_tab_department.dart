import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/pages/dept_members.dart';
import 'package:Yujai/pages/project_page.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/list_discussions_dept.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image/image.dart' as Im;
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class NestedTabBarDepartment extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final UserModel currentUser;
  final Team team;
  final Department department;
  const NestedTabBarDepartment({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
    this.team,
    this.department,
  });
  @override
  _NestedTabBarDepartmentState createState() => _NestedTabBarDepartmentState();
}

class _NestedTabBarDepartmentState extends State<NestedTabBarDepartment>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  UserModel currentuser, user, followingUser;
  List<DocumentSnapshot> list = [];
  List<DocumentSnapshot> listEvent = [];
  List<DocumentSnapshot> listNews = [];
  List<DocumentSnapshot> listJob = [];
  List<DocumentSnapshot> listPromotion = [];
  UserModel currentUser;
  List<UserModel> usersList = [];
  List<UserModel> companyList = [];
  String query = '';
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3 = ScrollController();
  ScrollController _scrollController4 = ScrollController();
  ScrollController _scrollController5 = ScrollController();
  ScrollController _scrollController6 = ScrollController();
  List<String> followingUIDs = [];
  //Offset state <-------------------------------------
  double offset = 0.0;
  String currentUserId, followingUserId;
  StreamSubscription<DocumentSnapshot> subscription;
  bool isPrivate = true;

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    if (!mounted) return;
    setState(() {
      followingUserId = uid;
    });
  }

  @override
  void initState() {
    super.initState();
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
    });
    fetchUidBySearchedName(widget.gid);
    _nestedTabController =
        new TabController(length: 3, vsync: this, initialIndex: 0);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _scrollController1 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController1.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _scrollController2 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController2.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  @override
  void dispose() {
    _nestedTabController?.dispose();
    _scrollController?.dispose();
    _scrollController1?.dispose();
    _scrollController2?.dispose();
    _scrollController3?.dispose();
    _scrollController4?.dispose();
    _scrollController5?.dispose();
    _scrollController6?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            // fontWeight: FontWeight.bold,
          ),
          // physics: NeverScrollableScrollPhysics(),
          controller: _nestedTabController,
          indicatorColor: Colors.purpleAccent,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            fontWeight: FontWeight.bold,
          ),
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: 'Projects',
            ),
            Tab(
              text: 'Discussions',
            ),
            Tab(
              text: 'Overview',
            ),
          ],
        ),
        Container(
          color: const Color(0xfff6f6f6),
          height: screenHeight * 0.8,
          child: TabBarView(
            //   physics: NeverScrollableScrollPhysics(),
            controller: _nestedTabController,
            children: <Widget>[
              homeWidget(),
              discussionsWidget(),
              teamInfoPublic(),
              //postImagesWidgetFuture(),
            ],
          ),
        )
      ],
    );
  }

  _showProjectEditDialog(DocumentSnapshot snapshot) {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return StatefulBuilder(builder: ((context, setState) {
            return Column(
              children: [
                SimpleDialog(
                  children: <Widget>[
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.01),
                            child: Text(
                              'Delete project',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        deletePost(snapshot);
                      },
                    ),
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: screenSize.height * 0.015,
                            backgroundColor: Color(snapshot['color']),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.01),
                            child: Text(
                              'Change color',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Select a color',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: Color(
                                    snapshot['color'],
                                  ),
                                  onColorChanged: (Color color) {
                                    FirebaseFirestore.instance
                                        .collection('teams')
                                        .doc(widget.gid)
                                        .collection('departments')
                                        .doc(widget.department.uid)
                                        .collection('projects')
                                        .doc(snapshot['uid'])
                                        .update({'color': color.value})
                                        .then((value) => Navigator.pop(context))
                                        .then(
                                            (value) => Navigator.pop(context));
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // SimpleDialogOption(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Container(
                    //         height: screenSize.height * 0.07,
                    //         child: IconPicker(
                    //           style: TextStyle(
                    //             fontSize: screenSize.height * 0.018,
                    //           ),
                    //           controller: _controller,
                    //           icon: Icon(
                    //             IconData(snapshot.data['projectProfilePhoto'],
                    //                 fontFamily: 'MaterialIcons'),
                    //           ),
                    //           labelText: "Icon",
                    //           enableSearch: true,
                    //           onChanged: (val) {
                    //             var iconDataJson = jsonDecode(val);
                    //             IconData icon = IconData(
                    //               iconDataJson['codePoint'],
                    //             );
                    //             Icon(icon);
                    //             Firestore.instance
                    //                 .collection('teams')
                    //                 .document(widget.gid)
                    //                 .collection('departments')
                    //                 .document(widget.department.uid)
                    //                 .collection('projects')
                    //                 .document(snapshot.data['uid'])
                    //                 .updateData({
                    //               'projectProfilePhoto': icon.codePoint
                    //             }).then((value) {
                    //               Navigator.pop(context);
                    //               setState(() {
                    //                 _controller.text = '';
                    //               });
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          Icon(Icons.cancel_outlined),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.01),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            );
          }));
        }));
  }

  deletePost(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.team.uid)
        .collection('departments')
        .doc(widget.department.uid)
        .collection('projects')
        .doc(snapshot['uid'])
        // .delete();
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();

        print('project deleted');
      } else {
        return print('not owner');
      }
    });
  }

  Widget homeWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('projects')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          return SizedBox(
            height: screenSize.height * 0.9,
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              // controller: _scrollController,
              //shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectPage(
                                    pColor: snapshot.data.docs[index]
                                        .data()['color'],
                                    pIcon: snapshot.data.docs[index]
                                        .data()['projectProfilePhoto'],
                                    projectName: snapshot.data.docs[index]
                                        .data()['projectName'],
                                    label: widget.department.uid,
                                    projectId:
                                        snapshot.data.docs[index].data()['uid'],
                                    gid: widget.gid,
                                    name: widget.name,
                                    currentUser: widget.currentUser,
                                  )));
                    },
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: screenSize.width * 0.21,
                              height: screenSize.height * 0.13,
                              child: Icon(
                                Icons.assignment_outlined,
                                // IconData(
                                //     snapshot.data.documents[index]
                                //         .data['projectProfilePhoto'],
                                //     fontFamily: 'MaterialIcons'),
                                size: screenSize.height * 0.06,
                                color: Colors.white,
                              ),
                              decoration: ShapeDecoration(
                                color: Color(
                                    snapshot.data.docs[index].data()['color']),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.height * 0.015),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _showProjectEditDialog(
                                    snapshot.data.docs[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: screenSize.height * 0.01),
                                child: Icon(
                                  Icons.more_horiz_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: screenSize.width * 0.28,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data.docs[index].data()['projectName'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        } else {
          return NoContent(
            'No projects',
            'assets/images/briefing.png',
            'Add a project',
            ' by clicking on the + button above',
          );
        }
      }),
    );
  }

  Widget discussionsWidget() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('discussions')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData && snapshot.data.docs.length > 0) {
            return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                //  controller: _scrollController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) =>
                    //  Text(snapshot.data.docs[index]['postId']))
                    ListItemDiscussions(
                      documentSnapshot: snapshot.data.docs[index],
                      index: index,
                      currentuser: widget.currentUser,
                      team: widget.team,
                      gid: widget.gid,
                      name: widget.name,
                      dept: widget.department,
                    )));
          } else {
            return NoContent('No discussions', 'assets/images/discussion.png',
                'If you have something to tell', ' click the + icon above');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      }),
    );
  }

  Widget deptMembersWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('members')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  //   controller: _scrollController,
                  itemCount: snapshot.data.docs.length > 3
                      ? 4
                      : snapshot.data.docs.length,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: screenSize.height * 0.02,
                              backgroundImage: CachedNetworkImageProvider(
                                  snapshot.data.docs[index]
                                      .data()['ownerPhotoUrl']),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.02,
                            ),
                            Text(
                              snapshot.data.docs[index].data()['ownerName'],
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ],
                        ),
                      ))),
              Padding(
                padding:
                    EdgeInsets.only(left: 4, top: screenSize.height * 0.01),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeptMembers(
                                  group: widget.team,
                                  dept: widget.department,
                                  currentuser: currentuser,
                                  gid: widget.gid,
                                  name: widget.name,
                                )));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: screenSize.height * 0.02,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child:
                              Image.asset('assets/images/three-dots-icon.png'),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.02,
                      ),
                      Text(
                        'See all members',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget teamInfoPublic() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenSize.width * 0.02,
        screenSize.height * 0.01,
        screenSize.width * 0.02,
        screenSize.height * 0.01,
      ),
      // controller: _scrollController5,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Members',
              style: TextStyle(
                fontFamily: FontNameDefault,
                //    color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: textHeader(context),
              ),
            ),
            Divider(),
            Container(
              height: screenSize.height * 0.3,
              child: deptMembersWidget(),
            ),
            Text(
              'Description',
              style: TextStyle(
                fontFamily: FontNameDefault,
                //  color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: textHeader(context),
              ),
            ),
            Divider(),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teams')
                  .doc(widget.gid)
                  .collection('departments')
                  .doc(widget.department.uid)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data['description'] != null &&
                    snapshot.data['description'] != '') {
                  return Text(
                    snapshot.data['description'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: textAppTitle(context),
                    ),
                  );
                } else {
                  return Text(
                    'No description',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                      fontSize: textAppTitle(context),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget teamInfoPrivate() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      controller: _scrollController6,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: screenSize.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurple,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.12,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: screenSize.height * 0.07,
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.team.teamProfilePhoto != ''
                              ? CachedNetworkImageProvider(
                                  widget.team.teamProfilePhoto)
                              : AssetImage('assets/images/team_no-image.png'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
              ),
              child: Chip(
                backgroundColor: Colors.white,
                avatar: Icon(Icons.public),
                label: Text(
                  widget.team.teamName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.height * 0.022),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     left: screenSize.width / 30,
            //   ),
            //   child: Chip(
            //     backgroundColor: Colors.white,
            //     avatar: Icon(Icons.location_on),
            //     label: Text(
            //       widget.team.location,
            //       style: TextStyle(
            //           color: Colors.black54,
            //           fontWeight: FontWeight.normal,
            //           fontSize: screenSize.height * 0.022),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       left: screenSize.width / 30, top: screenSize.height * 0.012),
            //   child: Text(
            //     widget.team.description,
            //     style: TextStyle(
            //         fontStyle: FontStyle.italic,
            //         fontSize: screenSize.height * 0.022),
            //   ),
            // ),
            SizedBox(
              height: screenSize.height * 0.1,
            ),
          ],
        ),
      ],
    );
  }

  File imageFile;

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}

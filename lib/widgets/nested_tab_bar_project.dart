import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/subscriber_series.dart';
import 'package:Yujai/models/task.dart';
import 'package:Yujai/models/task_list.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/pages/project_members.dart';
import 'package:Yujai/pages/task_detail.dart';
import 'package:Yujai/widgets/list_discussions_dept.dart';
import 'package:Yujai/widgets/list_discussions_project.dart';
import 'package:Yujai/widgets/list_task_list.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:Yujai/widgets/no_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image/image.dart' as Im;
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/edit_photoUrl.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/group_invite.dart';
import 'package:Yujai/pages/group_post_review.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_post_forum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../style.dart';
import 'list_ad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Yujai/widgets/list_event_forum.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:Yujai/widgets/subscriber_chart.dart';
// import 'package:charts_flutter/flutter.dart' as chart;
// import 'package:fl_chart/fl_chart.dart';
//import 'package:Yujai/pages/group_requests.dart';

class NestedTabBarProject extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final UserModel currentUser;
  final Team team;
  final Department department;
  final Project project;

  final List<Member> memberlist;
  const NestedTabBarProject({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
    this.team,
    this.department,
    this.project,
    this.memberlist,
  });
  @override
  _NestedTabBarProjectState createState() => _NestedTabBarProjectState();
}

class _NestedTabBarProjectState extends State<NestedTabBarProject>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  UserModel currentuser, user, followingUser;
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  UserModel _user = UserModel();
  Team _team = Team();
  UserModel currentUser;
  List<UserModel> usersList = List<UserModel>();
  List<UserModel> companyList = List<UserModel>();
  String query = '';
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3 = ScrollController();
  ScrollController _scrollController4 = ScrollController();
  ScrollController _scrollController5 = ScrollController();
  ScrollController _scrollController6 = ScrollController();
  List<String> followingUIDs = List<String>();
  bool _enabled = true;
  //Offset state <-------------------------------------
  double offset = 0.0;
  String currentUserId, followingUserId;
  StreamSubscription<DocumentSnapshot> subscription;
  bool isPrivate = true;
  Color currentColor = Colors.deepPurple;
  void changeColor(Color color) => setState(() => currentColor = color);
  final _formKey = GlobalKey<FormState>();
  bool valueFirst = false;
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _listNameController = TextEditingController();
  List<String> projectList;
  var _currentProject;
  var _currentList;
  String newTaskId = Uuid().v4();
  String newListId = Uuid().v4();
  bool _isEditingDesc = false;
  // final List<SubscriberSeries> data = [
  //   SubscriberSeries(
  //     year: "2011",
  //     subscribers: 10000000,
  //     barColor: chart.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "2012",
  //     subscribers: 8500000,
  //     barColor: chart.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "2013",
  //     subscribers: 7700000,
  //     barColor: chart.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "2014",
  //     subscribers: 7600000,
  //     barColor: chart.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "2015",
  //     subscribers: 5500000,
  //     barColor: chart.ColorUtil.fromDartColor(Colors.red),
  //   ),
  // ];

  // static final List<String> chartDropdownItems = [
  //   'Last 7 days',
  //   'Last month',
  //   'Last year'
  // ];
  // String actualDropdown = chartDropdownItems[0];
  // int actualChart = 0;
  // List<chart.Series<TaskList, String>> _seriesPieData;
  // List<TaskList> myPieData;
  // _generatePieData(myPieData) {
  //   _seriesPieData = List<chart.Series<TaskList, String>>();
  //   _seriesPieData.add(chart.Series(
  //       labelAccessorFn: (TaskList row, _) => "${row.totalTasks}",
  //       id: 'tasklist',
  //       data: myPieData,
  //       colorFn: (TaskList tasklist, _) =>
  //           chart.ColorUtil.fromDartColor(Colors.grey),
  //       domainFn: (TaskList tasklist, _) => tasklist.listName,
  //       measureFn: (TaskList tasklist, _) => tasklist.totalTasks));
  // }

  // List<chart.Series<TaskList, String>> _seriesData;
  // List<TaskList> myData;
  // _generateData(myData) {
  //   _seriesData = List<chart.Series<TaskList, String>>();
  //   _seriesData.add(chart.Series(
  //       labelAccessorFn: (TaskList row, _) => "${row.totalTasks}",
  //       id: 'tasklist',
  //       data: myData,
  //       colorFn: (TaskList tasklist, _) =>
  //           chart.ColorUtil.fromDartColor(Colors.grey),
  //       domainFn: (TaskList tasklist, _) => tasklist.listName,
  //       measureFn: (TaskList tasklist, _) => tasklist.totalTasks));
  // }

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
      // isPrivate = user.isPrivate;
      print("USER : ${_user.displayName}");
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
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      // physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            // fontWeight: FontWeight.bold,
          ),
          physics: NeverScrollableScrollPhysics(),
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
              text: 'Board',
            ),
            Tab(
              text: 'Discussions',
            ),
            Tab(
              text: 'Overview',
            )
          ],
        ),
        Container(
          color: const Color(0xfff6f6f6),
          height: screenHeight * 0.8,
          child: TabBarView(
            //  physics: NeverScrollableScrollPhysics(),
            controller: _nestedTabController,
            children: <Widget>[
              forumWidget(),
              discussionsWidget(),
              projectInfoPublic(),
            ],
          ),
        )
      ],
    );
  }

  Widget discussionsWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('projects')
          .doc(widget.project.uid)
          .collection('discussions')
          .orderBy('time', descending: true)
          .snapshots(),
      // builder: ((context,
      //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //   if (snapshot.hasData) {
      //     return SizedBox(
      //         height: screenSize.height * 0.9,
      //         child: ListView.builder(
      //             controller: _scrollController,
      //             itemCount: snapshot.data.docs.length,
      //             itemBuilder: ((context, index) => ListItemDiscussions(
      //                 documentSnapshot: snapshot.data.docs[index],
      //                 index: index,
      //                 currentuser: widget.currentUser,
      //                 group: widget.team,
      //                 gid: widget.gid,
      //                 name: widget.name))));
      //   } else {
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   }
      // }),
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
                itemBuilder: ((context, index) => ListItemDiscussionsProject(
                      documentSnapshot: snapshot.data.docs[index],
                      index: index,
                      currentuser: widget.currentUser,
                      team: widget.team,
                      gid: widget.gid,
                      name: widget.name,
                      deptId: widget.department.uid,
                      projectId: widget.project.uid,
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

  Widget forumWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('projects')
          .doc(widget.project.uid)
          .collection('list')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) =>
                  ListItemTaskList(
                    memberlist: widget.memberlist,
                    team: widget.team,
                    department: widget.department,
                    project: widget.project,
                    documentSnapshot: snapshot.data.docs[index],
                    user: widget.currentUser,
                    currentuser: widget.currentUser,
                  ));
        } else {
          return Center(
            child: shimmerPromotion(),
          );
        }
      }),
    );
  }

  Widget teamHome() {
    return ListView(
      children: [
        getTextWidgets(widget.team.department),
      ],
    );
  }

  Widget projectMember() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('projects')
          .doc(widget.project.uid)
          .collection('members')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length > 3
                      ? 4
                      : snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.01),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: screenSize.height * 0.02,
                            backgroundImage: CachedNetworkImageProvider(
                                snapshot.data.docs[index]['ownerPhotoUrl']),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.02,
                          ),
                          Text(
                            snapshot.data.docs[index]['ownerName'],
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectMembers(
                                  group: widget.team,
                                  dept: widget.department,
                                  project: widget.project,
                                  currentuser: currentuser,
                                  gid: widget.gid,
                                  name: widget.name,
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.01),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: screenSize.height * 0.02,
                          backgroundImage:
                              AssetImage('assets/images/three-dots-icon.png'),
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
                  ))
            ],
          );
        } else {
          return Center(
            child: shimmerPromotion(),
          );
        }
      }),
    );
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.002),
                child: chip(items, Colors.grey[600]),
              ))
          .toList(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Department));
      },
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textBody1(context),
          ),
        ),
        leading: checkLabel(label),
      ),
    );
  }

  checkLabel(String label) {
    var screenSize = MediaQuery.of(context).size;
    if (label == 'Marketing') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/marketing.png'),
      );
    } else if (label == 'Sales') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/sales.png'),
      );
    } else if (label == 'Project') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/project.png'),
      );
    } else if (label == 'Designing') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/design.png'),
      );
    } else if (label == 'Production') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/production.png'),
      );
    } else if (label == 'Maintainance') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/maintainance.png'),
      );
    } else if (label == 'Store') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/store.png'),
      );
    } else if (label == 'Procurement') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/procurement.png'),
      );
    } else if (label == 'Quality') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/quality.png'),
      );
    } else if (label == 'Inspection') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/inspection.png'),
      );
    } else if (label == 'Packaging') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/packaging.png'),
      );
    } else if (label == 'Finance') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/finance.png'),
      );
    } else if (label == 'Dispatch') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/dispatch.png'),
      );
    } else if (label == 'Accounts') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/accounts.png'),
      );
    } else if (label == 'Research & Development') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/r&d.png'),
      );
    } else if (label == 'Information Technology') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/it.png'),
      );
    } else if (label == 'Human Resource') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/hr.png'),
      );
    } else if (label == 'Security') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/security.png'),
      );
    } else if (label == 'Administration') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/admin.png'),
      );
    } else if (label == 'Other') {
      return CircleAvatar(
        radius: screenSize.height * 0.02,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/other.png'),
      );
    }
  }

  Widget shimmerPromotion() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController3,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40.0)),
                              width: 60.0,
                              height: 60.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80.0,
                                    height: 12.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 120.0,
                                    height: 12.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0)),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0)),
                      Divider(thickness: 4.0, color: Colors.white)
                    ],
                  ),
                ),
                itemCount: 6,
              ),
              enabled: _enabled,
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
            ),
          ),
        ]));
  }

  Widget projectInfoPublic() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      // physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenSize.width * 0.02,
        screenSize.height * 0.01,
        screenSize.width * 0.02,
        screenSize.height * 0.01,
      ),
      //  controller: _scrollController5,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Members',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textHeader(context),
                  fontWeight: FontWeight.bold),
            ),
            Divider(),
            Container(
              height: screenSize.height * 0.3,
              child: projectMember(),
            ),
            // Text('Description',
            //     style: TextStyle(
            //         fontFamily: FontNameDefault,
            //         fontSize: textHeader(context),
            //         fontWeight: FontWeight.bold)),
            // Divider(),
            // StreamBuilder<DocumentSnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('teams')
            //       .doc(widget.gid)
            //       .collection('departments')
            //       .doc(widget.department.uid)
            //       .collection('projects')
            //       .doc(widget.project.uid)
            //       .snapshots(),
            //   builder: ((context, snapshot) {
            //     if (snapshot.hasData) {
            //       if (_isEditingDesc)
            //         return TextField(
            //           autofocus: true,
            //           controller: _descriptionController,
            //           decoration: InputDecoration(
            //             filled: true,
            //             fillColor: const Color(0xffffffff),
            //           ),
            //           style: TextStyle(
            //             fontFamily: FontNameDefault,
            //             fontSize: textBody1(context),
            //           ),
            //           textInputAction: TextInputAction.next,
            //           keyboardType: TextInputType.multiline,
            //           minLines: 3,
            //           maxLines: 3,
            //           onChanged: (newValue) {
            //             if (_descriptionController.text.isNotEmpty)
            //               FirebaseFirestore.instance
            //                   .collection('teams')
            //                   .doc(widget.team.uid)
            //                   .collection('departments')
            //                   .doc(widget.department.uid)
            //                   .collection('projects')
            //                   .doc(widget.project.uid)
            //                   .update({'description': newValue});
            //           },
            //           onSubmitted: (newValue) {
            //             if (_descriptionController.text.isNotEmpty)
            //               FirebaseFirestore.instance
            //                   .collection('teams')
            //                   .doc(widget.team.uid)
            //                   .collection('departments')
            //                   .doc(widget.department.uid)
            //                   .collection('projects')
            //                   .doc(widget.project.uid)
            //                   .update({'description': newValue});
            //             setState(() {
            //               _isEditingDesc = false;
            //             });
            //           },
            //         );
            //       return InkWell(
            //           onTap: () {
            //             setState(() {
            //               _isEditingDesc = true;
            //             });
            //           },
            //           child: Text(
            //             snapshot.data['description'] != null
            //                 ? snapshot.data['description']
            //                 : '',
            //             style: TextStyle(
            //               fontFamily: FontNameDefault,
            //               fontSize: textBody1(context),
            //             ),
            //           ));
            //     } else {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   }),
            // ),
          ],
        ),
      ],
    );
  }

  File imageFile;
  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);

    return File(selectedImage.path);
  }

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

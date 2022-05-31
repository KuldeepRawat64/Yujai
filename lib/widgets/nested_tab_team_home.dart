import 'package:Yujai/models/team.dart';
import 'package:Yujai/pages/department.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../style.dart';
import 'package:Yujai/widgets/no_content.dart';

class NestedTabBarTeamHome extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final UserModel currentUser;
  final Team team;
  const NestedTabBarTeamHome({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
    this.team,
  });
  @override
  _NestedTabBarTeamHomeState createState() => _NestedTabBarTeamHomeState();
}

class _NestedTabBarTeamHomeState extends State<NestedTabBarTeamHome>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  UserModel currentuser, user, followingUser;
  List<DocumentSnapshot> list = [];
  List<DocumentSnapshot> listEvent = [];
  List<DocumentSnapshot> listNews = [];
  List<DocumentSnapshot> listJob = [];
  List<DocumentSnapshot> listPromotion = [];
  UserModel _user = UserModel();
  Team _team = Team();
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
    // _nestedTabController =
    //     new TabController(length: 3, vsync: this, initialIndex: 0);
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
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        forumWidget(),
      ],
    );
  }

  _showDeptEditDialog(DocumentSnapshot snapshot) {
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
                              'Delete department',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
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
                              title: Text('Select a color',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                  )),
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
                    //             IconData(
                    //                 snapshot.data['departmentProfilePhoto'],
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
                    //                 .document(snapshot.data['uid'])
                    //                 .updateData({
                    //               'departmentProfilePhoto': icon.codePoint
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

  Widget forumWidget() {
    var screenSize = MediaQuery.of(context).size;
    return widget.currentUser.uid == widget.team.currentUserUid
        ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.gid)
                .collection('departments')
                .orderBy('timestamp')
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
                  return SizedBox(
                    height: screenSize.height * 0.86,
                    width: screenSize.width,
                    child: ListView.builder(
                      //    controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DepartmentPage(
                                              dIcon: snapshot.data.docs[index]
                                                  ['departmentProfilePhoto'],
                                              dColor: snapshot.data.docs[index]
                                                  ['color'],
                                              isMember: false,
                                              dId: snapshot.data.docs[index]
                                                  ['uid'],
                                              dName: snapshot.data.docs[index]
                                                  ['departmentName'],
                                              gid: widget.gid,
                                              name: widget.name,
                                              currentUser: widget.currentUser,
                                            )));
                              },
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                tileColor: const Color(0xffffffff),
                                leading: Container(
                                  width: screenSize.width * 0.1,
                                  height: screenSize.height * 0.06,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        screenSize.height * 0.01),
                                    child: Icon(
                                      //  Icons.work_outline,
                                      deserializeIcon(snapshot.data.docs[index]
                                          ['departmentProfilePhoto']),
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: ShapeDecoration(
                                    color: Color(
                                        snapshot.data.docs[index]['color']),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data.docs[index]['departmentName'],
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                                trailing: widget.currentUser.uid ==
                                        widget.team.currentUserUid
                                    ? InkWell(
                                        onTap: () {
                                          _showDeptEditDialog(
                                              snapshot.data.docs[index]);
                                        },
                                        child: Icon(Icons.more_horiz),
                                      )
                                    : Text(''),
                              ),
                            ),
                          )),
                    ),
                  );
                } else {
                  return _team != null &&
                          _team.currentUserUid == currentuser.uid
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.25),
                          child: NoContent(
                              'No departments',
                              'assets/images/department.png',
                              'Add a department',
                              ' by clicking on the + icon above'),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.25),
                          child: NoContent('No departments',
                              'assets/images/department.png', '', ''),
                        );
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            })
            // builder: ((context,
            //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            //   if (snapshot.connectionState == ConnectionState.waiting) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (!snapshot.hasData && snapshot.data.docs.isEmpty) {
            //     return _team != null && _team.currentUserUid == currentuser.uid
            //         ? Padding(
            //             padding: EdgeInsets.only(top: screenSize.height * 0.25),
            //             child: NoContent(
            //                 'No departments',
            //                 'assets/images/department.png',
            //                 'Add a department',
            //                 ' by clicking on the + icon above'),
            //           )
            //         : Padding(
            //             padding: EdgeInsets.only(top: screenSize.height * 0.25),
            //             child: NoContent(
            //                 'No departments', 'assets/images/department.png', '', ''),
            //           );
            //   }
            //   return SizedBox(
            //     height: screenSize.height * 0.86,
            //     child: ListView.builder(
            //       //    controller: _scrollController,
            //       shrinkWrap: true,
            //       itemCount: snapshot.data.docs.length,
            //       itemBuilder: ((context, index) => Padding(
            //             padding:
            //                 const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => DepartmentPage(
            //                               dIcon: snapshot.data.docs[index]
            //                                   ['departmentProfilePhoto'],
            //                               dColor: snapshot.data.docs[index]['color'],
            //                               isMember: false,
            //                               dId: snapshot.data.docs[index]['uid'],
            //                               dName: snapshot.data.docs[index]
            //                                   ['departmentName'],
            //                               gid: widget.gid,
            //                               name: widget.name,
            //                               currentUser: widget.currentUser,
            //                             )));
            //               },
            //               child: ListTile(
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(12.0),
            //                 ),
            //                 tileColor: const Color(0xffffffff),
            //                 leading: Container(
            //                   width: screenSize.width * 0.1,
            //                   height: screenSize.height * 0.06,
            //                   child: Padding(
            //                     padding: EdgeInsets.all(screenSize.height * 0.01),
            //                     child: Icon(
            //                       //  Icons.work_outline,
            //                       deserializeIcon(snapshot.data.docs[index]
            //                           ['departmentProfilePhoto']),
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                   decoration: ShapeDecoration(
            //                     color: Color(snapshot.data.docs[index]['color']),
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(8.0),
            //                     ),
            //                   ),
            //                 ),
            //                 title: Text(
            //                   snapshot.data.docs[index]['departmentName'],
            //                   style: TextStyle(
            //                     fontFamily: FontNameDefault,
            //                     fontSize: textSubTitle(context),
            //                   ),
            //                 ),
            //                 trailing: widget.currentUser.uid ==
            //                         widget.team.currentUserUid
            //                     ? InkWell(
            //                         onTap: () {
            //                           _showDeptEditDialog(snapshot.data.docs[index]);
            //                         },
            //                         child: Icon(Icons.more_horiz),
            //                       )
            //                     : Container(),
            //               ),
            //             ),
            //           )),
            //     ),
            //   );
            // }),
            )
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.gid)
                .collection('departments')
                .where('members',
                    arrayContainsAny: [widget.currentUser.uid]).snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data.docs.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.25),
                    child: NoContent(
                        'No departments',
                        'assets/images/picture.png',
                        'Departments in which you are a member will appear here',
                        ''),
                  );
                }
                return SizedBox(
                  height: screenSize.height * 0.86,
                  child: ListView.builder(
                    //    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: ((context, index) => Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DepartmentPage(
                                            dIcon: snapshot.data.docs[index]
                                                ['departmentProfilePhoto'],
                                            dColor: snapshot.data.docs[index]
                                                ['color'],
                                            isMember: false,
                                            dId: snapshot.data.docs[index]
                                                ['uid'],
                                            dName: snapshot.data.docs[index]
                                                ['departmentName'],
                                            gid: widget.gid,
                                            name: widget.name,
                                            currentUser: widget.currentUser,
                                          )));
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              tileColor: const Color(0xffffffff),
                              leading: Container(
                                width: screenSize.width * 0.1,
                                height: screenSize.height * 0.06,
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(screenSize.height * 0.01),
                                  child: Icon(
                                    Icons.work_outline,
                                    // IconData(
                                    //     snapshot.data.documents[index]
                                    //         .data['departmentProfilePhoto'],
                                    //     fontFamily: 'MaterialIcons'),
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: ShapeDecoration(
                                  color:
                                      Color(snapshot.data.docs[index]['color']),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              title: Text(
                                snapshot.data.docs[index]['departmentName'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              trailing: widget.currentUser.uid ==
                                      widget.team.currentUserUid
                                  ? InkWell(
                                      onTap: () {
                                        _showDeptEditDialog(
                                            snapshot.data.docs[index]);
                                      },
                                      child: Icon(Icons.more_horiz),
                                    )
                                  : Text(''),
                            ),
                          ),
                        )),
                  ),
                );
              }
            }),
          );
  }

  deletePost(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.team.uid)
        .collection('departments')
        .doc(snapshot['uid'])
        // .delete();
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        Navigator.pop(context);
        print('department deleted');
      } else {
        return print('not owner');
      }
    });
  }
}

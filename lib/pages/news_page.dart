import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/create_group.dart';
import 'package:Yujai/pages/create_team.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/team_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/nested_tab_bar_group.dart';
import 'package:Yujai/widgets/nested_tab_bar_team.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with TickerProviderStateMixin {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  // User _user = User();
  User currentUser;
  List<User> usersList = List<User>();
  List<String> followingUIDs = List<String>();
  List<Group> groupList = List<Group>();
  TabController _tabController;
  ScrollController _scrollController;
  ScrollController _scrollController1;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentUser = user;
        });
      });

      _repository.fetchAllGroups(user).then((list) {
        if (!mounted) return;
        setState(() {
          groupList = list;
        });
      });
      print("USER : ${user.displayName}");
    });
    _tabController = new TabController(length: 1, vsync: this);
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _scrollController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    print("INSIDE BUILD");
    return SafeArea(
      child: currentUser != null
          ? Scaffold(
              backgroundColor: new Color(0xffffffff),
              appBar: currentUser != null &&
                      currentUser.accountType != 'Company'
                  ? AppBar(
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      title: GestureDetector(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: GroupSearch(groupList: groupList));
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                              color: const Color(0xfff6f6f6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width / 11),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showSearch(
                                        context: context,
                                        delegate:
                                            GroupSearch(groupList: groupList));
                                  },
                                  child: Icon(
                                    Icons.search,
                                    size: screenSize.height * 0.04,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.height * 0.025,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showSearch(
                                          context: context,
                                          delegate: GroupSearch(
                                              groupList: groupList));
                                    },
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () {
                                        showSearch(
                                            context: context,
                                            delegate: GroupSearch(
                                                groupList: groupList));
                                      },
                                      // onChanged: (val) {
                                      //   setState(() {
                                      //     _searchTerm = val;
                                      //   });
                                      // },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Search Groups',
                                          hintStyle: TextStyle(
                                              //    fontWeight: FontWeight.bold,
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context))),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : AppBar(
                      elevation: 0.5,
                      backgroundColor: Color(0xffffffff),
                      automaticallyImplyLeading: false,
                      title: Text(
                        'My Teams',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              body: currentUser != null && currentUser.accountType != 'Company'
                  ? ButtonBar(context: context, tabController: _tabController)
                  : postImagesWidget(),
              floatingActionButton:
                  currentUser != null && currentUser.accountType != 'Company'
                      ? FloatingActionButton(
                          child: Icon(
                            Icons.group_add,
                            size: MediaQuery.of(context).size.height * 0.04,
                          ),
                          onPressed: _onButtonPressed,
                        )
                      : FloatingActionButton(
                          child: Icon(
                            Icons.group_add,
                            size: MediaQuery.of(context).size.height * 0.04,
                          ),
                          onPressed: _onButtonPressedCompany,
                        ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _onButtonPressed() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.18,
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     IconButton(
                //       icon: Icon(MdiIcons.closeCircleOutline),
                //       onPressed: () => Navigator.of(context).pop(),
                //     ),
                //   ],
                // ),
                ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text(
                    'Create a Group',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateGroup()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                    ),
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

  void _onButtonPressedCompany() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.18,
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     IconButton(
                //       icon: Icon(MdiIcons.closeCircleOutline),
                //       onPressed: () => Navigator.of(context).pop(),
                //     ),
                //   ],
                // ),
                ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text(
                    'Create a Team',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateTeam()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                    ),
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

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .collection('teams')
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            color: const Color(0xfff6f6f6),
            height: screenSize.height,
            child: ListView.builder(
              controller: _scrollController,
              //shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamPage(
                                    currentUser: currentUser,
                                    isMember: false,
                                    gid: snapshot
                                        .data.documents[index].data['uid'],
                                    name: snapshot
                                        .data.documents[index].data['teamName'],
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: const Color(0xffffffff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            // side: BorderSide(color: Colors.grey[300]),
                          ),
                        ),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: screenSize.height * 0.025,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/team_no-image.png'),
                            ),
                            title: Text(
                              snapshot.data.documents[index].data['teamName'],
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Icon(Icons.work_outline)),
                      ),
                    ),
                  )),
            ),
          );
          //   } else {
          //     return Center(
          //       child: shimmer(),
          //      );
          //      }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}

class ButtonBar extends StatelessWidget {
  const ButtonBar({
    Key key,
    @required this.context,
    @required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final BuildContext context;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              child: NestedTabBarGroup()),
        ],
        controller: _tabController,
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  List<User> userList;
  UserSearch({this.userList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => InstaFriendProfileScreen(
                          uid: suggestionsList[index].uid,
                          name: suggestionsList[index].displayName))));
            },
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(suggestionsList[index].photoUrl),
            ),
            title: Text(suggestionsList[index].displayName),
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => InstaFriendProfileScreen(
                          uid: suggestionsList[index].uid,
                          name: suggestionsList[index].displayName))));
            },
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(suggestionsList[index].photoUrl),
            ),
            title: Text(suggestionsList[index].displayName),
          )),
    );
  }
}

class GroupSearch extends SearchDelegate<String> {
  List<Group> groupList;
  GroupSearch({this.groupList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? groupList
        : groupList.where((p) => p.groupName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => Column(
            children: [
              ListTile(
                onTap: () {
                  //   showResults(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: ((context) => InstaFriendProfileScreen(
                  //             uid: suggestionsList[index].uid,
                  //             name: suggestionsList[index].groupName))));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      suggestionsList[index].groupProfilePhoto != ''
                          ? CachedNetworkImageProvider(
                              suggestionsList[index].groupProfilePhoto)
                          : AssetImage('assets/images/group_no-image.png'),
                ),
                title: Text(suggestionsList[index].groupName),
                trailing: suggestionsList[index].isPrivate == true
                    ? Icon(Icons.lock_outlined)
                    : Icon(Icons.public),
              ),
              Divider()
            ],
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? groupList
        : groupList.where((p) => p.groupName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => Column(
            children: [
              ListTile(
                onTap: () {
                  //   showResults(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: ((context) => InstaFriendProfileScreen(
                  //             uid: suggestionsList[index].uid,
                  //             name: suggestionsList[index].displayName))));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      suggestionsList[index].groupProfilePhoto != ''
                          ? CachedNetworkImageProvider(
                              suggestionsList[index].groupProfilePhoto)
                          : AssetImage('assets/images/group_no-image.png'),
                ),
                title: Text(suggestionsList[index].groupName),
                trailing: suggestionsList[index].isPrivate == true
                    ? Icon(Icons.lock_outlined)
                    : Icon(Icons.public),
              ),
              Divider()
            ],
          )),
    );
  }
}

import 'package:Yujai/models/event.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/search_data.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_event.dart';
import 'package:Yujai/widgets/list_job.dart';
import 'package:Yujai/widgets/list_news.dart';
import 'package:Yujai/widgets/list_post.dart';
import 'package:Yujai/widgets/list_promotion.dart';
import 'package:Yujai/widgets/nested_tab_bar.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../style.dart';

class SearchTabs extends StatefulWidget {
  @override
  _SearchTabsState createState() => _SearchTabsState();
}

class _SearchTabsState extends State<SearchTabs> with TickerProviderStateMixin {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();
  List<User> companyList = List<User>();
  List<DocumentSnapshot> resultList = List<DocumentSnapshot>();
  List<User> suggestionsList = List<User>();
  List<User> suggestionsListCompany = List<User>();
  List<DocumentSnapshot> suggestions = List<DocumentSnapshot>();
  List<String> followingUIDs = List<String>();
  TabController _tabController;
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;
  bool _enabled = true;
  String _searchTerm = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentUser = user;
        });
      });
      // print("USER : ${user.displayName}");
      // _repository.retrievePosts(user).then((updatedList) {
      //   if (!mounted) return;
      //   setState(() {
      //     list = updatedList;
      //   });
      // });
      // _repository.fetchAllUsers(user).then((list) {
      //   if (!mounted) return;
      //   setState(() {
      //     usersList = list;
      //   });
      // });
      // _repository.fetchAllCompanies(user).then((list) {
      //   if (!mounted) return;
      //   setState(() {
      //     companyList = list;
      //   });
      // });
    });
    _tabController = new TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchTerm = '';
          resultList = suggestions;
        });
      } else {
        setState(() {
          _searchTerm = _filter.text;
        });
      }
    });

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    print("INSIDE BUILD");
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: new Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: new Color(0xffffffff),
          bottom: TabBar(
            //   labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            unselectedLabelStyle: TextStyle(
              fontSize: textSubTitle(context),
              //    fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            controller: _tabController,
            indicatorColor: Colors.purpleAccent,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textSubTitle(context),
              //    fontWeight: FontWeight.bold,
            ),
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Events',
                ),
              ),
              Tab(
                child: Text(
                  'Posts',
                ),
              ),
              Tab(
                child: Text(
                  'Articles',
                ),
              ),
              Tab(
                child: Text(
                  'Applications',
                ),
              ),
              Tab(
                child: Text(
                  'Companies',
                ),
              ),
              Tab(
                child: Text(
                  'Jobs',
                ),
              ),
              Tab(
                child: Text(
                  'Users',
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: screenSize.height * 0.045,
              color: Colors.black54,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          automaticallyImplyLeading: false,
          title: Container(
            height: screenSize.height * 0.065,
            decoration: ShapeDecoration(
              color: const Color(0xFFf6f6f6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width / 11),
              child: TextField(
                controller: _filter,
                style: TextStyle(
                    fontFamily: FontNameDefault, fontSize: textBody1(context)),
                onChanged: (val) {
                  setState(() {
                    _searchTerm = val;
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    _searchTerm = _filter.text;
                  });
                },
                onSubmitted: (val) {
                  setState(() {
                    _searchTerm = val;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 12.0),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search...',
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _searchTerm.isNotEmpty
                ? eventSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  ),
            _searchTerm.isNotEmpty
                ? postSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  ),
            _searchTerm.isNotEmpty
                ? articleSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  ),
            _searchTerm.isNotEmpty
                ? promoSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  ),
            _searchTerm.isNotEmpty
                ? companiesSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  ),
            _searchTerm.isNotEmpty
                ? jobSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  ),
            _searchTerm.isNotEmpty
                ? usersSearch()
                : Center(
                    child: Icon(
                      Icons.search,
                      size: screenSize.height * 0.15,
                      color: Colors.black54,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget postSearch() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: snapshot.data.documents[index].reference
                      .collection('posts')
                      .snapshots(),
                  builder: ((context, snapshotResult) {
                    if (snapshot.data != null && !snapshotResult.hasData) {
                      return Container();
                    } else {
                      if (_searchTerm.isNotEmpty) {
                        List<DocumentSnapshot> tempList =
                            List<DocumentSnapshot>();
                        for (int i = 0;
                            i < snapshotResult.data.documents.length;
                            i++) {
                          if (snapshotResult.data.documents[i].data['caption']
                              .toString()
                              .startsWith(_searchTerm)) {
                            tempList.add(snapshotResult.data.documents[i]);
                          }
                        }
                        resultList = tempList;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultList.length,
                        itemBuilder: ((context, index) => resultList.length > 0
                            ? ListItemPost(
                                documentSnapshot: resultList[index],
                                index: index,
                                currentuser: _user,
                              )
                            : Container()),
                      );
                    }
                  }),
                );
              }),
            );
          }
        }));
  }

  Widget eventSearch() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: snapshot.data.documents[index].reference
                      .collection('events')
                      .snapshots(),
                  builder: ((context, snapshotEvents) {
                    if (snapshot.data != null && !snapshotEvents.hasData) {
                      return Container();
                    } else {
                      if (_searchTerm.isNotEmpty) {
                        List<DocumentSnapshot> tempList =
                            List<DocumentSnapshot>();
                        for (int i = 0;
                            i < snapshotEvents.data.documents.length;
                            i++) {
                          if (snapshotEvents.data.documents[i].data['caption']
                              .toString()
                              .startsWith(_searchTerm)) {
                            tempList.add(snapshotEvents.data.documents[i]);
                          }
                        }
                        resultList = tempList;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultList.length,
                        itemBuilder: ((context, index) => resultList.length > 0
                            ? ListItemEvent(
                                documentSnapshot: resultList[index],
                                index: index,
                                user: _user,
                              )
                            : Text('No data')),
                      );
                    }
                  }),
                );
              }),
            );
          }
        }));
  }

  Widget promoSearch() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: snapshot.data.documents[index].reference
                      .collection('promotion')
                      .snapshots(),
                  builder: ((context, snapshotResult) {
                    if (snapshot.data != null && !snapshotResult.hasData) {
                      return Container();
                    } else {
                      if (_searchTerm.isNotEmpty) {
                        List<DocumentSnapshot> tempList =
                            List<DocumentSnapshot>();
                        for (int i = 0;
                            i < snapshotResult.data.documents.length;
                            i++) {
                          if (snapshotResult.data.documents[i].data['caption']
                              .toString()
                              .startsWith(_searchTerm)) {
                            tempList.add(snapshotResult.data.documents[i]);
                          }
                        }
                        resultList = tempList;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultList.length,
                        itemBuilder: ((context, index) => resultList.length > 0
                            ? ListItemPromotion(
                                documentSnapshot: resultList[index],
                                index: index,
                                currentuser: _user,
                              )
                            : Container()),
                      );
                    }
                  }),
                );
              }),
            );
          }
        }));
  }

  Widget articleSearch() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: snapshot.data.documents[index].reference
                      .collection('news')
                      .snapshots(),
                  builder: ((context, snapshotResult) {
                    if (snapshot.data != null && !snapshotResult.hasData) {
                      return Container();
                    } else {
                      if (_searchTerm.isNotEmpty) {
                        List<DocumentSnapshot> tempList =
                            List<DocumentSnapshot>();
                        for (int i = 0;
                            i < snapshotResult.data.documents.length;
                            i++) {
                          if (snapshotResult.data.documents[i].data['caption']
                              .toString()
                              .startsWith(_searchTerm)) {
                            tempList.add(snapshotResult.data.documents[i]);
                          }
                        }
                        resultList = tempList;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultList.length,
                        itemBuilder: ((context, index) => resultList.length > 0
                            ? ListItemNews(
                                documentSnapshot: resultList[index],
                                index: index,
                                currentuser: _user,
                              )
                            : Container()),
                      );
                    }
                  }),
                );
              }),
            );
          }
        }));
  }

  Widget companiesSearch() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .where('accountType', isEqualTo: 'Company')
            .snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (_searchTerm.isNotEmpty) {
              List<DocumentSnapshot> tempList = List<DocumentSnapshot>();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                if (snapshot.data.documents[i].data['displayName']
                    .toString()
                    .startsWith(_searchTerm)) {
                  tempList.add(snapshot.data.documents[i]);
                }
              }
              resultList = tempList;
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: resultList.length,
              itemBuilder: ((context, index) => resultList.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.grey[300])),
                        ),
                        child: ListTile(
                          onTap: () {
                            //   showResults(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        InstaFriendProfileScreen(
                                            uid: resultList[index].data['uid'],
                                            name: resultList[index]
                                                .data['displayName']))));
                          },
                          leading: Container(
                            decoration: ShapeDecoration(
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.height * 0.01)),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenSize.height * 0.012),
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    resultList[index].data['photoUrl']),
                              ),
                            ),
                          ),
                          title: Text(
                            resultList[index].data['displayName'],
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                          subtitle: Text(
                            resultList[index].data['location'].isNotEmpty
                                ? resultList[index].data['location'].length > 10
                                    ? resultList[index]
                                            .data['location']
                                            .contains('Mumbai')
                                        ? 'Mumbai'
                                        : 'India'
                                    : resultList[index].data['location']
                                : '',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()),
            );
          }
        }));
  }

  checkLabel(String type) {
    var screenSize = MediaQuery.of(context).size;
    if (type == 'Student') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey[300]),
          ),
          avatar: Icon(
            Icons.school_outlined,
            color: Colors.black54,
          ),
          backgroundColor: Colors.white,
          label: Text(
            type,
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
            ),
          ),
        ),
      );
    } else if (type == 'Military') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey[300]),
          ),
          avatar: Icon(
            Icons.military_tech_outlined,
            color: Colors.black54,
          ),
          backgroundColor: Colors.white,
          label: Text(
            type,
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey[300]),
          ),
          avatar: Icon(
            Icons.work_outline,
            color: Colors.black54,
          ),
          backgroundColor: Colors.white,
          label: Text(
            type,
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
            ),
          ),
        ),
      );
    }
  }

  checkPrivacy(bool isPrivate) {
    var screenSize = MediaQuery.of(context).size;
    if (isPrivate) {
      return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey[300]),
          ),
          avatar: Icon(
            Icons.lock_outline,
            color: Colors.black54,
          ),
          backgroundColor: Colors.white,
          label: Text(
            'Private',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey[300]),
          ),
          avatar: Icon(
            Icons.public_outlined,
            color: Colors.black54,
          ),
          backgroundColor: Colors.white,
          label: Text(
            'Public',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
            ),
          ),
        ),
      );
    }
  }

  Widget usersSearch() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').where('accountType',
            whereIn: ['Professional', 'Military', 'Student']).snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (_searchTerm.isNotEmpty) {
              List<DocumentSnapshot> tempList = List<DocumentSnapshot>();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                if (snapshot.data.documents[i].data['displayName']
                    .toString()
                    .startsWith(_searchTerm)) {
                  tempList.add(snapshot.data.documents[i]);
                }
              }
              resultList = tempList;
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: resultList.length,
              itemBuilder: ((context, index) => resultList.length > 0
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstaFriendProfileScreen(
                                    uid: resultList[index].data['uid'],
                                    name: resultList[index]
                                        .data['displayName'])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Container(
                          decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(color: Colors.grey[300]))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Container(
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  resultList[index]
                                                      .data['photoUrl'])),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(resultList[index].data['displayName'],
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textSubTitle(context))),
                                ]),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  checkLabel(
                                      resultList[index].data['accountType']),
                                  checkPrivacy(
                                      resultList[index].data['isPrivate']),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(resultList[index].data['location'],
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container()),
            );
          }
        }));
  }

  Widget jobSearch() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: snapshot.data.documents[index].reference
                      .collection('jobs')
                      .snapshots(),
                  builder: ((context, snapshotResult) {
                    if (snapshot.data != null && !snapshotResult.hasData) {
                      return Container();
                    } else {
                      if (_searchTerm.isNotEmpty) {
                        List<DocumentSnapshot> tempList =
                            List<DocumentSnapshot>();
                        for (int i = 0;
                            i < snapshotResult.data.documents.length;
                            i++) {
                          if (snapshotResult.data.documents[i].data['caption']
                              .toString()
                              .startsWith(_searchTerm)) {
                            tempList.add(snapshotResult.data.documents[i]);
                          }
                        }
                        resultList = tempList;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultList.length,
                        itemBuilder: ((context, index) => resultList.length > 0
                            ? ListItemJob(
                                documentSnapshot: resultList[index],
                                index: index,
                                currentuser: _user,
                              )
                            : Container()),
                      );
                    }
                  }),
                );
              }),
            );
          }
        }));
  }
}

class ButtonBarInspect extends StatelessWidget {
  const ButtonBarInspect({
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
      height: MediaQuery.of(context).size.height * 0.88,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              child: NestedTabBar()),
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

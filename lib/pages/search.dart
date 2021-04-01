import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/search_data.dart';
import 'package:Yujai/pages/search_tabs.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/nested_tab_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../style.dart';

class InstaSearchScreen extends StatefulWidget {
  @override
  _InstaSearchScreenState createState() => _InstaSearchScreenState();
}

class _InstaSearchScreenState extends State<InstaSearchScreen>
    with TickerProviderStateMixin {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();
  List<String> followingUIDs = List<String>();
  TabController _tabController;
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;

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
      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          list = updatedList;
        });
      });
      _repository.fetchAllUsers(user).then((list) {
        if (!mounted) return;
        setState(() {
          usersList = list;
        });
      });
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
        backgroundColor: new Color(0xffffffff),
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          //   centerTitle: true,
          backgroundColor: Color(0xffffffff),
          title: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchTabs()));
            },
            child: Container(
              decoration: ShapeDecoration(
               color:const Color(0xFFf6f6f6),
                shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //   color: Colors.grey[300],
                    // ),
                    borderRadius: BorderRadius.circular(60.0)),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width / 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchTabs()));
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchTabs()));
                        },
                        child: TextField(
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context)),
                          readOnly: true,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchTabs()));
                          },
                          // onChanged: (val) {
                          //   setState(() {
                          //     _searchTerm = val;
                          //   });
                          // },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search...',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: ButtonBarInspect(context: context, tabController: _tabController),
      ),
    );
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
      height: MediaQuery.of(context).size.height,
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

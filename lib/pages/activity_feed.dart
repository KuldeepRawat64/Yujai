import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/search_tabs.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/nested_tab_bar_job.dart';
import 'package:Yujai/widgets/nested_tab_bar_promotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  var _repository = Repository();
  List<DocumentSnapshot> list = [];
  UserModel _user = UserModel();
  UserModel currentUser;
  List<UserModel> usersList = [];
  List<String> followingUIDs = [];
  TabController _tabController;
  List<UserModel> companyList = [];
  ScrollController _scrollController;
  ScrollController _scrollController1;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoURL;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentUser = user;
        });
      });

      print("USER : ${user.displayName}");

      _repository.fetchAllCompanies(user).then((list) {
        if (!mounted) return;
        setState(() {
          companyList = list;
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
    _scrollController = ScrollController()
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
    super.dispose();
  }

  int checkUserType() {
    if (currentUser.accountType == 'Company') {
      return 3;
    } else {
      return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    //  currentUser != null ? checkForCompanyAccount(currentUser) : null;
    var screenSize = MediaQuery.of(context).size;
    print("INSIDE BUILD");
    return SafeArea(
      child: currentUser == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: new Color(0xffffffff),
              appBar: AppBar(
                elevation: 0.5,
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.white,
                title: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchTabs(
                              index: checkUserType() ?? 0,
                            )));
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                        color: const Color(0xFFf6f6f6),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchTabs(
                                        index: checkUserType() ?? 0,
                                      )));
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
                                    builder: (context) => SearchTabs(
                                          index: checkUserType() ?? 0,
                                        )));
                              },
                              child: TextField(
                                readOnly: true,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SearchTabs(
                                            index: checkUserType() ?? 0,
                                          )));
                                },
                                // onChanged: (val) {
                                //   setState(() {
                                //     _searchTerm = val;
                                //   });
                                // },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
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
              ),
              body: currentUser.accountType == 'Company'
                  ? ButtonBarWorkApplication(
                      context: context, tabController: _tabController)
                  : ButtonBarJob(
                      context: context, tabController: _tabController),
            ),
    );
  }
}

class ButtonBarJob extends StatelessWidget {
  const ButtonBarJob({
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
              child: NestedTabBarJob()),
        ],
        controller: _tabController,
      ),
    );
  }
}

class ButtonBarWorkApplication extends StatelessWidget {
  const ButtonBarWorkApplication({
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
              child: NetstedTabbarWorkApplication()),
        ],
        controller: _tabController,
      ),
    );
  }
}

// class DataSearch extends SearchDelegate<String> {
//   List<User> userList;
//   DataSearch({this.userList});

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? userList
//         : userList.where((p) => p.displayName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => ListTile(
//             onTap: () {
//               //   showResults(context);
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: ((context) => FriendProfileScreen(
//                           uid: suggestionsList[index].uid,
//                           name: suggestionsList[index].displayName))));
//             },
//             leading: CircleAvatar(
//               backgroundImage:
//                   CachedNetworkImageProvider(suggestionsList[index].photoUrl),
//             ),
//             title: Text(suggestionsList[index].displayName),
//           )),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? userList
//         : userList.where((p) => p.displayName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => ListTile(
//             onTap: () {
//               //   showResults(context);
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: ((context) => FriendProfileScreen(
//                           uid: suggestionsList[index].uid,
//                           name: suggestionsList[index].displayName))));
//             },
//             leading: CircleAvatar(
//               backgroundImage:
//                   CachedNetworkImageProvider(suggestionsList[index].photoUrl),
//             ),
//             title: Text(suggestionsList[index].displayName),
//           )),
//     );
//   }
// }

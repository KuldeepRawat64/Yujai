// import 'package:Yujai/models/user.dart';
// import 'package:Yujai/resources/repository.dart';
// import 'package:Yujai/widgets/list_event.dart';
// import 'package:Yujai/widgets/list_job.dart';
// import 'package:Yujai/widgets/list_news.dart';
// import 'package:Yujai/widgets/list_post.dart';
// import 'package:Yujai/widgets/list_promotion.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// import '../style.dart';

// class SearchData extends StatefulWidget {
//   SearchData({Key key}) : super(key: key);

//   @override
//   _SearchDataState createState() => _SearchDataState();
// }

// class _SearchDataState extends State<SearchData> {
//   var _repository = Repository();
//   List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
//   List<DocumentSnapshot> list = List<DocumentSnapshot>();
//   List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
//   List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
//   List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
//   UserModel _user = UserModel();
//   UserModel currentUser;
//   List<UserModel> usersList = List<UserModel>();
//   UserModel currentuser, user, followingUser;
//   List<String> followingUIDs = List<String>();

//   @override
//   void initState() {
//     super.initState();
//     _repository.getCurrentUser().then((user) {
//       _user.uid = user.uid;
//       _user.displayName = user.displayName;
//       _user.photoUrl = user.photoURL;
//       _repository.fetchUserDetailsById(user.uid).then((user) {
//         if (!mounted) return;
//         setState(() {
//           currentUser = user;
//         });
//       });
//       print("USER : ${user.displayName}");
//       _repository.retrievePosts(user).then((updatedList) {
//         if (!mounted) return;
//         setState(() {
//           list = updatedList;
//         });
//       });
//       _repository.retrieveEvents(user).then((updatedList) {
//         if (!mounted) return;
//         setState(() {
//           listEvent = updatedList;
//         });
//       });

//       _repository.retrieveNews(user).then((updatedList) {
//         if (!mounted) return;
//         setState(() {
//           listNews = updatedList;
//         });
//       });
//       _repository.retrievePromotion(user).then((updatedList) {
//         if (!mounted) return;
//         setState(() {
//           listPromotion = updatedList;
//         });
//         _repository.retrieveJobs(user).then((updatedList) {
//           if (!mounted) return;
//           setState(() {
//             listJob = updatedList;
//           });
//         });
//       });
//       _repository.fetchAllUsers(user).then((list) {
//         if (!mounted) return;
//         setState(() {
//           usersList = list;
//         });
//       });
//     });
//   }

//   void fetchFeed() async {
//     User currentUser = await _repository.getCurrentUser();
//     UserModel user = await _repository.fetchUserDetailsById(currentUser.uid);
//     if (!mounted) return;
//     setState(() {
//       this.currentuser = user;
//     });

//     followingUIDs = await _repository.fetchFollowingUids(currentUser);

//     for (var i = 0; i < followingUIDs.length; i++) {
//       print("DSDASDASD : ${followingUIDs[i]}");
//       // _future = _repository.retrievePostByUID(followingUIDs[i]);
//       this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
//       print("user : ${this.user.uid}");
//       usersList.add(this.user);
//       print("USERSLIST : ${usersList.length}");

//       for (var i = 0; i < usersList.length; i++) {
//         if (!mounted) return;
//         setState(() {
//           followingUser = usersList[i];
//           print("FOLLOWING USER : ${followingUser.uid}");
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: new Color(0xffffffff),
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(
//             'Search',
//             style: TextStyle(
//               fontFamily: FontNameDefault,
//               fontSize: textAppTitle(context),
//               color: Colors.black54,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: Colors.white,
//           //  centerTitle: true,
//           leading: IconButton(
//             icon: Icon(
//               Icons.keyboard_arrow_left,
//               color: Colors.black54,
//               size: screenSize.height * 0.045,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: Wrap(
//           children: [
//             InkWell(
//               onTap: () {
//                 showSearch(
//                     context: context,
//                     delegate: PostSearch(
//                         postList: list, user: _user, currentUser: _user));
//               },
//               child: ListTile(
//                 leading: Icon(
//                   Icons.photo_outlined,
//                 ),
//                 title: Text(
//                   'Posts',
//                   style: TextStyle(
//                     fontFamily: FontNameDefault,
//                     fontSize: textSubTitle(context),
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 showSearch(
//                     context: context,
//                     delegate: EventSearch(
//                         postList: listEvent, user: _user, currentUser: _user));
//               },
//               child: ListTile(
//                 leading: Icon(
//                   Icons.event_outlined,
//                 ),
//                 title: Text(
//                   'Events',
//                   style: TextStyle(
//                     fontFamily: FontNameDefault,
//                     fontSize: textSubTitle(context),
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 showSearch(
//                     context: context,
//                     delegate: PromotionSearch(
//                         postList: listPromotion,
//                         user: _user,
//                         currentUser: _user));
//               },
//               child: ListTile(
//                 leading: Icon(
//                   Icons.group_work_outlined,
//                 ),
//                 title: Text(
//                   'Work Applications',
//                   style: TextStyle(
//                     fontFamily: FontNameDefault,
//                     fontSize: textSubTitle(context),
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 showSearch(
//                     context: context,
//                     delegate: NewsSearch(
//                         postList: listNews, user: _user, currentUser: _user));
//               },
//               child: ListTile(
//                 leading: Icon(
//                   MdiIcons.newspaperVariantOutline,
//                 ),
//                 title: Text(
//                   'Articles',
//                   style: TextStyle(
//                     fontFamily: FontNameDefault,
//                     fontSize: textSubTitle(context),
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 showSearch(
//                     context: context,
//                     delegate: JobsSearch(
//                         postList: listJob, user: _user, currentUser: _user));
//               },
//               child: ListTile(
//                 leading: Icon(Icons.work_outline),
//                 title: Text(
//                   'Jobs',
//                   style: TextStyle(
//                     fontFamily: FontNameDefault,
//                     fontSize: textSubTitle(context),
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//             Divider(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EventSearch extends SearchDelegate<String> {
//   List<DocumentSnapshot> postList;
//   User user, currentUser;
//   EventSearch({this.postList, this.user, this.currentUser});

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
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemEvent(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemEvent(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }
// }

// class PostSearch extends SearchDelegate<String> {
//   List<DocumentSnapshot> postList;
//   User user, currentUser;
//   PostSearch({this.postList, this.user, this.currentUser});

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
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemPost(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemPost(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }
// }

// class NewsSearch extends SearchDelegate<String> {
//   List<DocumentSnapshot> postList;
//   User user, currentUser;
//   NewsSearch({this.postList, this.user, this.currentUser});

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
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemNews(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemNews(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }
// }

// class PromotionSearch extends SearchDelegate<String> {
//   List<DocumentSnapshot> postList;
//   User user, currentUser;
//   PromotionSearch({this.postList, this.user, this.currentUser});

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
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemPromotion(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemPromotion(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }
// }

// class JobsSearch extends SearchDelegate<String> {
//   List<DocumentSnapshot> postList;
//   User user, currentUser;
//   JobsSearch({this.postList, this.user, this.currentUser});

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
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemJob(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? postList
//         : postList.where((p) => p.data['caption'].startsWith(query)).toList();
//     return ListView.builder(
//         itemCount: suggestionsList.length,
//         itemBuilder: ((context, index) => ListItemJob(
//               documentSnapshot: suggestionsList[index],
//               index: index,
//               currentuser: currentUser,
//               user: user,
//             )));
//   }
// }

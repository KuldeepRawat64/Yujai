import 'package:Yujai/resources/users_provider.dart';
import 'package:Yujai/widgets/users_listview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
//   @override
//   _UsersPageState createState() => _UsersPageState();
// }

// class _UsersPageState extends State<UsersPage> with TickerProviderStateMixin {
//   var _repository = Repository();
//   List<DocumentSnapshot> list = List<DocumentSnapshot>();
//   User _user = User();
//   User currentUser;
//   List<User> usersList = List<User>();
//   List<String> followingUIDs = List<String>();
//   TabController _tabController;
//   ScrollController _scrollController;
//   ScrollController _scrollController1 = ScrollController();
//   //Offset state <-------------------------------------
//   double offset = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _repository.getCurrentUser().then((user) {
//       _user.uid = user.uid;
//       _user.displayName = user.displayName;
//       _user.photoUrl = user.photoUrl;
//       _repository.fetchUserDetailsById(user.uid).then((user) {
//         if (!mounted) return;
//         setState(() {
//           currentUser = user;
//         });
//       });
//       print("USER : ${user.displayName}");
//       _repository.fetchAllUsers(user).then((list) {
//         if (!mounted) return;
//         setState(() {
//           usersList = list;
//         });
//       });
//     });
//     _tabController = new TabController(length: 1, vsync: this);
//     _scrollController = ScrollController()
//       ..addListener(() {
//         setState(() {
//           //<----------------
//           offset = _scrollController.offset;
//           //force arefresh so the app bar can be updated
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _tabController?.dispose();
//     _scrollController?.dispose();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => UsersProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Users'),
          ),
          body: Consumer<UsersProvider>(
            builder: (context, usersProvider, _) => UsersListViewWidget(
              usersProvider: usersProvider,
            ),
          ),
        ),
      );

  // @override
  // Widget build(BuildContext context) {
  //   var screenSize = MediaQuery.of(context).size;
  //   print("INSIDE BUILD");
  //   return SafeArea(
  //     child: Scaffold(
  //       backgroundColor: const Color(0xfff6f6f6),
  //       appBar: AppBar(
  //         elevation: 0.5,
  //         leading: IconButton(
  //             icon: Icon(Icons.keyboard_arrow_left,
  //                 color: Colors.black54, size: screenSize.height * 0.045),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }),
  //         automaticallyImplyLeading: false,
  //         //   centerTitle: true,
  //         backgroundColor: const Color(0xffffffff),
  //         title:Text('Users')
  //  GestureDetector(
  //   onTap: () {
  //     showSearch(
  //         context: context, delegate: UserSearch(userList: usersList));
  //   },
  //   child: Container(
  //     decoration: ShapeDecoration(
  //         color: const Color(0xfff6f6f6),
  //         shape: RoundedRectangleBorder(
  //             //  side: BorderSide(color: Colors.grey[300]),
  //             borderRadius: BorderRadius.circular(60.0))),
  //     child: Padding(
  //       padding:
  //           EdgeInsets.symmetric(horizontal: screenSize.width / 11),
  //       child: Row(
  //         //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               showSearch(
  //                   context: context,
  //                   delegate: UserSearch(userList: usersList));
  //             },
  //             child: Icon(
  //               Icons.search,
  //               size: screenSize.height * 0.045,
  //               color: Colors.black54,
  //             ),
  //           ),
  //           SizedBox(
  //             width: screenSize.height * 0.025,
  //           ),
  //           Expanded(
  //             child: GestureDetector(
  //               onTap: () {
  //                 showSearch(
  //                     context: context,
  //                     delegate: UserSearch(userList: usersList));
  //               },
  //               child: TextField(
  //                 style: TextStyle(
  //                     fontSize: textBody1(context),
  //                     fontFamily: FontNameDefault),
  //                 readOnly: true,
  //                 onTap: () {
  //                   showSearch(
  //                       context: context,
  //                       delegate: UserSearch(userList: usersList));
  //                 },
  //                 // onChanged: (val) {
  //                 //   setState(() {
  //                 //     _searchTerm = val;
  //                 //   });
  //                 // },
  //                 decoration: InputDecoration(
  //                   border: InputBorder.none,
  //                   hintText: 'Search Users',
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   ),
  // ),
  //       ),
  //       body: usersListView(),
  //     ),
  //   );
  // }
}
//   checkLabel(String type) {
//     var screenSize = MediaQuery.of(context).size;
//     if (type == 'Student') {
//       return Padding(
//         padding: EdgeInsets.only(left: 8.0),
//         child: Chip(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             //   side: BorderSide(color: Colors.grey[300]),
//           ),
//           avatar: Icon(
//             Icons.school_outlined,
//             color: Colors.black54,
//           ),
//           backgroundColor: const Color(0xfff6f6f6),
//           label: Text(
//             type,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: FontNameDefault,
//               fontSize: textBody1(context),
//               color: Colors.black54,
//             ),
//           ),
//         ),
//       );
//     } else if (type == 'Military') {
//       return Padding(
//         padding: EdgeInsets.only(left: 8.0),
//         child: Chip(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             //   side: BorderSide(color: Colors.grey[300]),
//           ),
//           avatar: Icon(
//             Icons.military_tech_outlined,
//             color: Colors.black54,
//           ),
//           backgroundColor: const Color(0xfff6f6f6),
//           label: Text(
//             type,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: FontNameDefault,
//               fontSize: textBody1(context),
//               color: Colors.black54,
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Padding(
//         padding: EdgeInsets.only(left: 8.0),
//         child: Chip(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             // side: BorderSide(color: Colors.grey[300]),
//           ),
//           avatar: Icon(
//             Icons.work_outline,
//             color: Colors.black54,
//           ),
//           backgroundColor: const Color(0xfff6f6f6),
//           label: Text(
//             type,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: FontNameDefault,
//               fontSize: textBody1(context),
//               color: Colors.black54,
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   checkPrivacy(bool isPrivate) {
//     var screenSize = MediaQuery.of(context).size;
//     if (isPrivate) {
//       return Padding(
//         padding: EdgeInsets.only(right: 8.0),
//         child: Chip(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             //   side: BorderSide(color: Colors.grey[300]),
//           ),
//           avatar: Icon(
//             Icons.lock_outline,
//             color: Colors.black54,
//           ),
//           backgroundColor: const Color(0xfff6f6f6),
//           label: Text(
//             'Private',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: FontNameDefault,
//               fontSize: textBody1(context),
//               color: Colors.black54,
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Padding(
//         padding: EdgeInsets.only(right: 8.0),
//         child: Chip(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             //  side: BorderSide(color: Colors.grey[300]),
//           ),
//           avatar: Icon(
//             Icons.public_outlined,
//             color: Colors.black54,
//           ),
//           backgroundColor: const Color(0xfff6f6f6),
//           label: Text(
//             'Public',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: FontNameDefault,
//               fontSize: textBody1(context),
//               color: Colors.black54,
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   Widget usersListView() {
//     var screenSize = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         SizedBox(
//           height: screenSize.height * 0.01,
//         ),
//         Flexible(
//           child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: 20 / 23,
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 12.0,
//                   crossAxisSpacing: 12.0),
//               controller: _scrollController1,
//               // itemExtent: 100,
//               itemCount: usersList.length,
//               itemBuilder: ((context, index) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => InstaFriendProfileScreen(
//                                 uid: usersList[index].uid,
//                                 name: usersList[index].displayName)));
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                     ),
//                     child: Container(
//                       decoration: ShapeDecoration(
//                           color: const Color(0xffffffff),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             //  side: BorderSide(color: Colors.grey[300]),
//                           )),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 0.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: CircleAvatar(
//                                     radius: screenSize.height * 0.06,
//                                     backgroundImage: CachedNetworkImageProvider(
//                                         usersList[index].photoUrl)),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Column(
//                                 //    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       bottom: 2.0,
//                                     ),
//                                     child: Text(usersList[index].displayName,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontFamily: FontNameDefault,
//                                             fontSize: textSubTitle(context))),
//                                   ),
//                                   usersList[index].designation != ''
//                                       ? Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 2.0,
//                                           ),
//                                           child: Text(
//                                             usersList[index].designation,
//                                             style: TextStyle(
//                                               color: Colors.deepPurple[200],
//                                               fontFamily: FontNameDefault,
//                                               fontSize: textBody1(context),
//                                             ),
//                                           ),
//                                         )
//                                       : Container(),
//                                   usersList[index].accountType != ''
//                                       ? Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 2.0,
//                                           ),
//                                           child: Text(
//                                               usersList[index].accountType,
//                                               style: TextStyle(
//                                                   color: Colors.purple[200],
//                                                   fontFamily: FontNameDefault,
//                                                   fontSize:
//                                                       textBody1(context))))
//                                       : Container(),
//                                   usersList[index].location != ''
//                                       ? Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 2.0,
//                                           ),
//                                           child: Text(usersList[index].location,
//                                               style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontFamily: FontNameDefault,
//                                               )))
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               })),
//         ),
//       ],
//     );
//   }
// }

// class UserSearch extends SearchDelegate<String> {
//   List<User> userList;
//   UserSearch({this.userList});

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
//     checkLabel(String type) {
//       var screenSize = MediaQuery.of(context).size;
//       if (type == 'Student') {
//         return Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.school_outlined,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               type,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       } else if (type == 'Military') {
//         return Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.military_tech_outlined,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               type,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       } else {
//         return Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.work_outline,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               type,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     checkPrivacy(bool isPrivate) {
//       var screenSize = MediaQuery.of(context).size;
//       if (isPrivate) {
//         return Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.lock_outline,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               'Private',
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       } else {
//         return Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.public_outlined,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               'Public',
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     var screenSize = MediaQuery.of(context).size;
//     final suggestionsList = query.isEmpty
//         ? userList
//         : userList.where((p) => p.displayName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => InkWell(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => InstaFriendProfileScreen(
//                           uid: suggestionsList[index].uid,
//                           name: suggestionsList[index].displayName)));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 8.0,
//                 left: 8.0,
//                 right: 8.0,
//               ),
//               child: Container(
//                 decoration: ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         side: BorderSide(color: Colors.grey[300]))),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(children: [
//                         Container(
//                           decoration: ShapeDecoration(
//                             color: Colors.grey[100],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: CircleAvatar(
//                                 backgroundImage: CachedNetworkImageProvider(
//                                     suggestionsList[index].photoUrl)),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                         Text(suggestionsList[index].displayName,
//                             style: TextStyle(
//                                 fontFamily: FontNameDefault,
//                                 fontSize: textSubTitle(context))),
//                       ]),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         checkLabel(suggestionsList[index].accountType),
//                         checkPrivacy(suggestionsList[index].isPrivate),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(suggestionsList[index].location,
//                           style: TextStyle(
//                               fontFamily: FontNameDefault,
//                               fontSize: textBody1(context))),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     checkLabel(String type) {
//       var screenSize = MediaQuery.of(context).size;
//       if (type == 'Student') {
//         return Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.school_outlined,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               type,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       } else if (type == 'Military') {
//         return Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.military_tech_outlined,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               type,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       } else {
//         return Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.work_outline,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               type,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     checkPrivacy(bool isPrivate) {
//       var screenSize = MediaQuery.of(context).size;
//       if (isPrivate) {
//         return Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.lock_outline,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               'Private',
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       } else {
//         return Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: Chip(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//               side: BorderSide(color: Colors.grey[300]),
//             ),
//             avatar: Icon(
//               Icons.public_outlined,
//               color: Colors.black54,
//             ),
//             backgroundColor: Colors.white,
//             label: Text(
//               'Public',
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textBody1(context),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     var screenSize = MediaQuery.of(context).size;
//     final suggestionsList = query.isEmpty
//         ? userList
//         : userList.where((p) => p.displayName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => InkWell(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => InstaFriendProfileScreen(
//                           uid: suggestionsList[index].uid,
//                           name: suggestionsList[index].displayName)));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 8.0,
//                 left: 8.0,
//                 right: 8.0,
//               ),
//               child: Container(
//                 decoration: ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         side: BorderSide(color: Colors.grey[300]))),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(children: [
//                         Container(
//                           decoration: ShapeDecoration(
//                             color: Colors.grey[100],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: CircleAvatar(
//                                 backgroundImage: CachedNetworkImageProvider(
//                                     suggestionsList[index].photoUrl)),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                         Text(suggestionsList[index].displayName,
//                             style: TextStyle(
//                                 fontFamily: FontNameDefault,
//                                 fontSize: textSubTitle(context))),
//                       ]),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         checkLabel(suggestionsList[index].accountType),
//                         checkPrivacy(suggestionsList[index].isPrivate),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(suggestionsList[index].location,
//                           style: TextStyle(
//                               fontFamily: FontNameDefault,
//                               fontSize: textBody1(context))),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )),
//     );
//   }
// }

// class MemberSearch extends SearchDelegate<String> {
//   List<Member> userList;
//   MemberSearch({this.userList});

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
//         : userList.where((p) => p.ownerName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => ListTile(
//             onTap: () {
//               //   showResults(context);
//             },
//             leading: CircleAvatar(
//               backgroundImage: CachedNetworkImageProvider(
//                   suggestionsList[index].ownerPhotoUrl),
//             ),
//             title: Text(
//               suggestionsList[index].ownerName,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textSubTitle(context),
//                 color: Colors.black54,
//               ),
//             ),
//           )),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = query.isEmpty
//         ? userList
//         : userList.where((p) => p.ownerName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => ListTile(
//             onTap: () {
//               //   showResults(context);
//             },
//             leading: CircleAvatar(
//               backgroundImage: CachedNetworkImageProvider(
//                   suggestionsList[index].ownerPhotoUrl),
//             ),
//             title: Text(
//               suggestionsList[index].ownerName,
//               style: TextStyle(
//                 fontFamily: FontNameDefault,
//                 fontSize: textSubTitle(context),
//                 color: Colors.black54,
//               ),
//             ),
//           )),
//     );
//   }
// }

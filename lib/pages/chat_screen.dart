import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/chat_detail_screen.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/app_localizations.dart';
import 'package:Yujai/widgets/date_formatter.dart';
import 'package:Yujai/widgets/list_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _repository = Repository();
  UserModel _user = UserModel();
  List<UserModel> usersList = [];
  List<String> userList;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  //String _senderuid;
  Future<List<DocumentSnapshot>> _future;
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _repository.getCurrentUser().then((user) {
      print("USER : ${user.displayName}");
      _repository.fetchFollowingUsers(user).then((updatedList) {
        setState(() {
          usersList = updatedList;
        });
      });
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

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retreiveUserChatRoom(_user.uid);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
                height: screenSize.height,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) => ListItemChatRoom(
                          documentSnapshot: snapshot.data[index],
                          index: index,
                          user: _user,
                          currentuser: _user,
                        ))));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget chatRoom() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(_user.uid)
          .collection('chatRoom')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: ((context, index) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: snapshot.data.docs[index].reference != null
                    ? snapshot.data.docs[index].reference
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots()
                    : null,
                builder: ((context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshotM) {
                  if (!snapshotM.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xFFffffff),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                //  side: BorderSide(color: Colors.grey[300]),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4.0,
                                        top: 4.0,
                                        bottom: 4.0,
                                        right: 4.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatDetailScreen(
                                                        photoUrl: snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'ownerPhotoUrl'],
                                                        name: snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'ownerName'],
                                                        receiverUid: snapshot
                                                            .data.docs[index]
                                                            .data()['ownerUid'],
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                                .data
                                                                .docs[index]
                                                                .data()[
                                                            'ownerPhotoUrl'])),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                  top: 4.0,
                                                  left: 4.0,
                                                  bottom: 4.0,
                                                )),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          .data()['ownerName'],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontSize: textSubTitle(
                                                            context),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    snapshotM.data.docs[0]
                                                                    .data()[
                                                                'message'] !=
                                                            null
                                                        ? Container(
                                                            width: screenSize
                                                                    .width *
                                                                0.4,
                                                            child: Text(
                                                              snapshotM.data
                                                                      .docs[0]
                                                                      .data()[
                                                                  'message'],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize:
                                                                    textBody1(
                                                                        context),
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          )
                                                        : Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .photo_camera,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                              SizedBox(
                                                                width: 4.0,
                                                              ),
                                                              Text(
                                                                'Photo',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      FontNameDefault,
                                                                  fontSize:
                                                                      textBody1(
                                                                          context),
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                snapshotM.data.docs[0].data()[
                                                            'timestamp'] !=
                                                        null
                                                    ? Text(
                                                        DateFormatter(AppLocalizations.of(
                                                                        context))
                                                                    .getVerboseDateTimeRepresentation(snapshotM
                                                                        .data
                                                                        .docs[0]
                                                                        .data()[
                                                                            'timestamp']
                                                                        .toDate()) !=
                                                                null
                                                            ? DateFormatter(
                                                                    AppLocalizations.of(
                                                                        context))
                                                                .getVerboseDateTimeRepresentation(
                                                                    snapshotM
                                                                        .data
                                                                        .docs[0]
                                                                        .data()[
                                                                            'timestamp']
                                                                        .toDate())
                                                            : '',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          // fontSize: textbody2(
                                                          //     context),
                                                          color: Colors.black54,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )));
                  }
                }),
              );
            }),
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: screenSize.height * 0.045,
              color: Colors.black54,
            ),
          ),
          //   centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Messages',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: chatRoom(),
      ),
    );
  }
}

// class ChatSearch extends SearchDelegate<String> {
//   List<User> usersList;
//   ChatSearch({this.usersList});

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
//     final List<User> suggestionsList = query.isEmpty
//         ? usersList
//         : usersList.where((p) => p.displayName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => Column(
//             children: [
//               ListTile(
//                 onTap: () {
//                   //   showResults(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: ((context) => ChatDetailScreen(
//                                 photoUrl: suggestionsList[index].photoUrl,
//                                 name: suggestionsList[index].displayName,
//                                 receiverUid: suggestionsList[index].uid,
//                               ))));
//                 },
//                 leading: CircleAvatar(
//                   backgroundImage: CachedNetworkImageProvider(
//                       suggestionsList[index].photoUrl),
//                 ),
//                 title: Text(
//                   suggestionsList[index].displayName,
//                   style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.height * 0.018,
//                   ),
//                 ),
//               ),
//               Divider()
//             ],
//           )),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final List<User> suggestionsList = query.isEmpty
//         ? usersList
//         : usersList.where((p) => p.displayName.startsWith(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionsList.length,
//       itemBuilder: ((context, index) => Column(
//             children: [
//               ListTile(
//                 onTap: () {
//                   //   showResults(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: ((context) => ChatDetailScreen(
//                                 photoUrl: suggestionsList[index].photoUrl,
//                                 name: suggestionsList[index].displayName,
//                                 receiverUid: suggestionsList[index].uid,
//                               ))));
//                 },
//                 leading: CircleAvatar(
//                   backgroundImage: CachedNetworkImageProvider(
//                       suggestionsList[index].photoUrl),
//                 ),
//                 title: Text(
//                   suggestionsList[index].displayName,
//                   style: TextStyle(
//                       fontSize: MediaQuery.of(context).size.height * 0.018),
//                 ),
//               ),
//               Divider()
//             ],
//           )),
//     );
//   }
// }

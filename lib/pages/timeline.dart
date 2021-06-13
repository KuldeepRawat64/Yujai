import 'dart:async';
import 'dart:io';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/like.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/article_upload.dart';
import 'package:Yujai/pages/chat_screen.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/event_upload.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/job_upload.dart';
import 'package:Yujai/pages/likes_screen.dart';
import 'package:Yujai/pages/notifications.dart';
import 'package:Yujai/pages/promotion_post.dart';
import 'package:Yujai/pages/search_tabs.dart';
import 'package:Yujai/pages/upload_screen.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/list_event.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/widgets/list_event_home.dart';
import 'package:Yujai/widgets/list_job.dart';
import 'package:Yujai/widgets/new_article_screen.dart';
import 'package:Yujai/widgets/new_event_screen_main.dart';
import 'package:Yujai/widgets/new_job_screen.dart';
import 'package:Yujai/widgets/new_post_main.dart';
import 'package:Yujai/widgets/new_work_screen.dart';
import 'package:Yujai/widgets/no_job.dart';
import 'package:Yujai/widgets/no_news.dart';
import 'package:Yujai/widgets/no_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Yujai/widgets/list_post.dart';
import '../widgets/list_news.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Yujai/pages/search_data.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var _repository = Repository();
  User currentuser, user, followingUser;
  IconData icon;
  Color color;
  List<User> usersList = List<User>();
  List<User> userList = List<User>();
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  List<String> followingUIDs = List<String>();
  User _user = User();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  bool _enabled = true;
  File imageFile;
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3;
  ScrollController _scrollController4 = ScrollController();
  ScrollController _scrollController5 = ScrollController();
  Future<List<DocumentSnapshot>> _eventFuture;
  Future<List<DocumentSnapshot>> _newsFuture;
  Future<List<DocumentSnapshot>> _jobFuture;
  //Offset state <-------------------------------------
  double offset = 0.0;
  @override
  void initState() {
    super.initState();
    fetchFeed();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentuser = user;
        });
      });

      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          list = updatedList;
        });
      });
      _repository.retrieveEvents(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listEvent = updatedList;
        });
      });
      _repository.retrieveNews(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listNews = updatedList;
        });
      });
      _repository.retrieveJobs(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listJob = updatedList;
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
    _scrollController3 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController3.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _scrollController1?.dispose();
    _scrollController2?.dispose();
    _scrollController3?.dispose();
    _scrollController4?.dispose();
    _scrollController5?.dispose();
    super.dispose();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    if (!mounted) return;
    setState(() {
      this.currentuser = user;
    });

    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.uid}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        if (!mounted) return;
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.uid}");
        });
      }
    }
    _future = _repository.fetchFeed(currentUser);
    _eventFuture = _repository.retrieveEvents(currentUser);
    _newsFuture = _repository.retrieveNews(currentUser);
    _jobFuture = _repository.retrieveJobs(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          backgroundColor: new Color(0xffffffff),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => ChatScreen())));
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.message_outlined,
                size: screenSize.height * 0.035,
                color: Colors.black54,
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchTabs(
                        index: 6,
                      )));
            },
            child: Container(
              height: screenSize.height * 0.07,
              decoration: ShapeDecoration(
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0))),
              child: TextFormField(
                enabled: false,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Enter a name",
                  labelStyle: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          //  Text(
          //   'Yujai',
          //   style: TextStyle(
          //     fontFamily: 'Signatra',
          //     color: Colors.black54,
          //     fontSize: screenSize.height * 0.05,
          //   ),
          // ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.notifications_outlined,
                    color: Colors.black54, size: screenSize.height * 0.04),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ActivityFeed()));
                }),
            currentuser != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: screenSize.height * 0.023,
                      child: InkWell(
                        onTap: currentuser.accountType == 'Company'
                            ? _onButtonPressedCompany
                            : _onButtonPressedUser,
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        body: currentuser != null
            ? postImagesWidget()
            : Center(
                child: shimmer(),
              ),
        // floatingActionButton: currentuser != null
        //     ? FloatingActionButton(
        //         heroTag: null,
        //         child: Icon(
        //           Icons.add,
        //           size: MediaQuery.of(context).size.height * 0.04,
        //         ),
        //         onPressed: currentuser.accountType == 'Company'
        //             ? _onButtonPressedCompany
        //             : _onButtonPressedUser,
        //       )
        //     : Text(''),
      ),
    );
  }

  void _onButtonPressedUser() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -18,
                right: 6,
                child: InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.22,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewPostMain(currentUser: currentuser)));
                      },
                      leading: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.black54,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Post a photo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.work_outline,
                        color: Colors.black54,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Upload work application',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child:
                                    NewWorkScreen(currentUser: currentuser)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _onButtonPressedCompany() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -18,
                right: 6,
                child: InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.36,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewPostMain(currentUser: currentuser)));
                      },
                      leading: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.black54,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Photo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.work_outline,
                        color: Colors.black54,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Job',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewJobScreen(currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.article_outlined,
                        color: Colors.black54,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Article',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewArticleScreen(
                                    currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.event_outlined,
                        color: Colors.black54,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Event',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewEventScreenMain(
                                    currentUser: currentuser)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _showImageDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => InstaUploadPhotoScreen(
                                  imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showDialogPromotion() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Proceed',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => Promotion())));
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showImageDialogEvent() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Cover photo',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => EventUpload(
                    //               imageFile: imageFile,
                    //             ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  _showImageDialogArticle() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => Article(
                                  imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showDialogJob() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Proceed',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => JobPost())));
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  Widget shimmer() {
    return Container(
      color: const Color(0xffffffff),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40.0)),
                              width: 40.0,
                              height: 40.0,
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
                                  )
                                ],
                              ),
                            ),
                          ]),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0)),
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.white,
                      ),
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
              highlightColor: Colors.grey[100]),
        ),
      ]),
    );
  }

  Widget shimmerNews() {
    return Container(
      color: const Color(0xffffffff),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Shimmer.fromColors(
                  child: ListView.builder(
                    controller: _scrollController4,
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 5.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0)),
                          Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.white,
                          ),
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
                  highlightColor: Colors.grey[100]),
            ),
          ]),
    );
  }

  Widget shimmerEvent() {
    return Container(
        color: const Color(0xffffffff),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.22,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController5,
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
                      // Container(
                      //   height: 200,
                      //   width: double.infinity,
                      //   color: Colors.grey,
                      // ),
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

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          print("posts : ${snapshot.data.length}");
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data.length != 0
                ? ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) => ListItemPost(
                          documentSnapshot: snapshot.data[index],
                          index: index,
                          user: followingUser,
                          currentuser: currentuser,

                          //  listItem(
                          //       list: snapshot.data,
                          //       index: index,
                          //       user: followingUser,
                          //       currentUser: currentuser,
                        )))
                : ListView(
                    //  mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: screenSize.width / 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Articles',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textHeader(context),
                                  fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   'More',
                            //   style: TextStyle(
                            //       color: Theme.of(context).accentColor,
                            //       fontFamily: FontNameDefault,
                            //       fontSize: textSubTitle(context),
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                      newsImageWidget(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.005,
                          horizontal: screenSize.width / 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Events',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textHeader(context),
                                  fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   'More',
                            //   style: TextStyle(
                            //       color: Theme.of(context).accentColor,
                            //       fontFamily: FontNameDefault,
                            //       fontSize: textSubTitle(context),
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                      eventImagesWidget(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.005,
                          horizontal: screenSize.width / 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jobs',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textHeader(context),
                                  fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   'More',
                            //   style: TextStyle(
                            //       color: Theme.of(context).accentColor,
                            //       fontFamily: FontNameDefault,
                            //       fontSize: textSubTitle(context),
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                      jobImagesWidget(),
                      SizedBox(height: screenSize.height * 0.1)
                    ],
                  );
          } else {
            return Center(
              child: shimmer(),
            );
          }
        } else {
          return Center(
            child: shimmer(),
          );
        }
      }),
    );
  }

  Widget newsImageWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerNews());
          } else {
            if (snapshot.data.length > 0) {
              return SizedBox(
                  height: screenSize.height * 0.5,
                  width: screenSize.width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController1,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: listNews.length,
                            itemBuilder: ((context, index) => ListItemNews(
                                documentSnapshot: listNews[index],
                                index: index,
                                user: _user,
                                currentuser: _user))),
                      ),
                    ],
                  ));
            }
            return Container(
                width: screenSize.width,
                height: screenSize.height * 0.3,
                child: NoNews());
          }
        });
  }

  Widget eventImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerEvent());
          } else {
            if (snapshot.data.length > 0) {
              return SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.3,
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController2,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: listEvent.length,
                            itemBuilder: ((context, index) => ListItemEvent(
                                documentSnapshot: listEvent[index],
                                index: index,
                                user: _user,
                                currentuser: _user))),
                      ),
                    ],
                  ));
            }
            return Container(
                width: screenSize.width,
                height: screenSize.height * 0.3,
                child: NoEvent());
          }
        });
  }

  Widget jobImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _jobFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerEvent());
          } else {
            if (snapshot.data.length > 0) {
              return SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.26,
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController3,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: listJob.length,
                            itemBuilder: ((context, index) => ListItemJob(
                                documentSnapshot: listJob[index],
                                index: index,
                                user: _user,
                                currentuser: _user))),
                      ),
                    ],
                  ));
            }
            return Container(
                width: screenSize.width,
                height: screenSize.height * 0.3,
                child: NoJob());
          }
        });
  }

  Widget listItem(
      {List<DocumentSnapshot> list, User user, User currentUser, int index}) {
    var screenSize = MediaQuery.of(context).size;
    print("dadadadad : ${user.uid}");
    return Card(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => FriendProfileScreen(
                                        uid: list[index].data['ownerUid'],
                                        name: list[index].data['postOwnerName'],
                                      )))).then((value) {
                            fetchFeed();
                            if (!mounted) return;
                            setState(() {
                              _user = _user;
                            });
                          });
                        },
                        child: new CircleAvatar(
                          radius: screenSize.height * 0.03,
                          backgroundImage: CachedNetworkImageProvider(
                              list[index].data['postOwnerPhotoUrl']),
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          FriendProfileScreen(
                                            uid: list[index].data['ownerUid'],
                                            name: list[index]
                                                .data['postOwnerName'],
                                          )))).then((value) {
                                fetchFeed();
                                if (!mounted) return;
                                setState(() {
                                  _user = _user;
                                });
                              });
                            },
                            child: new Text(
                              list[index].data['postOwnerName'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          list[index].data['location'] != null
                              ? new Text(
                                  list[index].data['location'],
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                  new IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: null,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageDetail(
                          image: list[index].data['imgUrl'],
                        )));
              },
              child: CachedNetworkImage(
                filterQuality: FilterQuality.medium,
                fadeInCurve: Curves.easeIn,
                fadeOutCurve: Curves.easeOut,
                imageUrl: list[index].data['imgUrl'],
                placeholder: ((context, s) => Center(
                      child: Container(),
                    )),
                width: screenSize.width,
                height: screenSize.height * 0.4,
                fit: BoxFit.contain,
              ),
            ),
            list[index].data['caption'] != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          // Text(list[index].data['postOwnerName'],
                          //     style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Text(list[index].data['caption']),
                          )
                        ],
                      ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 4.0),
                      //     child: commentWidget(list[index].reference))
                    ],
                  )
                : Container(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          child: _isLiked
                              ? Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: BorderSide(
                                            color: Colors.deepPurple)),
                                    //color: Theme.of(context).accentColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Liked',
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                    ),
                                  ))
                              : Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: BorderSide(
                                            color: Colors.deepPurple)),
                                    //color: Theme.of(context).accentColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Like',
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                    ),
                                  )),
                          onTap: () {
                            if (!_isLiked) {
                              setState(() {
                                _isLiked = true;
                              });
                              // saveLikeValue(_isLiked);
                              postLike(list[index].reference, currentUser);
                              addLikeToActivityFeed(list[index], currentUser);
                            } else {
                              setState(() {
                                _isLiked = false;
                              });
                              //saveLikeValue(_isLiked);
                              postUnlike(list[index].reference, currentUser);
                              removeLikeFromActivityFeed(
                                  list[index], currentUser);
                            }

                            // _repository.checkIfUserLikedOrNot(_user.uid, snapshot.data[index].reference).then((isLiked) {
                            //   print("reef : ${snapshot.data[index].reference.path}");
                            //   if (!isLiked) {
                            //     setState(() {
                            //       icon = Icons.favorite;
                            //       color = Colors.red;
                            //     });
                            //     postLike(snapshot.data[index].reference);
                            //   } else {

                            //     setState(() {
                            //       icon =FontAwesomeIcons.heart;
                            //       color = null;
                            //     });
                            //     postUnlike(snapshot.data[index].reference);
                            //   }
                            // });
                            // updateValues(
                            //     snapshot.data[index].reference);
                          }),
                      new SizedBox(
                        width: 16.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        snapshot: list[index],
                                        followingUser: followingUser,
                                        documentReference:
                                            list[index].reference,
                                        user: currentUser,
                                      ))));
                        },
                        child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(color: Colors.deepPurple)),
                              //color: Theme.of(context).accentColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Comment',
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            )),
                      ),
                      new SizedBox(
                        width: 16.0,
                      ),
                      new Icon(
                        MdiIcons.share,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  // new IconButton(
                  //     icon: Icon(_isBookmarked
                  //         ? MdiIcons.bookmark
                  //         : MdiIcons.bookmarkOutline),
                  //     onPressed: () {
                  //       if (!_isBookmarked) {
                  //         setState(() {
                  //           _isBookmarked = true;
                  //         });
                  //       } else {
                  //         setState(() {
                  //           _isBookmarked = false;
                  //         });
                  //       }
                  //     }),
                ],
              ),
            ),
            FutureBuilder(
              future: _repository.fetchPostLikes(list[index].reference),
              builder: ((context,
                  AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                if (likesSnapshot.hasData) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LikesScreen(
                                    user: currentUser,
                                    documentReference: list[index].reference,
                                  ))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: likesSnapshot.data.length > 1
                          ? Text(
                              "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(likesSnapshot.data.length == 1
                              ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
                              : "0 Likes"),
                    ),
                  );
                } else {
                  return Center(child: Container());
                }
              }),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: commentWidget(list[index].reference, list[index])),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(timeago.format(list[index]['time'].toDate()),
                  style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }

  Widget commentWidget(
      DocumentReference reference, DocumentSnapshot documentSnapshot) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} comments',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            snapshot: documentSnapshot,
                            followingUser: followingUser,
                            documentReference: reference,
                            user: currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: Container());
        }
      }),
    );
  }

  void postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
      //addLikeToActivityFeed();
    });
  }

  void addLikeToActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    bool ownerId = followingUser.uid == _user.uid;
    if (!ownerId) {
      var _feed = Feed(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: 'like',
        ownerPhotoUrl: currentuser.photoUrl,
        imgUrl: snapshot['imgUrl'],
        postId: snapshot['postId'],
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      Firestore.instance
          .collection('users')
          .document(followingUser.uid)
          .collection('items')
          // .document(currentUser.uid)
          // .collection('likes')
          .document(snapshot['postId'])
          .setData(_feed.toMap(_feed))
          .then((value) {
        print('Feed added');
      });
    } else {
      return print('Owner liked');
    }
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference
        .collection("likes")
        .document(currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
      // removeLikeFromActivityFeed();
    });
  }

  void removeLikeFromActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    bool ownerId = followingUser.uid == _user.uid;
    if (!ownerId) {
      Firestore.instance
          .collection('users')
          .document(followingUser.uid)
          .collection('items')
          //.where('postId',isEqualTo:snapshot['postId'])
          // .document(currentuser.uid)
          // .collection('likes')
          .document(snapshot['postId'])
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    } else {
      return print('Owner feed');
    }
  }
}

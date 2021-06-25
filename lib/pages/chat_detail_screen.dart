import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/message.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:image/image.dart' as Im;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:expandable_text/expandable_text.dart';

class ChatDetailScreen extends StatefulWidget {
  final String photoUrl;
  final String name;
  final String receiverUid;

  ChatDetailScreen({this.photoUrl, this.name, this.receiverUid});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  var _formKey = GlobalKey<FormState>();
  String _senderuid;
  TextEditingController _messageController = TextEditingController();
  final _repository = Repository();
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  static UserModel _user, currentuser;
  final ScrollController _scrollController = ScrollController();
  // Keep track of whether a scroll is needed.
  bool _needsScroll = true;
  Timer _timer;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    print("RCID : ${widget.receiverUid}");
    _repository.getCurrentUser().then((user) {
      if (!mounted) return;
      setState(() {
        _senderuid = user.uid;
        user = user;
      });
      _repository.fetchUserDetailsById(_senderuid).then((user) {
        if (!mounted) return;
        setState(() {
          currentuser = user;
          senderPhotoUrl = user.photoUrl;
          senderName = user.displayName;
        });
      });
      _repository.fetchUserDetailsById(widget.receiverUid).then((user) {
        if (!mounted) return;
        setState(() {
          receiverPhotoUrl = user.photoUrl;
          receiverName = user.displayName;
        });
      });

      fetchUidBySearchedName(widget.receiverUid);
    });
  }

  fetchUserDetailsById(String userId) async {
    UserModel user = await _repository.fetchUserDetailsById(widget.receiverUid);
    if (!mounted) return;
    setState(() {
      _user = user;
      print("USER : ${_user.displayName}");
    });
  }

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    fetchUserDetailsById(uid);
    // _future = _repository.retreiveUserPosts(uid);
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      Timer(Duration(milliseconds: 300), () {
        if (_scrollController.hasClients)
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      });
      //  _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //    duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFFf6f6f6),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0.5,
            leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black54,
                  size: screenSize.height * 0.045,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.white,
            title: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: screenSize.height * 0.035,
                  backgroundImage: CachedNetworkImageProvider(widget.photoUrl),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendProfileScreen(
                                    uid: widget.receiverUid,
                                    name: widget.name,
                                  )));
                    },
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: _senderuid == null
                ? Container(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      //       mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(child: chatMessagesListWidget()),
                        // SizedBox(
                        //   height: 5.0,
                        // ),
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor),
                            child: chatInputWidget()),
                        // SizedBox(
                        //   height: 5.0,
                        // )
                      ],
                    ),
                  ),
          )),
    );
  }

  Widget chatInputWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      // color: Color(0xffffffff),
      //height: screenSize.height * 0.1,
      //color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(
                Icons.attachment_rounded,
                color: Colors.black54,
              ),
              onPressed: () {
                _onButtonPressedUser();
              },
              color: Colors.black,
            ),
          ),
          Flexible(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                  fontFamily: FontNameDefault, fontSize: textBody1(context)),
              controller: _messageController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                hintText: "Enter message...",
                labelText: "Message",
              ),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              child: Icon(
                MdiIcons.send,
                size: screenSize.height * 0.035,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                if (_messageController.text != '') {
                  sendMessage();
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _onButtonPressedUser() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.25,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_camera_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    pickImage(source: 'Camera');
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Photo Library',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    pickImage(source: 'Gallery');
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel_outlined,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
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

  Future<void> pickImage({String source}) async {
    PickedFile selectedImage = await ImagePicker().getImage(
        source: source == 'Gallery' ? ImageSource.gallery : ImageSource.camera);

    setState(() {
      imageFile = File(selectedImage.path);
    });
    compressImage();
    _repository.uploadImageToStorage(imageFile).then((url) {
      print("URL: $url");
      _repository.uploadImageMsgToDb(url, widget.receiverUid, _senderuid,
          _user.photoUrl, _user.displayName);
    });
    print('chatRoom added');
    _repository.addChatRoom(
      currentUser: currentuser,
      followingUser: _user,
    );
    return;
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

  void sendMessage() {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    Message _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        message: text,
        senderPhoto: _user.photoUrl,
        senderName: _user.displayName,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : $_senderuid , message: $text");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    _repository.addMessageToDb(_message, widget.receiverUid).then((v) {
      _messageController.text = "";
      print("Message added to db");
    });
    print('chatRoom added');
    _repository.addChatRoom(
      currentUser: currentuser,
      followingUser: _user,
    );
  }

  Widget chatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(_senderuid)
          .collection('chatRoom')
          .doc(widget.receiverUid)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          //listItem = snapshot.data.documents;
          return ListView.builder(
            reverse: true,
            // itemExtent: 100,
            //   shrinkWrap: true,
            controller: _scrollController,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, index) =>
                //   ListItemChat(
                //   documentSnapshot: snapshot.data.documents[index],
                //  ),
                chatMessageItem(snapshot.data.docs[index]),
            itemCount: snapshot.data.docs.length,
          );
        }
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                  ? senderLayout(snapshot)
                  : receiverLayout(snapshot)
            ],
          ),
        ),
      ],
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    var screenSize = MediaQuery.of(context).size;
    return snapshot['type'] == 'text'
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ChatBubble(
                  elevation: 0,
                  shadowColor: Colors.black,
                  clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                  // alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(top: 4),
                  backGroundColor: const Color(0xff251F34),
                  child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenSize.width * 0.7,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Wrap(
                          children: [
                            Text(
                              snapshot['message'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.white),
                            )
                            // ExpandableText(
                            //   snapshot['message'],
                            //   maxLines: 6,
                            //   expandText: 'Read more',
                            //   collapseText: 'Less',
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: snapshot['timestamp'] != null
                      ? Text(
                          timeago.format(snapshot['timestamp'].toDate()),
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            //      fontSize: textbody2(context),
                            color: Colors.grey,
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ImageDetail(image: snapshot['photoUrl'])));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ChatBubble(
                  shadowColor: Colors.black,
                  elevation: 0,
                  clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                  backGroundColor: const Color(0xff251F34),
                  margin: EdgeInsets.only(top: 4),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Wrap(
                        children: [
                          FadeInImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                snapshot['photoUrl']),
                            placeholder:
                                AssetImage('assets/images/blankimage.png'),
                            width: 250.0,
                            height: 300.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: snapshot['timestamp'] != null
                      ? Text(
                          timeago.format(snapshot['timestamp'].toDate()),
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            //   fontSize: textbody2(context),
                            color: Colors.grey,
                          ),
                        )
                      : Container(),
                )
              ],
            ),
          );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: snapshot['type'] == 'text'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatBubble(
                    elevation: 0,
                    clipper:
                        ChatBubbleClipper3(type: BubbleType.receiverBubble),
                    backGroundColor: Color(0xffffffff),
                    margin: EdgeInsets.only(top: 4),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Wrap(
                          children: [
                            Text(
                              snapshot['message'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black),
                            )
                            // ExpandableText(
                            //   snapshot['message'],
                            //   maxLines: 6,
                            //   expandText: 'Read more',
                            //   collapseText: 'Less',
                            //   style: TextStyle(
                            //       fontFamily: FontNameDefault,
                            //       fontSize: textBody1(context),
                            //       color: Colors.black),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: snapshot['timestamp'] != null
                        ? Text(
                            timeago.format(snapshot['timestamp'].toDate()),
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              // fontSize: textbody2(context),
                              color: Colors.grey,
                            ),
                          )
                        : Container(),
                  )
                ],
              )
            : InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ImageDetail(image: snapshot['photoUrl'])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatBubble(
                      elevation: 0,
                      clipper:
                          ChatBubbleClipper3(type: BubbleType.receiverBubble),
                      backGroundColor: Color(0xffffffff),
                      margin: EdgeInsets.only(top: 4),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Wrap(
                            children: [
                              FadeInImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    snapshot['photoUrl']),
                                placeholder:
                                    AssetImage('assets/images/blankimage.png'),
                                width: 200.0,
                                height: 300.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: snapshot['timestamp'] != null
                          ? Text(
                              timeago.format(snapshot['timestamp'].toDate()),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                //     fontSize: textbody2(context),
                                color: Colors.grey,
                              ),
                            )
                          : Container(),
                    )
                  ],
                )),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/message.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:image/image.dart' as Im;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:expandable_text/expandable_text.dart';

class GroupChat extends StatefulWidget {
  final String photoUrl;
  final String name;
  // final String receiverUid;
  final Group recieverGroup;

  GroupChat({
    this.photoUrl,
    this.name,
    //  this.receiverUid,
    this.recieverGroup,
  });

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  var _formKey = GlobalKey<FormState>();
  String _senderuid;
  TextEditingController _messageController = TextEditingController();
  final _repository = Repository();
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  static User _user, currentuser;
  final ScrollController _scrollController = ScrollController();
  // Keep track of whether a scroll is needed.
  bool _needsScroll = true;
  Timer _timer;
  bool isExpanded = false;
  bool seeMore = false;

  @override
  void initState() {
    super.initState();
    //print("RCID : ${widget.receiverUid}");
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
          _user = user;
        });
      });
      // _repository.fetchUserDetailsById(widget.receiverUid).then((user) {
      //   if (!mounted) return;
      //   setState(() {
      //     receiverPhotoUrl = user.photoUrl;
      //     receiverName = user.displayName;
      //   });
      // });

      // fetchUidBySearchedName(widget.receiverUid);
    });
  }

  // fetchUserDetailsById(String userId) async {
  //   User user = await _repository.fetchUserDetailsById(widget.receiverUid);
  //   if (!mounted) return;
  //   setState(() {
  //     _user = user;
  //     print("USER : ${_user.displayName}");
  //   });
  // }

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    //  fetchUserDetailsById(uid);
    // _future = _repository.retreiveUserPosts(uid);
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      Timer(
          Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
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
          backgroundColor: const Color(0xfff6f6f6),
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
                  Navigator.pop(context);
                }),
            backgroundColor: const Color(0xffffffff),
            title: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: screenSize.height * 0.035,
                  backgroundImage:
                      NetworkImage(widget.recieverGroup.groupProfilePhoto),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    widget.recieverGroup.groupName,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textAppTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
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
                : Column(
                    children: <Widget>[
                      chatMessagesListWidget(),
                      chatInputWidget(),
                      SizedBox(
                        height: 5.0,
                      )
                    ],
                  ),
          )),
    );
  }

  Widget chatInputWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Wrap(
        children: [
          Container(
            color: Colors.white,
            width: screenSize.width,
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                  fontFamily: FontNameDefault, fontSize: textBody1(context)),
              controller: _messageController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                hintText: "Enter message...",
                icon: IconButton(
                  icon: Icon(
                    Icons.attachment_rounded,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    _onButtonPressedUser();
                  },
                  color: Colors.black,
                ),
                border: InputBorder.none,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      }
                    },
                  ),
                ),
              ),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
        ],
      ),
    );
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
      _repository.uploadImageMsgToGroup(url, widget.recieverGroup, _senderuid,
          _user.photoUrl, _user.displayName);
    });

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
        receiverUid: widget.recieverGroup.uid,
        senderUid: _senderuid,
        message: text,
        senderPhoto: _user.photoUrl,
        senderName: _user.displayName,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    // print(
    //     "receiverUid: ${widget.receiverUid} , senderUid : $_senderuid , message: $text");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    _repository.addMessageToGroup(_message, widget.recieverGroup).then((v) {
      _messageController.text = "";
      print("Message added to db");
    });
  }

  Widget chatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Flexible(
      flex: 1,
      // fit: FlexFit.tight,
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('groups')
            .document(widget.recieverGroup.uid)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //listItem = snapshot.data.documents;
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  //   ListItemChat(
                  //   documentSnapshot: snapshot.data.documents[index],
                  //  ),
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
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
                            seeMore
                                ? Text(
                                    snapshot['message'],
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.white),
                                  )
                                : Text(
                                    snapshot['message'],
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.white),
                                  ),
                            snapshot['message'].length > 200
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        seeMore = !seeMore;
                                      });
                                    },
                                    child: Text(
                                      seeMore ? 'See less' : 'See more',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.deepPurple[300]),
                                    ),
                                  )
                                : Container()
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
                            //  fontSize: textbody2(context),
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
                            fontSize: textbody2(context),
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
            ? Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ChatBubble(
                            elevation: 0,
                            clipper: ChatBubbleClipper3(
                                type: BubbleType.receiverBubble),
                            backGroundColor: Color(0xffffffff),
                            margin: EdgeInsets.only(top: 4),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Wrap(
                                  children: [
                                    seeMore
                                        ? Text(
                                            snapshot['message'],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                              // color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            snapshot['message'],
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                              //   color: Colors.white,
                                            ),
                                          ),
                                    snapshot['message'].length > 200
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                seeMore = !seeMore;
                                              });
                                            },
                                            child: Text(
                                              seeMore ? 'See less' : 'See more',
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color:
                                                      Colors.deepPurple[300]),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.02,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: snapshot['timestamp'] != null
                            ? Text(
                                timeago.format(snapshot['timestamp'].toDate()),
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textbody2(context),
                                  color: Colors.grey,
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                  SizedBox(
                    width: screenSize.width * 0.02,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(snapshot['senderPhoto']),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.012,
                      ),
                      Text(
                        snapshot['senderName'],
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textbody2(context),
                            color: Colors.black),
                      )
                    ],
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
                    Row(
                      children: [
                        ChatBubble(
                          elevation: 0,
                          clipper: ChatBubbleClipper3(
                              type: BubbleType.receiverBubble),
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
                                    placeholder: AssetImage(
                                        'assets/images/blankimage.png'),
                                    width: 200.0,
                                    height: 300.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.02,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  snapshot['senderPhoto']),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.012,
                            ),
                            Text(
                              snapshot['senderName'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textbody2(context),
                                  color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: snapshot['timestamp'] != null
                          ? Text(
                              timeago.format(snapshot['timestamp'].toDate()),
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textbody2(context),
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
}

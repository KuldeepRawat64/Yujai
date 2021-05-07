import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'webview.dart';

class EventDetailGroup extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
  final Group group;

  EventDetailGroup(
      {this.documentSnapshot, this.user, this.currentuser, this.group});

  @override
  _EventDetailGroupState createState() => _EventDetailGroupState();
}

class _EventDetailGroupState extends State<EventDetailGroup> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.white, size: screenSize.height * 0.045),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: null)
              ],
              backgroundColor: Color(0xFFEDF2F8),
              expandedHeight: screenSize.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageDetail(
                                  image: widget.documentSnapshot.data['imgUrl'],
                                )));
                  },
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.documentSnapshot.data['imgUrl']),
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([eventStack()]))
          ],
        ),
      ),
    );
  }

  Widget eventStack() {
    var screenSize = MediaQuery.of(context).size;
    String toLaunch = widget.documentSnapshot.data['ticketWebsite'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                right: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.documentSnapshot.data['time'] != null
                          ? timeago.format(
                              widget.documentSnapshot.data['time'].toDate())
                          : '',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textbody2(context),
                          color: Colors.grey)),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenSize.height * 0.012),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenSize.width / 30),
              child: Text(
                widget.documentSnapshot.data['caption'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                splashColor: Colors.yellow,
                shape: StadiumBorder(),
                color: Colors.deepPurple,
                child: Text(
                  'Register',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textButton(context),
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyWebView(
                            title: 'Register for Event',
                            selectedUrl: toLaunch,
                          )));
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
          child: Container(
            //height: screenSize.height * 0.06,
            width: screenSize.width,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Text(
                'Description',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          width: screenSize.width,
          padding: EdgeInsets.only(
            // top: screenSize.height * 0.012,
            bottom: screenSize.height * 0.012,
            left: screenSize.width / 30,
          ),
          child: Wrap(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.documentSnapshot.data['description'],
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: textBody1(context)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
        widget.documentSnapshot.data['agenda'] != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      //    bottom: screenSize.height * 0.012,
                    ),
                    width: screenSize.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                        //   left: screenSize.width / 30,
                        top: screenSize.height * 0.012,
                      ),
                      child: Text(
                        'Agenda',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: screenSize.width,
                    padding: EdgeInsets.only(
                      //  top: screenSize.height * 0.012,
                      //bottom: screenSize.height * 0.012,
                      left: screenSize.width / 30,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(widget.documentSnapshot.data['agenda'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black54)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
        Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
          child: Container(
            width: screenSize.width,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Text(
                'Details',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenSize.width / 30),
                child: Text(
                  'Event Type',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width / 30,
                ),
                child: Chip(
                  label: Text(widget.documentSnapshot.data['type']),
                  labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenSize.width / 30),
                child: Text(
                  'Event Category',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
              ),
              Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      //   bottom: screenSize.height * 0.012,
                    ),
                    child: Chip(
                      label: Text(
                        widget.documentSnapshot.data['category'],
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
              widget.documentSnapshot.data['location'] != ''
                  ? Padding(
                      padding: EdgeInsets.only(left: screenSize.width / 30),
                      child: Column(
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context)),
                          ),
                          Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.012,
                                ),
                                child: Chip(
                                  label: Text(
                                    widget.documentSnapshot.data['location'],
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          width: screenSize.width,
          child: Padding(
            padding: EdgeInsets.only(
              left: screenSize.width / 30,
              //   top: screenSize.height * 0.012,
            ),
            child: Text(
              'Organiser',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context)),
            ),
          ),
        ),
        Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                bottom: screenSize.height * 0.012,
              ),
              child: Chip(
                label: Text(
                  widget.documentSnapshot.data['organiser'],
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
          child: Container(
            width: screenSize.width,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Text(
                'Uploader',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context)),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InstaFriendProfileScreen(
                    uid: widget.documentSnapshot.data['ownerUid'],
                    name: widget.documentSnapshot.data['eventOwnerName'])));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset.zero,
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              ], borderRadius: BorderRadius.circular(12.0)),
              child: ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.account_box_outlined),
                  onPressed: null,
                ),
                subtitle: Text(''),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      widget.documentSnapshot.data['eventOwnerPhotoUrl']),
                ),
                title: Text(
                  widget.documentSnapshot.data['eventOwnerName'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black,
                    fontSize: textSubTitle(context),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenSize.width / 30,
            top: screenSize.height * 0.01,
            right: screenSize.width / 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Event Discussion',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  RaisedButton(
                    splashColor: Colors.yellow,
                    shape: StadiumBorder(),
                    color: Colors.deepPurple,
                    child: Text(
                      'Discuss',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textButton(context),
                          color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CommentsScreen(
                                    group: widget.group,
                                    isGroupFeed: true,
                                    documentReference:
                                        widget.documentSnapshot.reference,
                                    user: widget.currentuser,
                                    snapshot: widget.documentSnapshot,
                                  ))));
                    },
                  ),
                ],
              ),
              commentWidget(widget.documentSnapshot.reference),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: screenSize.height * 0.012),
          child: Container(
            height: screenSize.height * 0.04,
            width: screenSize.width,
          ),
        ),
      ],
    );
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} discussions',
              style: TextStyle(
                  fontSize: textBody1(context),
                  fontFamily: FontNameDefault,
                  color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            group: widget.group,
                            isGroupFeed: true,
                            documentReference: reference,
                            user: widget.currentuser,
                            snapshot: widget.documentSnapshot,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

import 'dart:async';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Yujai/widgets/list_promotion.dart';
import 'package:shimmer/shimmer.dart';

class FriendActivityApplications extends StatefulWidget {
  final UserModel user;
  final UserModel followingUser;
  FriendActivityApplications({this.user, this.followingUser});

  @override
  _FriendActivityApplicationsState createState() =>
      _FriendActivityApplicationsState();
}

class _FriendActivityApplicationsState
    extends State<FriendActivityApplications> {
  var _repository = Repository();
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    icon = MdiIcons.heart;
  }

  retrieveUserDetails() async {
    _future = _repository.retreiveUserApplications(widget.user.uid);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _scrollController1?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          //   centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Work Applications',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: widget.user != null
            ? Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: postImagesWidget(),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget shimmerPromotion() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController1,
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
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
                height: screenSize.height,
                child: ListView.builder(
                    controller: _scrollController,
                    //shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) => ListItemPromotion(
                          documentSnapshot: snapshot.data[index],
                          index: index,
                          user: widget.user,
                          currentuser: widget.followingUser,
                        ))));
          } else {
            return Center(
              child: shimmerPromotion(),
            );
          }
        } else {
          return Center(
            child: shimmerPromotion(),
          );
        }
      }),
    );
  }

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child:
              Text(label, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }
}

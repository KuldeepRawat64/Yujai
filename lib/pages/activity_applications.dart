import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/widgets/list_promotion.dart';
import 'package:shimmer/shimmer.dart';

class ActivityApplications extends StatefulWidget {
  @override
  _ActivityApplicationsState createState() => _ActivityApplicationsState();
}

class _ActivityApplicationsState extends State<ActivityApplications> {
  var _repository = Repository();
  UserModel _user;
  IconData icon;
  Color color;
  // Future<List<DocumentSnapshot>> _future;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _enabled = true;
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  @override
  void dispose() {
    _scrollController1?.dispose();
    _scrollController2?.dispose();
    super.dispose();
  }

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
    // _future =
    _repository.retreiveUserApplications(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
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
          //  centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Applications',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: _user != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: postImagesWidget(),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget shimmerPromotion() {
    return Container(
        color: const Color(0xffffffff),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController2,
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('promotion')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        // if (snapshot.hasData) {
        //   //     if (snapshot.connectionState == ConnectionState.done) {
        //   return SizedBox(
        //       height: screenSize.height,
        //       child: ListView.builder(
        //           controller: _scrollController,
        //           //shrinkWrap: true,
        //           itemCount: snapshot.data.docs.length,
        //           itemBuilder: ((context, index) => ListItemPost(
        //                 documentSnapshot: snapshot.data.docs[index],
        //                 index: index,
        //                 user: _user,
        //                 currentuser: _user,
        //               ))));
        //   //   } else {
        //   //     return Center(
        //   //       child: shimmer(),
        //   //      );
        //   //      }
        // } else {
        //   return Center(
        //     child: shimmer(),
        //   );
        // }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData && snapshot.data.docs.length > 0) {
            return ListView.builder(
                //   controller: _scrollController,
                //shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) => ListItemPromotion(
                      documentSnapshot: snapshot.data.docs[index],
                      index: index,
                      user: _user,
                      currentuser: _user,
                    )));
          } else {
            return NoContent('No applications', 'assets/images/resume.png',
                'You have not posted any applications yet', '');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
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

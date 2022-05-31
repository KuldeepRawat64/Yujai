import 'package:Yujai/pages/activity_feed.dart';
import 'package:Yujai/pages/news_page.dart';
import 'package:Yujai/pages/profile.dart';
import 'package:Yujai/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/timeline.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:new_version/new_version.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final groupsRef = FirebaseFirestore.instance.collection('groups');
final teamsRef = FirebaseFirestore.instance.collection('teams');
PageController _pageController = PageController();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int cupertinoTabBarIIIValue;
  int cupertinoTabBarIIIValueGetter() => cupertinoTabBarIIIValue;

  //int _page = 0;

  void navigationTapped(int page) {
    //Animating Page

    if (_pageController.hasClients) {
      _pageController.jumpToPage(
        page,
      );
    }
  }

  void onPageChanged(int page) {
    if (!mounted) return;
    setState(() {
      this.cupertinoTabBarIIIValue = page;
    });
  }

  @override
  void initState() {
    super.initState();
    cupertinoTabBarIIIValue = 0;
    _pageController = PageController(initialPage: cupertinoTabBarIIIValue);
    final newVersion = NewVersion(
      context: context,
      androidId: "com.animusit.yujai",
    );
    newVersion.showAlertIfNecessary();

    // FirebaseMessaging.instance;
    // FirebaseMessaging.configure(onMessage: (msg) {
    //   print(msg);
    //   return;
    // }, onLaunch: (msg) {
    //   print(msg);
    //   return;
    // }, onResume: (msg) {
    //   print(msg);
    //   return;
    // });
    // fbm.subscribeToTopic('chat');
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  // void _checkVersion() async {
  //   final newVersion = NewVersion(
  //     context: context,
  //     androidId: "com.animusit.yujai",
  //   );
  //   newVersion.showAlertIfNecessary();

  //   // print("DEVICE : " + status.localVersion);
  //   // print("STORE : " + status.storeVersion);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: new PageView(
            children: [
              FeedScreen(),
              SearchScreen(),
              NewsPage(),
              ActivityScreen(),
              ProfileScreen(),
            ],
            controller: _pageController,
            physics: new NeverScrollableScrollPhysics(),
            // scrollDirection: Axis.horizontal,
            onPageChanged: onPageChanged ?? 0,
          ),
          bottomNavigationBar: CupertinoTabBar.CupertinoTabBar(
            const Color(0xFFf6f6f6),
            const Color(0xFFffffff),
            [
              const Icon(
                Icons.home_outlined,
                color: Colors.black54,
              ),
              const Icon(
                MdiIcons.cloudSearchOutline,
                color: Colors.black54,
              ),
              const Icon(
                Icons.group_outlined,
                color: Colors.black54,
              ),
              const Icon(
                Icons.work_outline,
                color: Colors.black54,
              ),
              const Icon(
                Icons.account_box_outlined,
                color: Colors.black54,
              ),
            ],
            cupertinoTabBarIIIValueGetter ?? 0,
            (int index) {
              navigationTapped(index);
              setState(() {
                cupertinoTabBarIIIValue = index ?? 0;
              });
            },
            useShadow: false,
            innerHorizontalPadding: 30,
            outerHorizontalPadding: 30,
          ),
        ),
      ),
    );
  }
}

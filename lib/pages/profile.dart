import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/about.dart';
import 'package:Yujai/pages/activity.dart';
import 'package:Yujai/pages/activity_applications.dart';
import 'package:Yujai/pages/company_activity.dart';
import 'package:Yujai/pages/edit_company_contact.dart';
import 'package:Yujai/pages/edit_company_about.dart';
import 'package:Yujai/pages/edit_company_location.dart';
import 'package:Yujai/pages/edit_org_info.dart';
import 'package:Yujai/pages/edit_profile.dart';
import 'package:Yujai/pages/edit_purpose.dart';
import 'package:Yujai/pages/edit_skill.dart';
import 'package:Yujai/pages/education_detail.dart';
import 'package:Yujai/pages/experience_edit.dart';
import 'package:Yujai/pages/feedback.dart';
import 'package:Yujai/pages/jobs_updates.dart';
import 'package:Yujai/pages/settings.dart';
import 'package:Yujai/pages/users_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/edit_company_contact_screen.dart';
import 'package:Yujai/widgets/edit_company_location.dart';
import 'package:Yujai/widgets/edit_org_info_screen.dart';
import 'package:Yujai/widgets/edit_profile_company_about.dart';
import 'package:Yujai/widgets/edit_profile_interest.dart';
import 'package:Yujai/widgets/edit_profile_purpose.dart';
import 'package:Yujai/widgets/edit_profile_skill.dart';
import 'package:Yujai/widgets/edit_screen.dart';
import 'package:Yujai/widgets/edit_screen_edu.dart';
import 'package:Yujai/widgets/edit_screen_exp.dart';
import 'package:Yujai/widgets/education_widget.dart';
import 'package:Yujai/widgets/flow_widget.dart';
import 'package:Yujai/widgets/skill_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Yujai/pages/info_detail.dart';
import 'package:Yujai/pages/edit_interests.dart';
import 'package:Yujai/pages/army_info.dart';
import 'package:Yujai/pages/airforce_info.dart';
import 'package:Yujai/pages/navy_info.dart';

class ProfileScreen extends StatefulWidget {
  final bool backButton;
  final String state;
  ProfileScreen({
    this.backButton,
    this.state,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isCompany = false;
  var _repository = Repository();
  User _user;
  IconData icon;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isUser = false;
  bool _enabled = true;
  Color color = Colors.black54;
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;
  FlowEvent experience;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
    icon = MdiIcons.heart;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings.isNotEmpty
          ? strings
              .map((items) => Padding(
                    padding: EdgeInsets.all(screenSize.height * 0.005),
                    child: chip(items, Colors.deepPurple[50]),
                  ))
              .toList()
          : Container(),
    );
  }

  Widget getCertWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: strings.isNotEmpty
          ? strings
              .map((items) => Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.005),
                    child: Text(
                      items,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        //   fontSize: textbody2(context),
                      ),
                    ),
                  ))
              .toList()
          : Container(),
    );
  }

  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.yMMM().format(date);
    return formattedDate;
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      //  labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FontNameDefault,
          color: Colors.black54,
          //  fontSize: textbody2(context),
        ),
      ),
      backgroundColor: color,
      elevation: 0.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.005),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Profile build');
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          // actions: [
          //   IconButton(
          //       icon: Icon(Icons.contacts, color: Colors.black54),
          //       onPressed: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => UsersPage()));
          //       })
          // ],
          leading: widget.backButton != null
              ? IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      size: screenSize.height * 0.045, color: Colors.black54),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
              : IconButton(
                  icon: Icon(
                    MdiIcons.menu,
                    color: Colors.black54,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
          //  centerTitle: true,
          backgroundColor: Colors.white,
          // elevation: 0.2,
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: FontNameDefault,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: textAppTitle(context),
            ),
          ),
        ),
        drawer: Drawer(
            child: Container(
          color: const Color(0xff251F34),
          child: Column(
            children: [
              _user != null
                  ? UserAccountsDrawerHeader(
                      arrowColor: Colors.white,
                      decoration: BoxDecoration(color: Colors.deepPurple[1000]),
                      currentAccountPicture: Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.02),
                        child: CircleAvatar(
                            radius: screenSize.height * 0.04,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                CachedNetworkImageProvider(_user.photoUrl)),
                      ),
                      accountName: Text(
                        _user.displayName,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.white,
                            fontSize: textSubTitle(context)),
                      ),
                      accountEmail: Text(
                        _user.accountType == 'Military'
                            ? _user.military
                            : _user.accountType,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.white,
                            fontSize: textbody2(context)),
                      ),
                    )
                  : DrawerHeader(
                      padding: EdgeInsets.all(screenSize.height * 0.035),
                      child: Text(''),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/drawer.jpg'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white,
                      ),
                    ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _user.accountType == 'Company'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyActivity()))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Activity()));
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.photo_album_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Activity',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => About()));
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.info_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Information',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedBack()));
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.feedback_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Feedback',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Settings()));
                            },
                            child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Settings',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Share.share(
                                  'Check out this app https://play.google.com/store/apps/details?id=com.animusit.yujai',
                                  subject:
                                      'Professional Social Network Made in India');
                            },
                            child: ListTile(
                                leading: Icon(
                                  Icons.share_outlined,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Invite',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                )),
                          )
                        ],
                      )))
            ],
          ),
        )),
        body: _user != null
            ? ListView(
                children: <Widget>[
                  checkHeaderType(),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     top: screenSize.height * 0.02,
                  //     bottom: screenSize.height * 0.02,
                  //   ),
                  //   child: Container(
                  //     height: screenSize.height * 0.01,
                  //     color: Colors.grey[200],
                  //   ),
                  // ),
                  SizedBox(
                    height: screenSize.height * 0.04,
                  ),
                  checkBody(),
                ],
              )
            : Center(
                child: ShimmerProfile(context: context, enabled: _enabled)),
      ),
    );
  }

  checkHeaderType() {
    if (_user.accountType == 'Company') {
      return CompanyHeader(context: context, user: _user);
    } else if (_user.accountType == 'Military') {
      return militaryHeader();
    } else if (_user.accountType == 'Professional') {
      return UserHeader(context: context, user: _user);
    } else if (_user.accountType == 'Student') {
      return UserHeader(context: context, user: _user);
    } else if (_user.accountType == '') {
      return UserHeader(context: context, user: _user);
    } else {
      return UserHeader(context: context, user: _user);
    }
  }

  checkBody() {
    if (_user.accountType == 'Company') {
      return companyBody();
    } else if (_user.accountType == 'Military') {
      return userBody();
    } else if (_user.accountType == '') {
      return userBody();
    } else {
      return userBody();
    }
  }

  checkMilitaryType() {
    if (_user.military == 'Indian Army') {
      return armyImage();
    } else if (_user.military == 'Indian Air Force') {
      return airforceImage();
    } else if (_user.military == 'Indian Navy') {
      return navyImage();
    } else if (_user.military == '') {
      return backgroundImage();
    }
  }

  Widget backgroundImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.deepPurple,
          //Colors.white,
          Colors.grey,
        ])),
      ),
    );
  }

  Widget armyImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/army_flag.png'),
          ),
        ),
      ),
    );
  }

  Widget airforceImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/airforce_flag.png'),
          ),
        ),
      ),
    );
  }

  Widget navyImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/naval_flag.png'),
          ),
        ),
      ),
    );
  }

  checkMilitaryEdit() async {
    if (_user.military == 'Indian Army') {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ArmyInfo()))
          .then((value) {
        retrieveUserDetails();
        if (!mounted) return;
        setState(() {
          color = color == Colors.black ? Colors.black : Colors.black;
        });
      });
    } else if (_user.military == 'Indian Air Force') {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AirforceInfo()))
          .then((value) {
        retrieveUserDetails();
        if (!mounted) return;
        setState(() {
          color = color == Colors.black ? Colors.black : Colors.black;
        });
      });
    } else if (_user.military == 'Indian Navy') {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NavyInfo()))
          .then((value) {
        retrieveUserDetails();
        if (!mounted) return;
        setState(() {
          color = color == Colors.black ? Colors.black : Colors.black;
        });
      });
    }
  }

  Widget militaryHeader() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          fit: StackFit.loose,
          alignment: Alignment.topLeft,
          children: [
            checkMilitaryType(),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.155,
              ),
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => EditPhotoUrl(
                  //           photoUrl: _user.photoUrl,
                  //         )));
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: screenSize.height * 0.07,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(_user.photoUrl),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(screenSize.height * 0.015),
                    //   child: Icon(
                    //     Icons.photo_camera,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenSize.width / 30,
            top: screenSize.height * 0.012,
            right: screenSize.width / 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _user.displayName,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textHeader(context)),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Icon(
                  //   Icons.verified_user,
                  //   color: Colors.deepPurpleAccent,
                  //   size: screenSize.height * 0.025,
                  // ),
                  // Shimmer.fromColors(
                  //   baseColor: Colors.green[900],
                  //   highlightColor: Colors.white,
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         MdiIcons.medal,
                  //         color: Colors.green[900],
                  //         size: screenSize.height * 0.027,
                  //       ),
                  //       Icon(
                  //         MdiIcons.medal,
                  //         color: Colors.green[900],
                  //         size: screenSize.height * 0.027,
                  //       ),
                  //       Icon(
                  //         MdiIcons.medal,
                  //         color: Colors.green[900],
                  //         size: screenSize.height * 0.027,
                  //       ),
                  //       Icon(
                  //         MdiIcons.medal,
                  //         color: Colors.green[900],
                  //         size: screenSize.height * 0.027,
                  //       ),
                  //       Icon(
                  //         MdiIcons.medal,
                  //         color: Colors.green[900],
                  //         size: screenSize.height * 0.027,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              _user.military.isNotEmpty && _user.military != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _user.military,
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: textSubTitle(context)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            //  right: screenSize.width / 30,
                            bottom: screenSize.height * 0.012,
                          ),
                          child: GestureDetector(
                            onTap: checkMilitaryEdit,
                            child: Container(
                              height: screenSize.height * 0.045,
                              width: screenSize.width / 6,
                              child: Center(
                                  child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.white,
                                  fontSize: textButton(context),
                                ),
                              )),
                              decoration: ShapeDecoration(
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget companyBody() {
    var screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'About us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: EditProfileCompany(currentUser: _user))).then(
                    (value) {
                  retrieveUserDetails();
                  if (!mounted) return;
                  setState(() {
                    _user = _user;
                  });
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditCompanyAbout(
                //               bio: _user.bio,
                //             ))).then((value) {
                //   retrieveUserDetails();
                //   if (!mounted) return;
                //   setState(() {
                //     _user = _user;
                //   });
                // });
              },
              child: Container(
                height: screenSize.height * 0.045,
                width: screenSize.width / 6,
                child: Center(
                    child: Icon(
                  Icons.edit_outlined,
                  color: Colors.black54,
                )),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      //   child: Divider(
      //     height: 0.0,
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: _user.bio.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  //left: screenSize.width / 30,
                  top: screenSize.height * 0.01,
                  bottom: screenSize.height * 0.01,
                ),
                child: Wrap(
                  children: [
                    Text(
                      _user.bio,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 4,
                  vertical: screenSize.height * 0.01,
                ),
                child: Text(
                  'Add your basic info and bio',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      SizedBox(
        height: screenSize.height * 0.04,
      ),
      // Padding(
      //   padding: EdgeInsets.only(
      //     top: screenSize.height * 0.02,
      //     bottom: screenSize.height * 0.02,
      //   ),
      //   child: Container(
      //     height: screenSize.height * 0.01,
      //     color: Colors.grey[200],
      //   ),
      // ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Organization Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: EditOrgInfoScreen(currentUser: _user))).then(
                    (value) {
                  retrieveUserDetails();
                  if (!mounted) return;
                  setState(() {
                    _user = _user;
                  });
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditOrgInfo(
                //               name: _user.displayName,
                //               industry: _user.industry,
                //               establishedYear: _user.establishYear,
                //               employees: _user.companySize,
                //               products: _user.products,
                //               gst: _user.gst,
                //             ))).then((value) {
                //   retrieveUserDetails();
                //   if (!mounted) return;
                //   setState(() {
                //     _user = _user;
                //   });
                // });
              },
              child: Container(
                height: screenSize.height * 0.045,
                width: screenSize.width / 6,
                child: Center(
                    child: Icon(
                  Icons.edit_outlined,
                  color: Colors.black54,
                )),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      //   child: Divider(
      //     height: 0.0,
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: _user.employees.isNotEmpty ||
                _user.industry.isNotEmpty ||
                _user.products.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _user.employees.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Employess',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  // left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.employees + ' employees',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _user.establishYear != null && _user.establishYear.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Establishment year',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  //  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.establishYear,
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _user.industry != null && _user.industry.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Industry',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  //  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.industry,
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _user.products != null && _user.products.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Products',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  //  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.products,
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 4,
                  vertical: screenSize.height * 0.01,
                ),
                child: Text(
                  'Add your oraganization info',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textBody1(context),
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      SizedBox(
        height: screenSize.height * 0.04,
      ),
      // Padding(
      //   padding: EdgeInsets.only(
      //     top: screenSize.height * 0.02,
      //     bottom: screenSize.height * 0.02,
      //   ),
      //   child: Container(
      //     height: screenSize.height * 0.01,
      //     color: Colors.grey[200],
      //   ),
      // ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: EditCompanyLocationScreen(
                            currentUser: _user))).then((value) {
                  retrieveUserDetails();
                  if (!mounted) return;
                  setState(() {
                    _user = _user;
                  });
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditCompanyLocation(
                //               location: _user.location,
                //             ))).then((value) {
                //   retrieveUserDetails();
                //   if (!mounted) return;
                //   setState(() {
                //     _user = _user;
                //   });
                // });
              },
              child: Container(
                height: screenSize.height * 0.045,
                width: screenSize.width / 6,
                child: Center(
                    child: Icon(
                  Icons.edit_outlined,
                  color: Colors.black54,
                )),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      //   child: Divider(
      //     height: 0.0,
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.only(
          left: screenSize.width / 30,
          top: screenSize.height * 0.01,
        ),
        child: _user.location.isNotEmpty
            ? Wrap(
                children: [
                  Text(
                    _user.location,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width / 4,
                    vertical: screenSize.height * 0.01),
                child: Text(
                  'Add your locations info',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      SizedBox(
        height: screenSize.height * 0.04,
      ),
      // Padding(
      //   padding: EdgeInsets.only(
      //     top: screenSize.height * 0.02,
      //     bottom: screenSize.height * 0.02,
      //   ),
      //   child: Container(
      //     height: screenSize.height * 0.01,
      //     color: Colors.grey[200],
      //   ),
      // ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Contact',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: EditCompanyContactScreen(
                            currentUser: _user))).then((value) {
                  retrieveUserDetails();
                  if (!mounted) return;
                  setState(() {
                    _user = _user;
                  });
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditCompanyContact(
                //               email: _user.email,
                //               phone: _user.phone,
                //               website: _user.website,
                //             ))).then((value) {
                //   retrieveUserDetails();
                //   if (!mounted) return;
                //   setState(() {
                //     _user = _user;
                //   });
                // });
              },
              child: Container(
                height: screenSize.height * 0.045,
                width: screenSize.width / 6,
                child: Center(
                    child: Icon(
                  Icons.edit_outlined,
                  color: Colors.black54,
                )),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      //   child: Divider(
      //     height: 0.0,
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: _user.email.isNotEmpty ||
                _user.phone.isNotEmpty ||
                _user.website.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _user.email.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  //  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.email,
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _user.website.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Website',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  //  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.website,
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _user.phone.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                  bottom: screenSize.height * 0.005),
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  //  left: screenSize.width / 30,
                                  bottom: screenSize.height * 0.01),
                              child: Text(
                                _user.phone,
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width / 4,
                    vertical: screenSize.height * 0.01),
                child: Text(
                  'Add your contact info',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      SizedBox(
        height: screenSize.height * 0.04,
      ),
      // Padding(
      //   padding: EdgeInsets.only(
      //     top: screenSize.height * 0.02,
      //     bottom: screenSize.height * 0.02,
      //   ),
      //   child: Container(
      //     height: screenSize.height * 0.01,
      //     color: Colors.grey[200],
      //   ),
      // ),
      InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CompanyActivity()));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.012,
            horizontal: screenSize.width / 30,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Updates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ]),
        ),
      ),
      // Divider(
      //   height: 0.0,
      // ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InformationDetail()));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.012,
            horizontal: screenSize.width / 30,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ]),
        ),
      ),
      // Divider(
      //   height: 0.0,
      // ),
      InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => JobUpdates()));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.012,
            horizontal: screenSize.width / 30,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Jobs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ]),
        ),
      ),
      SizedBox(
        height: screenSize.height * 0.04,
      ),
      // Padding(
      //   padding: EdgeInsets.only(
      //     top: screenSize.height * 0.02,
      //     bottom: screenSize.height * 0.02,
      //   ),
      //   child: Container(
      //     height: screenSize.height * 0.01,
      //     color: Colors.grey[200],
      //   ),
      // ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: screenSize.height * 0.03,
          padding: EdgeInsets.only(left: screenSize.width / 30),
          child: Text(
            '',
          ),
        ),
      ]),
    ]);
  }

  Widget userBody() {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Basic Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                color: Colors.black87,
                fontSize: textHeader(context),
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: EditProfile(currentUser: _user))).then((value) {
                  retrieveUserDetails();
                  if (!mounted) return;
                  setState(() {
                    _user = _user;
                  });
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditProfileScreen(
                //               bio: _user.bio,
                //               photoUrl: _user.photoUrl,
                //               name: _user.displayName,
                //               email: _user.email,
                //               phone: _user.phone,
                //               website: _user.website,
                //             ))).then((value) {
                //   retrieveUserDetails();
                //   if (!mounted) return;
                //   setState(() {
                //     _user = _user;
                //   });
                // });
              },
              child: Container(
                height: screenSize.height * 0.045,
                width: screenSize.width / 6,
                child: Center(
                    child: Icon(
                  Icons.edit_outlined,
                  color: Colors.black54,
                )),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: screenSize.height * 0.04,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: screenSize.width / 30,
        //   ),
        //   child: Divider(
        //     height: 0.0,
        //   ),
        // ),
        _user.bio.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _user.accountType == 'Military' && _user.rank.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rank              :   ',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context)),
                                ),
                                Text(
                                  _user.rank,
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black54,
                                      fontSize: textBody1(context)),
                                ),
                              ],
                            ),
                            _user.medal != null &&
                                    _user.accountType == 'MIlitary' &&
                                    _user.medal.isNotEmpty
                                ? Row(
                                    children: [
                                      Text(
                                        'Medal              :  ',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                      Text(
                                        _user.medal,
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  )
                                : Container(),
                            _user.accountType == 'Military' &&
                                    _user.regiment.isNotEmpty
                                ? Row(
                                    children: [
                                      Text(
                                        'Regiment      :  ',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                      Text(
                                        _user.regiment,
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  )
                                : Container(),
                            _user.accountType == 'Military' &&
                                    _user.command.isNotEmpty
                                ? Row(
                                    children: [
                                      Text(
                                        'Command    :  ',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                      Text(
                                        _user.command,
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  )
                                : Container(),
                            _user.accountType == 'Military' &&
                                    _user.department.isNotEmpty
                                ? Row(
                                    children: [
                                      Text(
                                        'Department  :  ',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                      Text(
                                        _user.department,
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            color: Colors.black54,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: screenSize.height * 0.01,
                            ),
                            Divider(),
                          ],
                        )
                      : Container(),
                  Text(
                    'About',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context)),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  Text(
                    _user.bio,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontSize: textBody1(context)),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.25,
                  vertical: screenSize.height * 0.01,
                ),
                child: Text(
                  'Add your basic info and bio',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textBody1(context)),
                ),
              ),
        SizedBox(
          height: screenSize.height * 0.04,
        ),
        // Padding(
        //   padding: EdgeInsets.only(
        //     top: screenSize.height * 0.02,
        //     bottom: screenSize.height * 0.02,
        //   ),
        //   child: Container(
        //     height: screenSize.height * 0.01,
        //     color: Colors.grey[200],
        //   ),
        // ),
        _user.accountType != ''
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Education & Qualification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        color: Colors.black87,
                        fontSize: textHeader(context),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
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
                                child: EditProfileEducation(
                                    currentUser: _user))).then((value) {
                          retrieveUserDetails();
                          if (!mounted) return;
                          setState(() {
                            _user = _user;
                          });
                        });
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => EducationDetail(
                        //               stream: _user.stream,
                        //               school: _user.school,
                        //               startSchool: _user.startSchool,
                        //               endSchool: _user.endSchool,
                        //               college: _user.college,
                        //               startCollege: _user.startCollege,
                        //               endCollege: _user.endCollege,
                        //               university: _user.university,
                        //               startUniversity: _user.startUniversity,
                        //               endUniversity: _user.endUniversity,
                        //               certification1: _user.certification1,
                        //               certification2: _user.certification2,
                        //               certification3: _user.certification3,
                        //             ))).then((value) {
                        //   retrieveUserDetails();
                        //   if (!mounted) return;
                        //   setState(() {
                        //     color = color == Colors.black
                        //         ? Colors.black
                        //         : Colors.black;
                        //   });
                        // });
                      },
                      child: Container(
                        height: screenSize.height * 0.045,
                        width: screenSize.width / 6,
                        child: Center(
                            child: Icon(
                          Icons.edit_outlined,
                          color: Colors.black54,
                        )),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.1, color: Colors.black54),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                //   child: Divider(
                //     height: 0.0,
                //   ),
                // ),
                // _user.university.isEmpty &&
                //         _user.college.isEmpty &&
                //         _user.school.isEmpty
                //     ?
                _user.education != []
                    ? Card(
                        elevation: 0,
                        // margin: EdgeInsets.symmetric(
                        //     horizontal: screenSize.width * 0.035,
                        //     vertical: screenSize.height * 0.02),
                        child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return FlowEducationRow(FlowEducation(
                                  isPresent: _user.education[index]
                                      ['isPresent'],
                                  university: _user.education[index]
                                      ['university'],
                                  degree: _user.education[index]['degree'],
                                  field: _user.education[index]['field'],
                                  startDate: _user.education[index]
                                      ['startUniversity'],
                                  endDate: _user.education[index]
                                      ['endUniversity']));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 2,
                              );
                            },
                            itemCount: _user.education.length),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.25,
                            vertical: screenSize.height * 0.01),
                        child: Text(
                          'Add your Education details to show in your profile',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textBody1(context)),
                        ),
                      )
                // :

                ,
                SizedBox(
                  height: screenSize.height * 0.04,
                ),
              ])
            : Container(),
        _user.accountType == 'Military' || _user.accountType == 'Professional'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Experience',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          color: Colors.black87,
                          fontSize: textHeader(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0))),
                              backgroundColor: Colors.white,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: EditProfileExperience(
                                      currentUser: _user))).then((value) {
                            retrieveUserDetails();
                            if (!mounted) return;
                            setState(() {
                              _user = _user;
                            });
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ExperienceEdit(
                          //               company1: _user.company1,
                          //               startCompany1: _user.startCompany1,
                          //               endCompany1: _user.endCompany1,
                          //               company2: _user.company2,
                          //               startCompany2: _user.startCompany2,
                          //               endCompany2: _user.endCompany2,
                          //               company3: _user.company3,
                          //               startCompany3: _user.startCompany3,
                          //               endCompany3: _user.endCompany3,
                          //             ))).then((value) {
                          //   retrieveUserDetails();
                          //   if (!mounted) return;
                          //   setState(() {
                          //     color = color == Colors.black
                          //         ? Colors.black
                          //         : Colors.black;
                          //   });
                          // });
                        },
                        child: Container(
                          height: screenSize.height * 0.045,
                          width: screenSize.width / 6,
                          child: Center(
                              child: Icon(
                            Icons.edit_outlined,
                            color: Colors.black54,
                          )),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(width: 0.1, color: Colors.black54),
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _user.experience != []
                      ? Card(
                          elevation: 0,
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: screenSize.width * 0.2,
                          //     vertical: screenSize.height * 0.02
                          //     ),
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Positioned(
                                  left: 21,
                                  top: 15,
                                  bottom: 15,
                                  child: VerticalDivider(
                                    width: 1,
                                    color: Colors.black54,
                                  )),
                              ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return FlowEventRow(FlowEvent(
                                        employmentType: _user.experience[index]
                                            ['employmentType'],
                                        isPresent: _user.experience[index]
                                            ['isPresent'],
                                        industry: _user.experience[index]
                                            ['industry'],
                                        company: _user.experience[index]
                                            ['company'],
                                        designation: _user.experience[index]
                                            ['designation'],
                                        startDate: _user.experience[index]
                                            ['startCompany'],
                                        endDate: _user.experience[index]
                                            ['endCompany']));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 2,
                                    );
                                  },
                                  itemCount: _user.experience.length)
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.25,
                              vertical: screenSize.height * 0.01),
                          child: Text(
                            'Add your Work experience or Internships',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  //   child: Divider(
                  //     height: 0.0,
                  //   ),
                  // ),
                  // _user.company1.isNotEmpty ||
                  //         _user.company2.isNotEmpty ||
                  //         _user.company3.isNotEmpty
                  //     ? Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: EdgeInsets.only(
                  //               left: screenSize.width / 30,
                  //               top: screenSize.height * 0.012,
                  //             ),
                  //             child: Text(
                  //               '',
                  //               // _user.company1 +
                  //               //     '   (' +
                  //               //     _user.startCompany1 +
                  //               //     ' - ' +
                  //               //     _user.endCompany1 +
                  //               //     ')   ',
                  //               style: TextStyle(
                  //                   fontFamily: FontNameDefault,
                  //                   color: Colors.black54,
                  //                   fontSize: textBody1(context)),
                  //             ),
                  //           ),
                  //           // _user.company2.isNotEmpty
                  //           //     ? Padding(
                  //           //         padding: EdgeInsets.only(
                  //           //           left: screenSize.width / 30,
                  //           //           top: screenSize.height * 0.012,
                  //           //         ),
                  //           //         child: Text(
                  //           //           '',
                  //           //           // _user.company2 +
                  //           //           //     '   (' +
                  //           //           //     _user.startCompany2 +
                  //           //           //     ' ' +
                  //           //           //     '- ' +
                  //           //           //     _user.endCompany2 +
                  //           //           //     ')   ',
                  //           //           style: TextStyle(
                  //           //               fontFamily: FontNameDefault,
                  //           //               color: Colors.black54,
                  //           //               fontSize: textBody1(context)),
                  //           //         ),
                  //           //       )
                  //           //     : Container(),
                  //           // _user.company3.isNotEmpty
                  //           //     ? Padding(
                  //           //         padding: EdgeInsets.only(
                  //           //           left: screenSize.width / 30,
                  //           //           top: screenSize.height * 0.012,
                  //           //         ),
                  //           //         child: Text(
                  //           //           '',
                  //           //           // _user.company3 +
                  //           //           //     '   (' +
                  //           //           //     _user.startCompany3 +
                  //           //           //     ' ' +
                  //           //           //     '- ' +
                  //           //           //     _user.endCompany3 +
                  //           //           //     ')   ',
                  //           //           style: TextStyle(
                  //           //               fontFamily: FontNameDefault,
                  //           //               color: Colors.black54,
                  //           //               fontSize: textBody1(context)),
                  //           //         ),
                  //           //       )
                  //           //     : Container(),
                  //         ],
                  //       )
                  //     :

                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     top: screenSize.height * 0.02,
                  //     bottom: screenSize.height * 0.02,
                  //   ),
                  //   child: Container(
                  //     height: screenSize.height * 0.01,
                  //     color: Colors.grey[200],
                  //   ),
                  // ),
                  SizedBox(
                    height: screenSize.height * 0.04,
                  ),
                ],
              )
            : Container(),
        _user.accountType != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Skills',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: textHeader(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0))),
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    child: EditProfileSkill(
                                        currentUser: _user))).then((value) {
                              retrieveUserDetails();
                              if (!mounted) return;
                              setState(() {
                                _user = _user;
                              });
                            });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EditSkill(
                            //               skills: _user.skills,
                            //             ))).then((value) {
                            //   retrieveUserDetails();
                            //   if (!mounted) return;
                            //   setState(() {
                            //     color = color == Colors.black
                            //         ? Colors.black
                            //         : Colors.black;
                            //   });
                            // });
                          },
                          child: Container(
                            height: screenSize.height * 0.045,
                            width: screenSize.width / 6,
                            child: Center(
                                child: Icon(
                              Icons.edit_outlined,
                              color: Colors.black54,
                            )),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  //   child: Divider(
                  //     height: 0.0,
                  //   ),
                  // ),
                  _user.skills == []
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.25,
                              vertical: screenSize.height * 0.01),
                          child: Text(
                            'Add your Skills to grab attention of similar minded people or companies',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return SkillEventRow(SkillEvent(
                                skill: _user.skills[index]['skill'],
                                level: _user.skills[index]['level']));
                          },
                          // separatorBuilder:
                          //     (BuildContext context, int index) {
                          //   return SizedBox(
                          //     height: 2,
                          //   );
                          // },
                          itemCount: _user.skills.length),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     top: screenSize.height * 0.02,
                  //     bottom: screenSize.height * 0.02,
                  //   ),
                  //   child: Container(
                  //     height: screenSize.height * 0.01,
                  //     color: Colors.grey[200],
                  //   ),
                  // ),
                  SizedBox(
                    height: screenSize.height * 0.04,
                  ),
                ],
              )
            : Container(),
        _user.accountType != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Interest',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            color: Colors.black87,
                            fontSize: textHeader(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0))),
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    child: EditProfileInterest(
                                        currentUser: _user))).then((value) {
                              retrieveUserDetails();
                              if (!mounted) return;
                              setState(() {
                                _user = _user;
                              });
                            });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EditInterests(
                            //               interests: _user.interests,
                            //             ))).then((value) {
                            //   retrieveUserDetails();
                            //   if (!mounted) return;
                            //   setState(() {
                            //     color = color == Colors.black
                            //         ? Colors.black
                            //         : Colors.black;
                            //   });
                            // });
                          },
                          child: Container(
                            height: screenSize.height * 0.045,
                            width: screenSize.width / 6,
                            child: Center(
                                child: Icon(
                              Icons.edit_outlined,
                              color: Colors.black54,
                            )),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  //   child: Divider(
                  //     height: 0.0,
                  //   ),
                  // ),
                  _user.interests.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.25,
                              vertical: screenSize.height * 0.01),
                          child: Text(
                            'Add your Interests and tell people more about yourself',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Wrap(
                          children: [
                            _user != null
                                ? getTextWidgets(_user.interests)
                                : Container(),
                          ],
                        ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     top: screenSize.height * 0.02,
                  //     bottom: screenSize.height * 0.02,
                  //   ),
                  //   child: Container(
                  //     height: screenSize.height * 0.01,
                  //     color: Colors.grey[200],
                  //   ),
                  // ),
                  SizedBox(
                    height: screenSize.height * 0.04,
                  ),
                ],
              )
            : Container(),
        _user.accountType != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Purpose',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            color: Colors.black87,
                            fontSize: textHeader(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0))),
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    child: EditProfilePurpose(
                                        currentUser: _user))).then((value) {
                              retrieveUserDetails();
                              if (!mounted) return;
                              setState(() {
                                _user = _user;
                              });
                            });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EditPurpose(
                            //               purpose: _user.purpose,
                            //             ))).then((value) {
                            //   retrieveUserDetails();
                            //   if (!mounted) return;
                            //   setState(() {
                            //     color = color == Colors.black
                            //         ? Colors.black
                            //         : Colors.black;
                            //   });
                            // });
                          },
                          child: Container(
                            height: screenSize.height * 0.045,
                            width: screenSize.width / 6,
                            child: Center(
                                child: Icon(
                              Icons.edit_outlined,
                              color: Colors.black54,
                            )),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.1, color: Colors.black54),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  //   child: Divider(
                  //     height: 0.0,
                  //   ),
                  // ),
                  _user.purpose.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.25,
                              vertical: screenSize.height * 0.01),
                          child: Text(
                            'Define your purpose and intentions for using this app',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Wrap(
                          children: [
                            _user != null
                                ? getTextWidgets(_user.purpose)
                                : Container(),
                          ],
                        ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     top: screenSize.height * 0.02,
                  //     bottom: screenSize.height * 0.02,
                  //   ),
                  //   child: Container(
                  //     height: screenSize.height * 0.01,
                  //     color: Colors.grey[200],
                  //   ),
                  // ),
                  SizedBox(
                    height: screenSize.height * 0.04,
                  ),
                ],
              )
            : Container(),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Activity()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textAppTitle(context),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
        // Divider(
        //   height: 0,
        // ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => InformationDetail()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textAppTitle(context),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
        // Divider(
        //   height: 0,
        // ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ActivityApplications()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Applications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textAppTitle(context),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(
        //     top: screenSize.height * 0.02,
        //     bottom: screenSize.height * 0.02,
        //   ),
        //   child: Container(
        //     height: screenSize.height * 0.01,
        //     color: Colors.grey[200],
        //   ),
        // ),
        SizedBox(
          height: screenSize.height * 0.04,
        ),
        // Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //   Container(
        //     height: screenSize.height * 0.03,
        //     //  padding: EdgeInsets.only(left: screenSize.width / 30),
        //     child: Text(
        //       '',
        //     ),
        //   ),
        // ]),
      ]),
    );
  }
}

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({
    Key key,
    @required this.context,
    @required bool enabled,
  })  : _enabled = enabled,
        super(key: key);

  final BuildContext context;
  final bool _enabled;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Shimmer.fromColors(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width / 20,
                        vertical: screenSize.height * 0.02),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.09,
                                  bottom: screenSize.height * 0.055)),
                          Container(
                            height: screenSize.height * 0.15,
                            width: screenSize.width / 4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    screenSize.height * 0.2)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.015)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2.5,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.025,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.015)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2.5,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.03)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.03,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.03,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.025)),
                          Container(
                            height: screenSize.height * 0.02,
                            width: screenSize.width / 2,
                            color: Colors.white,
                          ),
                        ]),
                  ),
                  enabled: _enabled,
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[100]),
            ),
          ]),
    );
  }
}

class CompanyHeader extends StatelessWidget {
  const CompanyHeader({
    Key key,
    @required this.context,
    @required User user,
  })  : _user = user,
        super(key: key);

  final BuildContext context;
  final User _user;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          fit: StackFit.loose,
          //   alignment: Alignment.topLeft,
          children: [
            Container(
              height: screenSize.height * 0.2,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xff251F34),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                //      left: screenSize.width / 30,
                top: screenSize.height * 0.13,
              ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             EditPhotoUrl(photoUrl: _user.photoUrl)));
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: screenSize.height * 0.07,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircleAvatar(
                            radius: screenSize.height * 0.07,
                            backgroundColor: Colors.black,
                            backgroundImage:
                                CachedNetworkImageProvider(_user.photoUrl),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Icon(
                      //     Icons.photo_camera,
                      //     color: Colors.white,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.width / 30, top: screenSize.height * 0.012),
          child: Text(
            _user.displayName,
            style: TextStyle(
                fontFamily: FontNameDefault,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: textSubTitle(context)),
          ),
        ),
      ],
    );
  }
}

class UserHeader extends StatelessWidget {
  const UserHeader({
    Key key,
    @required this.context,
    @required User user,
  })  : _user = user,
        super(key: key);

  final BuildContext context;
  final User _user;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          fit: StackFit.loose,
          //   alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: screenSize.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xff251F34),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.13),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EditPhotoUrl(
                    //               photoUrl: _user.photoUrl,
                    //             )));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: screenSize.height * 0.07,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        radius: screenSize.height * 0.07,
                        backgroundColor: Colors.black,
                        backgroundImage:
                            CachedNetworkImageProvider(_user.photoUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.width / 30, top: screenSize.height * 0.012),
          child: Text(
            _user.displayName,
            style: TextStyle(
              fontFamily: FontNameDefault,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: textSubTitle(context),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.width / 30, top: screenSize.height * 0.012),
          child: _user.location.isNotEmpty
              ? Text(
                  _user.location,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textBody1(context),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class MilitaryBody extends StatelessWidget {
  const MilitaryBody({
    Key key,
    @required this.context,
    @required User user,
  })  : _user = user,
        super(key: key);

  final BuildContext context;
  final User _user;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Basic Info',
              style: TextStyle(fontSize: screenSize.height * 0.025),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                              bio: _user.bio,
                              photoUrl: _user.photoUrl,
                              name: _user.displayName,
                              email: _user.email,
                              phone: _user.phone,
                            )));
              },
              child: Container(
                height: screenSize.height * 0.055,
                width: screenSize.width / 5,
                child: Center(
                    child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.height * 0.02,
                  ),
                )),
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: _user.bio.isNotEmpty
            ? Text(
                _user.bio,
                style: TextStyle(
                  fontSize: screenSize.height * 0.025,
                  color: Colors.black54,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 4,
                  vertical: screenSize.height * 0.01,
                ),
                child: Text(
                  'Add your basic info and bio',
                  style: TextStyle(
                    fontSize: screenSize.height * 0.022,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Military Info',
              style: TextStyle(fontSize: screenSize.height * 0.025),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditMilitaryInfo(
                //               military: _user.military,
                //             )));
              },
              child: Container(
                height: screenSize.height * 0.055,
                width: screenSize.width / 5,
                child: Center(
                    child: Text(
                  'Edit',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenSize.height * 0.02),
                )),
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: _user.bio.isNotEmpty
            ? Text(
                _user.bio,
                style: TextStyle(
                  fontSize: screenSize.height * 0.025,
                  color: Colors.black54,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 4,
                  vertical: screenSize.height * 0.01,
                ),
                child: Text(
                  'Add your Duty info',
                  style: TextStyle(
                    fontSize: screenSize.height * 0.022,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Location',
              style: TextStyle(fontSize: screenSize.height * 0.025),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCompanyLocation()));
              },
              child: Container(
                height: screenSize.height * 0.055,
                width: screenSize.width / 5,
                child: Center(
                    child: Text(
                  'Edit',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenSize.height * 0.02),
                )),
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: _user.location.isNotEmpty
            ? Text(_user.location)
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width / 4,
                    vertical: screenSize.height * 0.01),
                child: Text(
                  'Add your locations info',
                  style: TextStyle(
                    fontSize: screenSize.height * 0.022,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width / 30),
            child: Text(
              'Contact',
              style: TextStyle(fontSize: screenSize.height * 0.025),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width / 30,
              bottom: screenSize.height * 0.012,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                            bio: _user.bio,
                            photoUrl: _user.photoUrl,
                            name: _user.displayName,
                            email: _user.email)));
              },
              child: Container(
                height: screenSize.height * 0.055,
                width: screenSize.width / 5,
                child: Center(
                    child: Text(
                  'Edit',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenSize.height * 0.02),
                )),
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: _user.bio.isNotEmpty
            ? Text(_user.bio)
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width / 4,
                    vertical: screenSize.height * 0.01),
                child: Text(
                  'Add your contact info',
                  style: TextStyle(
                    fontSize: screenSize.height * 0.022,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      Padding(
        padding: EdgeInsets.only(top: screenSize.height * 0.02),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Activity()));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.012,
            horizontal: screenSize.width / 30,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Activity',
              style: TextStyle(fontSize: screenSize.height * 0.022),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ]),
        ),
      ),
      Divider(
        height: 0.0,
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InformationDetail()));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.012,
            horizontal: screenSize.width / 30,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Information',
              style: TextStyle(fontSize: screenSize.height * 0.022),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ]),
        ),
      ),
      Divider(
        height: 0.0,
      ),
      GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.012,
            horizontal: screenSize.width / 30,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Contact',
              style: TextStyle(fontSize: screenSize.height * 0.022),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ]),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          // top: screenSize.height * 0.02,
          bottom: screenSize.height * 0.02,
        ),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: screenSize.height * 0.03,
          padding: EdgeInsets.only(left: screenSize.width / 30),
          child: Text(
            '',
          ),
        ),
      ]),
    ]);
  }
}

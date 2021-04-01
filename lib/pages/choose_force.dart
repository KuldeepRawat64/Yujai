import 'package:Yujai/pages/create_account_profile.dart';
import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChooseForce extends StatefulWidget {
  final String currentUserId;
  ChooseForce({this.currentUserId});

  @override
  _ChooseForceState createState() => _ChooseForceState();
}

class _ChooseForceState extends State<ChooseForce> {
  String military;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    military = "";
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        body: ListView(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.055,
            left: screenSize.width / 11,
            right: screenSize.width / 11,
          ),
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Choose your Military Force',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        FirebaseUser currentUser = await _auth.currentUser();
                        setState(() {
                          military = "Indian Army";
                        });
                        usersRef.document(currentUser.uid).updateData({
                          "military": military,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountProfile()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        height: screenSize.height * 0.09,
                        child: Center(
                          child: Text(
                            "Indian Army",
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FirebaseUser currentUser = await _auth.currentUser();
                      setState(() {
                        military = "Indian Air Force";
                      });
                      usersRef.document(currentUser.uid).updateData({
                        "military": military,
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountProfile()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      height: screenSize.height * 0.09,
                      child: Center(
                        child: Text(
                          "Indian Air Force",
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.white,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        FirebaseUser currentUser = await _auth.currentUser();
                        setState(() {
                          military = "Indian Navy";
                        });
                        usersRef.document(currentUser.uid).updateData({
                          "military": military,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountProfile()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        height: screenSize.height * 0.09,
                        child: Center(
                          child: Text(
                            "Indian Navy",
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          height: screenSize.height * 0.09,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Select one of the above',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

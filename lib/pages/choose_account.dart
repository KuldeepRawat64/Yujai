import 'package:Yujai/pages/create_account_profile.dart';
import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'choose_force.dart';

class ChooseAccount extends StatefulWidget {
  @override
  _ChooseAccountState createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {
  String accountType = '';
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()  async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff6f6f6),
          body: Container(
            padding: EdgeInsets.fromLTRB(
              screenSize.width / 11,
              screenSize.height * 0.055,
              screenSize.width / 11,
              0,
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Define your Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textAppTitle(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        FirebaseUser currentUser = await _auth.currentUser();
                        setState(() {
                          accountType = "Professional";
                        });
                        usersRef.document(currentUser.uid).updateData({
                          "accountType": accountType,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountProfile()));
                      },
                      child: Container(
                        height: screenSize.height * 0.09,
                        decoration: BoxDecoration(
                          // border: new Border.all(
                          //   width: 0.15,
                          // ),
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        child: Center(
                          child: Text(
                            "Professional / Freelancer",
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
                        accountType = "Student";
                      });
                      usersRef.document(currentUser.uid).updateData({
                        "accountType": accountType,
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountProfile()));
                    },
                    child: Container(
                      height: screenSize.height * 0.09,
                      decoration: BoxDecoration(
                        // border: new Border.all(
                        //   width: 0.15,
                        // ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: Center(
                        child: Text(
                          "Student",
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
                    padding:
                        EdgeInsets.symmetric(vertical: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        FirebaseUser currentUser = await _auth.currentUser();
                        setState(() {
                          accountType = "Military";
                        });
                        usersRef.document(currentUser.uid).updateData({
                          "accountType": accountType,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseForce()));
                      },
                      child: Container(
                        height: screenSize.height * 0.09,
                        decoration: BoxDecoration(
                          // border: new Border.all(
                          //   width: 0.15,
                          // ),
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        child: Center(
                          child: Text(
                            "Military",
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
      ),
    );
  }
}

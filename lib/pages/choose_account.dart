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
  bool isSelected = false;
  bool isSelected2 = false;
  bool isSelected3 = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
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
                      'Define your account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textHeader(context),
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
                          isSelected = true;
                          isSelected2 = false;
                          isSelected3 = false;
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

                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Text(
                            "Professional / Freelancer",
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: isSelected ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
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
                        isSelected2 = true;
                        isSelected = false;
                        isSelected3 = false;
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
                        color: isSelected2
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          "Student",
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: isSelected2 ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.bold,
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
                          isSelected3 = true;
                          isSelected = false;
                          isSelected2 = false;
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
                          color: isSelected3
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Text(
                            "Military",
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color:
                                  isSelected3 ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
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
            color: Color(0xffffffff),
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

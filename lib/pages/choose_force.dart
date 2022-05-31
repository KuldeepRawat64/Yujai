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
  bool selectedFirst = false;
  bool selectedSecond = false;
  bool selectedThird = false;

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
        backgroundColor: const Color(0xffffffff),
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
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black54,
                              size: screenSize.height * 0.04,
                            )),
                      ),
                      Center(
                        child: Text(
                          'Choose your Military Force',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textAppTitle(context)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        User currentUser = _auth.currentUser;
                        setState(() {
                          selectedFirst = true;
                          selectedSecond = false;
                          selectedThird = false;
                          military = "Indian Army";
                        });
                        usersRef.doc(currentUser.uid).update({
                          "military": military,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountProfile()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedFirst
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        height: screenSize.height * 0.09,
                        child: Center(
                          child: Text(
                            "Indian Army",
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color:
                                  selectedFirst ? Colors.white : Colors.black54,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      User currentUser = _auth.currentUser;
                      setState(() {
                        selectedSecond = true;
                        selectedFirst = false;
                        selectedThird = false;
                        military = "Indian Air Force";
                      });
                      usersRef.doc(currentUser.uid).update({
                        "military": military,
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountProfile()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedSecond
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      height: screenSize.height * 0.09,
                      child: Center(
                        child: Text(
                          "Indian Air Force",
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color:
                                selectedSecond ? Colors.white : Colors.black54,
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
                        User currentUser = _auth.currentUser;
                        setState(() {
                          selectedThird = true;
                          selectedFirst = false;
                          selectedSecond = false;
                          military = "Indian Navy";
                        });
                        usersRef.doc(currentUser.uid).update({
                          "military": military,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountProfile()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedThird
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        height: screenSize.height * 0.09,
                        child: Center(
                          child: Text(
                            "Indian Navy",
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              color:
                                  selectedThird ? Colors.white : Colors.black54,
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
          color: Color(0xffffffff),
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

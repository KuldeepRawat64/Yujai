import 'package:Yujai/pages/choose_account.dart';
import 'package:Yujai/pages/company_info.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style.dart';

String name;
String email;
String imageUrl;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _repository = Repository();
  String accountType = '';
  bool isLoading = true;

  Padding buildTitle() {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Login',
          style: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: screenSize.height * 0.06,
            color: Colors.white,
          )),
    );
  }

  Padding buildLoginTitle() {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Sign Up',
        style: TextStyle(
          fontSize: screenSize.height * 0.04,
          color: Colors.black54,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 38.0,
          height: 2.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildUnAuthScreen() {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff251F34),
        body: Form(
          key: _formKey,
          child: Container(
            height: screenSize.height,
            alignment: Alignment.topCenter,
            child: ListView(
                padding: EdgeInsets.fromLTRB(
                  screenSize.width / 11,
                  0,
                  screenSize.width / 11,
                  screenSize.height * 0.05,
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: kToolbarHeight),
                          buildTitle(),
                          buildTitleLine(),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.05,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: kToolbarHeight),
                          Container(
                            decoration: ShapeDecoration(
                                color: Color(0xffffffff),
                                shape: CircleBorder()),
                            child: Padding(
                              padding: EdgeInsets.all(screenSize.height * 0.03),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: screenSize.height * 0.06,
                                backgroundImage:
                                    AssetImage('assets/images/logo.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width / 30,
                                vertical: screenSize.height * 0.01),
                            child: Text(
                              'Log In with Google',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                fontSize: textbody2(context),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.width / 1.5,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  side: BorderSide(
                                      color: Colors.white, width: 1.5),
                                ),
                                color: Colors.white,
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  _repository.signIn().then((user) {
                                    if (user != null) {
                                      authenticateUser(user);
                                    } else {
                                      print('Error');
                                    }
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Image(
                                          height: 40,
                                          width: 40,
                                          image: AssetImage(
                                              'assets/images/google_logo.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'User Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: FontNameDefault,
                                            fontSize: textSubTitle(context),
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.03,
                          ),
                          Container(
                            width: screenSize.width / 1.5,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.white),
                                ),
                                color: Color(0xff251F34),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  _repository.signIn().then((user) {
                                    if (user != null) {
                                      authenticateCompany(user);
                                    } else {
                                      print('Error');
                                    }
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Image(
                                          height: 40,
                                          width: 40,
                                          image: AssetImage(
                                              'assets/images/google_logo.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Company Login',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textSubTitle(context),
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void authenticateUser(User user) {
    print('Inside Login Screen -> authenticateUser');
    _repository.authenticateUser(user).then((value) {
      if (value) {
        print('VALUE : $value');
        print('INSIDE IF');
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChooseAccount()));
        });
      } else {
        print('inside else');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  void authenticateCompany(User user) async {
    print('Inside Login Screen -> authenticateCompany');
    _repository.authenticateUser(user).then((value) {
      if (value) {
        print('VALUE : $value');
        print('INSIDE IF');
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CompanyInfo()));
        });
      } else {
        print('inside else');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUnAuthScreen();
  }
}

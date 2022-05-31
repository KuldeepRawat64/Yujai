import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCompanyContact extends StatefulWidget {
  final String website;
  final String phone;
  final String email;
  const EditCompanyContact({Key key, this.email, this.website, this.phone})
      : super(key: key);

  @override
  _EditCompanyContactState createState() => _EditCompanyContactState();
}

class _EditCompanyContactState extends State<EditCompanyContact> {
  var _repository = Repository();
  User currentUser;
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _websiteController.text = widget.website;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  submit() async {
    User currentUser = _auth.currentUser;
    _firestore.collection('users').doc(currentUser.uid).update({
      "email": _emailController.text,
      "phone": _phoneController.text,
      "portfolio": _websiteController.text,
    });
    Navigator.pop(context);
    const snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: submit,
                child: Container(
                  width: screenSize.width * 0.15,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      color: Colors.white,
                      fontSize: textButton(context),
                    ),
                  )),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Edit Contact',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textSubTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
                right: screenSize.width / 30,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Info',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.012),
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //  color: const Color(0xffffffff),
                      height: screenSize.height * 0.09,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                        ),
                        controller: _emailController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.012),
                      child: Text(
                        'Website',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //     color: const Color(0xffffffff),
                      height: screenSize.height * 0.09,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                        ),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                        controller: _websiteController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.012),
                      child: Text(
                        'Phone',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //  color: const Color(0xffffffff),
                      height: screenSize.height * 0.09,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                        ),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _phoneController,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

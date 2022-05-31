import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditCompanyAbout extends StatefulWidget {
  final String bio;

  const EditCompanyAbout({Key key, this.bio}) : super(key: key);

  @override
  _EditCompanyAboutState createState() => _EditCompanyAboutState();
}

class _EditCompanyAboutState extends State<EditCompanyAbout> {
  var _repository = Repository();
  User currentUser;
  final _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.bio;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  submit() async {
    User currentUser = _auth.currentUser;
    _firestore.collection('users').doc(currentUser.uid).update({
      "bio": _controller.text,
    });
    Navigator.pop(context);
    const snackBar = SnackBar(
      content: Text('Profile Updated'),
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
          key: _scaffoldKey,
          appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.018,
                  horizontal: screenSize.width * 0.02,
                ),
                child: GestureDetector(
                  onTap: submit,
                  child: Container(
                    //  height: screenSize.height * 0.055,
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
              'Edit Company About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
              ),
            ),
            backgroundColor: const Color(0xffffffff),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              //     color: const Color(0xffffffff),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffffffff),
                ),
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                ),
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
              ),
            ),
          )),
    );
  }
}

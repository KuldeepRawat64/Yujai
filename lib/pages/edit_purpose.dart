import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/search_purpose.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../style.dart';

class EditPurpose extends StatefulWidget {
  final List<dynamic> purpose;
  EditPurpose({this.purpose});
  @override
  _EditPurposeState createState() => _EditPurposeState();
}

class _EditPurposeState extends State<EditPurpose> {
  bool isSelected = false;
  var _repository = Repository();
  UserModel _user;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: screenSize.height * 0.045,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.5,
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Edit Purpose',
            style: TextStyle(
              fontFamily: FontNameDefault,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: textAppTitle(context),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width * 0.02,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => SearchPurpose()))
                      .then((value) {
                    retrieveUserDetails();
                    if (!mounted) return;
                    setState(() {
                      _user = _user;
                    });
                  });
                },
                child: Container(
                  width: screenSize.width * 0.15,
                  child: Center(
                      child: Text(
                    'Add',
                    style: TextStyle(
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
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Chip(
                deleteIcon: Icon(Icons.add),
                onDeleted: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => SearchPurpose()))
                      .then((value) {
                    retrieveUserDetails();
                    if (!mounted) return;
                    setState(() {
                      _user = _user;
                    });
                  });
                },
                label: Text(
                  'Add Purpose',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.0,
            ),
            _user != null ? getTextWidgets(_user.purpose) : Container()
          ],
        ),
      ),
    );
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.01),
                child: chip(items, Colors.grey[400]),
              ))
          .toList(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FontNameDefault,
          color: Colors.white,
          fontSize: textBody1(context),
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.01),
    );
  }
}

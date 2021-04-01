import 'package:Yujai/pages/privacy.dart';
import 'package:Yujai/main.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../style.dart';

class Settings extends StatefulWidget {
  final String currentUserId;
  Settings({this.currentUserId});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Privacy()));
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(Icons.lock_outline),
                title: Text(
                  'Privacy & Security',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: screenSize.height * 0.045,
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            InkWell(
              onTap: () {
                _repository.signOut().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }));
                });
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(MdiIcons.accountCancelOutline),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: screenSize.height * 0.045,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

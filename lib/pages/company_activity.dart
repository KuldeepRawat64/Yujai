import 'package:Yujai/pages/activity.dart';
import 'package:Yujai/pages/activity_events.dart';
import 'package:Yujai/pages/activity_news.dart';
import 'package:Yujai/pages/jobs_updates.dart';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CompanyActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
            elevation: 0.5,
            title: Text(
              'Activity',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context),
            )),
        body: ListView(
          padding: EdgeInsets.only(top: screenSize.height * 0.012),
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => JobUpdates()));
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(Icons.work_outline),
                title: Text(
                  'Jobs',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: screenSize.height * 0.05,
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EventUpdates()));
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(Icons.event_outlined),
                title: Text(
                  'Events',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: screenSize.height * 0.05,
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Activity()));
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(Icons.photo_outlined),
                title: Text(
                  'Posts',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: screenSize.height * 0.05,
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NewsUpdates()));
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(MdiIcons.newspaperVariantOutline),
                title: Text(
                  'Articles',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: screenSize.height * 0.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

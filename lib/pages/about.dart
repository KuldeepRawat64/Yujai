import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'agreementDialog.dart' as fullDialog;
import 'policyDialog.dart' as policyDialog;

class About extends StatelessWidget {
  final String currentUserId;
  About({this.currentUserId});

  Future _openAgreeDialog(context) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return fullDialog.CreateAgreement();
        },
        //true to display with a dismiss button rather than a return navigation arrow
        fullscreenDialog: true));
    if (result != null) {
      letsDoSomething(result, context);
    } else {
      // print('you could do another action here if they cancel');
    }
  }

  letsDoSomething(String result, context) {
    // print('');
  }

  Future _openPolicyDialog(context) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return policyDialog.CreateAgreement();
        },
        //true to display with a dismiss button rather than a return navigation arrow
        fullscreenDialog: true));
    if (result != null) {
      letsDoSomething(result, context);
    } else {
      // print('you could do another action here if they cancel');
    }
  }

  letsDoNothing(String result, context) {
    // print('');
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          title: Text(
            'About',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          //  centerTitle: true,
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
          padding: EdgeInsets.only(top: screenSize.height * 0.0),
          children: [
            InkWell(
              onTap: () {
                _openPolicyDialog(context);
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(Icons.policy_outlined),
                title: Text(
                  'Data Policy',
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
                _openAgreeDialog(context);
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(Icons.account_box_outlined),
                title: Text(
                  'Terms of Use',
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyWebView(
                              title: 'FAQs',
                              selectedUrl:
                                  'https://animusitmanagement.blogspot.com/',
                            )));
              },
              child: ListTile(
                tileColor: const Color(0xffffffff),
                leading: Icon(MdiIcons.frequentlyAskedQuestions),
                title: Text(
                  'FAQs',
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
            //    Divider(),
          ],
        ),
      ),
    );
  }
}

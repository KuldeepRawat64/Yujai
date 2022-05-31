import 'package:Yujai/pages/new_ad_form.dart';
import 'package:flutter/material.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';

class NewAdScreen extends StatelessWidget {
  final Group group;
  final UserModel currentUser;

  const NewAdScreen({Key key, this.group, this.currentUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: screenSize.height * 0.95,
          child: Column(
            //shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: screenSize.height * 0.01,
                        top: screenSize.height * 0.02,
                        left: screenSize.width * 0.05,
                        right: screenSize.width * 0.05),
                    child: Text(
                      'New Ad',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: screenSize.height * 0.01,
                        top: screenSize.height * 0.02,
                        left: screenSize.width * 0.05,
                        right: screenSize.width * 0.05),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              NewAdForm(
                group: group,
                currentUser: currentUser,
              )
            ],
          ),
        ),
      ),
    );
  }
}

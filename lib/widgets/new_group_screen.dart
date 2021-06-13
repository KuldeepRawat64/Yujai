import 'package:Yujai/pages/new_group_form.dart';
import 'package:Yujai/pages/new_post_form_main.dart';
import 'package:Yujai/pages/new_team_form.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/new_post_form.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';

class NewGroupScreen extends StatelessWidget {
  final User currentUser;

  const NewGroupScreen({Key key, this.currentUser}) : super(key: key);
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
                      //   left: screenSize.width * 0.05,
                      //    right: screenSize.width * 0.05
                    ),
                    child: Text(
                      'New Group',
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
                      //    left: screenSize.width * 0.05,
                      //   right: screenSize.width * 0.05
                    ),
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.close),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: NewGroupForm(
                  currentUser: currentUser,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

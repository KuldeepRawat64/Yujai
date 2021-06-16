import 'package:Yujai/pages/edit_company_about_form.dart';
import 'package:Yujai/pages/edit_company_location_form.dart';
import 'package:Yujai/pages/edit_org_info_form.dart';
import 'package:Yujai/pages/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/new_post_form.dart';
import '../style.dart';
import 'package:Yujai/models/user.dart';

class EditCompanyLocationScreen extends StatelessWidget {
  final UserModel currentUser;

  const EditCompanyLocationScreen({Key key, this.currentUser})
      : super(key: key);
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
                      'Edit Location',
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
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            Icons.close,
                            color: Colors.black54,
                          ),
                        )
                        //  Text(
                        //   'Cancel',
                        //   style: TextStyle(
                        //     fontFamily: FontNameDefault,
                        //     fontSize: textSubTitle(context),
                        //     //fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        ),
                  )
                ],
              ),
              Container(
                child: EditCompanyLocationForm(
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

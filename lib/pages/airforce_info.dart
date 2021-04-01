import 'dart:core';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'airforce_add_info.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AirforceInfo extends StatefulWidget {
  final String currentUserId;
  AirforceInfo({this.currentUserId});

  @override
  _AirforceInfoState createState() => _AirforceInfoState();
}

class OfficerRank {
  int id;
  String name;
  OfficerRank(this.id, this.name);
  static List<OfficerRank> getOfficerRank() {
    return <OfficerRank>[
      OfficerRank(1, 'Select a Rank'),
      OfficerRank(2, 'Field Marshal'),
      OfficerRank(3, 'General'),
      OfficerRank(4, 'Lieutenant general'),
      OfficerRank(5, 'Major General'),
      OfficerRank(6, 'Brigadier'),
      OfficerRank(7, 'Colonel'),
      OfficerRank(8, 'Lieutenant Colonel'),
      OfficerRank(9, 'Major'),
      OfficerRank(10, 'Captain'),
      OfficerRank(11, 'Lieutenant'),
    ];
  }
}

class Command {
  int id;
  String name;
  Command(this.id, this.name);
  static List<Command> getCommand() {
    return <Command>[
      Command(1, 'Select a Command'),
      Command(2, 'Army Training Command'),
      Command(3, 'Central Command'),
      Command(4, 'Eastern Command'),
      Command(5, 'Northern Command'),
      Command(6, 'South Western Command'),
      Command(7, 'Southern Command'),
      Command(8, 'Western Command'),
    ];
  }
}

class Regiment {
  int id;
  String name;
  Regiment(this.id, this.name);
  static List<Regiment> getRegiment() {
    return <Regiment>[
      Regiment(1, 'Select a Regiment'),
      Regiment(2, 'Armoured Regiments'),
      Regiment(3, 'Infantry Regiments'),
      Regiment(4, 'Regiments of Artillery'),
      Regiment(5, 'Corps of Army Air Defence'),
      Regiment(6, 'Corps of Engineers'),
    ];
  }
}

class Department {
  int id;
  String name;
  Department(this.id, this.name);
  static List<Department> getDepartment() {
    return <Department>[
      Department(1, 'Select a Department'),
      Department(2, 'Departments of Defence'),
      Department(3, 'Department of Military Affairs'),
      Department(4, 'Department of Defence Production'),
      Department(5, 'Department of Defence Research and Development'),
      Department(6, 'Department of Ex-Servicemen Welfare'),
    ];
  }
}

class _AirforceInfoState extends State<AirforceInfo> {
  List<OfficerRank> _officerRank = OfficerRank.getOfficerRank();
  List<DropdownMenuItem<OfficerRank>> _dropDownMenuOfficerRank;
  OfficerRank _selectedOfficerRank;
  List<Command> _command = Command.getCommand();
  List<DropdownMenuItem<Command>> _dropDownMenuCommand;
  Command _selectedCommand;
  List<Department> _department = Department.getDepartment();
  List<DropdownMenuItem<Department>> _dropDownMenuDepartment;
  Department _selectedDepartment;
  bool isLoading = false;
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  var _repository = Repository();

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _dropDownMenuOfficerRank = buildDropDownMenuOfficerRank(_officerRank);
    _selectedOfficerRank = _dropDownMenuOfficerRank[0].value;
    _dropDownMenuCommand = buildDropDownMenuCommand(_command);
    _selectedCommand = _dropDownMenuCommand[0].value;

    _dropDownMenuDepartment = buildDropDownMenuDepartment(_department);
    _selectedDepartment = _dropDownMenuDepartment[0].value;
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  List<DropdownMenuItem<OfficerRank>> buildDropDownMenuOfficerRank(
      List officerRanks) {
    List<DropdownMenuItem<OfficerRank>> items = List();
    for (OfficerRank officerRank in officerRanks) {
      items.add(
        DropdownMenuItem(
          value: officerRank,
          child: Text(officerRank.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownOfficerRank(OfficerRank selectedOfficerRank) {
    setState(() {
      _selectedOfficerRank = selectedOfficerRank;
    });
  }

  List<DropdownMenuItem<Command>> buildDropDownMenuCommand(List commands) {
    List<DropdownMenuItem<Command>> items = List();
    for (Command command in commands) {
      items.add(
        DropdownMenuItem(
          value: command,
          child: Text(command.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownCommand(Command selectedCommand) {
    setState(() {
      _selectedCommand = selectedCommand;
    });
  }

  List<DropdownMenuItem<Regiment>> buildDropDownMenuRegiment(List regiments) {
    List<DropdownMenuItem<Regiment>> items = List();
    for (Regiment regiment in regiments) {
      items.add(
        DropdownMenuItem(
          value: regiment,
          child: Text(regiment.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Department>> buildDropDownMenuDepartment(
      List departments) {
    List<DropdownMenuItem<Department>> items = List();
    for (Department department in departments) {
      items.add(
        DropdownMenuItem(
          value: department,
          child: Text(department.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownDepartment(Department selectedDepartment) {
    setState(() {
      _selectedDepartment = selectedDepartment;
    });
  }

  submit() async {
    FirebaseUser currentUser = await _auth.currentUser();
    usersRef.document(currentUser.uid).updateData({
      "rank": _selectedOfficerRank.name,
      "command": _selectedCommand.name,
      "department": _selectedDepartment.name,
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AirforceAddInfo()));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          actions: [
            _selectedOfficerRank.name != 'Select a Rank' &&
                    _selectedCommand.name != 'Select a Command' &&
                    _selectedDepartment.name != 'Select a Department'
                ? IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: Colors.black54,
                      size: screenSize.height * 0.045,
                    ),
                    onPressed: submit,
                  )
                : Container(),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          //  centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Edit Military Info',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            screenSize.width / 11,
            screenSize.height * 0.055,
            screenSize.width / 11,
            0,
          ),
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _user != null
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: screenSize.height * 0.035),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: screenSize.height * 0.08,
                            backgroundImage:
                                CachedNetworkImageProvider(_user.photoUrl),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenSize.height * 0.015),
                    child: Text(
                      'Select the details below to continue',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.035),
                        child: Text(
                          'Rank',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: DropdownButton(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black87,
                            ),
                            underline: Container(color: Colors.white),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Theme.of(context).accentColor),
                            iconSize: 30,
                            isExpanded: true,
                            value: _selectedOfficerRank,
                            items: _dropDownMenuOfficerRank,
                            onChanged: onChangeDropDownOfficerRank,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.015),
                        child: Text(
                          'Command',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: DropdownButton(
                            underline: Container(color: Colors.white),
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black87,
                            ),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Theme.of(context).accentColor),
                            iconSize: 30,
                            isExpanded: true,
                            value: _selectedCommand,
                            items: _dropDownMenuCommand,
                            onChanged: onChangeDropDownCommand,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.015),
                        child: Text(
                          'Department',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: DropdownButton(
                            underline: Container(color: Colors.white),
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black87,
                            ),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Theme.of(context).accentColor),
                            iconSize: 30,
                            isExpanded: true,
                            value: _selectedDepartment,
                            items: _dropDownMenuDepartment,
                            onChanged: onChangeDropDownDepartment,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

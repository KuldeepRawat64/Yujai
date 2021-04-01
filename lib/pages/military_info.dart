import 'dart:core';
import 'package:flutter/material.dart';
import '../style.dart';
import 'mil_add_info.dart';

class MilitaryInfo extends StatefulWidget {
  final String currentUserId;
  MilitaryInfo({this.currentUserId});

  @override
  _MilitaryInfoState createState() => _MilitaryInfoState();
}

class OfficerRank {
  int id;
  String name;
  OfficerRank(this.id, this.name);
  static List<OfficerRank> getOfficerRank() {
    return <OfficerRank>[
      OfficerRank(1, 'Field Marshal'),
      OfficerRank(2, 'General'),
      OfficerRank(3, 'Lieutenant general'),
      OfficerRank(4, 'Major General'),
      OfficerRank(5, 'Brigadier'),
      OfficerRank(6, 'Colonel'),
      OfficerRank(7, 'Lieutenant Colonel'),
      OfficerRank(8, 'Major'),
      OfficerRank(9, 'Captain'),
      OfficerRank(10, 'Lieutenant'),
    ];
  }
}

class Command {
  int id;
  String name;
  Command(this.id, this.name);
  static List<Command> getCommand() {
    return <Command>[
      Command(1, 'Army Training Command'),
      Command(2, 'Central Command'),
      Command(3, 'Eastern Command'),
      Command(4, 'Northern Command'),
      Command(5, 'South Western Command'),
      Command(6, 'Southern Command'),
      Command(7, 'Western Command'),
    ];
  }
}

class Regiment {
  int id;
  String name;
  Regiment(this.id, this.name);
  static List<Regiment> getRegiment() {
    return <Regiment>[
      Regiment(1, 'Armoured Regiments'),
      Regiment(2, 'Infantry Regiments'),
      Regiment(3, 'Regiments of Artillery'),
      Regiment(4, 'Corps of Army Air Defence'),
      Regiment(5, 'Corps of Engineers'),
    ];
  }
}

class Department {
  int id;
  String name;
  Department(this.id, this.name);
  static List<Department> getDepartment() {
    return <Department>[
      Department(1, 'Departments of Defence'),
      Department(2, 'Department of Military Affairs'),
      Department(3, 'Department of Defence Production'),
      Department(4, 'Department of Defence Research and Development'),
      Department(5, 'Department of Ex-Servicemen Welfare'),
    ];
  }
}

class _MilitaryInfoState extends State<MilitaryInfo> {
  List<OfficerRank> _officerRank = OfficerRank.getOfficerRank();
  List<DropdownMenuItem<OfficerRank>> _dropDownMenuOfficerRank;
  OfficerRank _selectedOfficerRank;
  List<Command> _command = Command.getCommand();
  List<DropdownMenuItem<Command>> _dropDownMenuCommand;
  Command _selectedCommand;
  List<Regiment> _regiment = Regiment.getRegiment();
  List<DropdownMenuItem<Regiment>> _dropDownMenuRegiment;
  Regiment _selectedRegiment;
  List<Department> _department = Department.getDepartment();
  List<DropdownMenuItem<Department>> _dropDownMenuDepartment;
  Department _selectedDepartment;

  @override
  void initState() {
      super.initState();
    _dropDownMenuOfficerRank = buildDropDownMenuOfficerRank(_officerRank);
    _selectedOfficerRank = _dropDownMenuOfficerRank[0].value;
    _dropDownMenuCommand = buildDropDownMenuCommand(_command);
    _selectedCommand = _dropDownMenuCommand[0].value;
    _dropDownMenuRegiment = buildDropDownMenuRegiment(_regiment);
    _selectedRegiment = _dropDownMenuRegiment[0].value;
    _dropDownMenuDepartment = buildDropDownMenuDepartment(_department);
    _selectedDepartment = _dropDownMenuDepartment[0].value;
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

  onChangeDropDownRegiment(Regiment selectedRegiment) {
    setState(() {
      _selectedRegiment = selectedRegiment;
    });
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

  onChangeDropDownDepartment(Department selectedDepartment){
    setState(() {
      _selectedDepartment = selectedDepartment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    'Basic Info',
                   style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 12.0),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Theme.of(context).accentColor,
                    backgroundImage: AssetImage('assets/images/images.png'),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                              //  print('Upload a logo');
                              },
                              child: FlatButton(
                                onPressed: () {
                               //   print('Upload a logo');
                                },
                                child: Text(
                                  'Upload a Picture',
                                  style: TextStyle(
                                      fontSize: textBody1(context),
                                      color: Theme.of(context).accentColor),
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
              SizedBox(height: 15.0),
              Text(' * Select a Industry'),
              // SizedBox(height: 0.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: DropdownButton(
                  iconSize: 30,
                  isExpanded: true,
                  value: _selectedOfficerRank,
                  items: _dropDownMenuOfficerRank,
                  onChanged: onChangeDropDownOfficerRank,
                ),
              ),
              Text(
                'Selected : ${_selectedOfficerRank.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(height: 15.0),
              Text(' * Select a Command'),
              // SizedBox(height: 0.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: DropdownButton(
                  iconSize: 30,
                  isExpanded: true,
                  value: _selectedCommand,
                  items: _dropDownMenuCommand,
                  onChanged: onChangeDropDownCommand,
                ),
              ),
              Text(
                'Selected : ${_selectedCommand.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(height: 15.0),
              Text(' * Select a Regiment'),
              // SizedBox(height: 0.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: DropdownButton(
                  iconSize: 30,
                  isExpanded: true,
                  value: _selectedRegiment,
                  items: _dropDownMenuRegiment,
                  onChanged: onChangeDropDownRegiment,
                ),
              ),
              Text(
                'Selected : ${_selectedRegiment.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
               SizedBox(height: 15.0),
              Text(' * Select a Department'),
              // SizedBox(height: 0.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: DropdownButton(
                  iconSize: 30,
                  isExpanded: true,
                  value: _selectedDepartment,
                  items: _dropDownMenuDepartment,
                  onChanged: onChangeDropDownDepartment,
                ),
              ),
              Text(
                'Selected : ${_selectedDepartment.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(height:55.0),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MilAddInfo()));
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

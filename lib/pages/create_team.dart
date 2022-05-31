import 'dart:math';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/location.dart';
import '../models/user.dart';
// import 'agreementDialog.dart' as fullDialog;

class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  AutoCompleteTextField locationTextField;
  GlobalKey<AutoCompleteTextFieldState<Location>> lkey = new GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime date;
  TextEditingController aboutController = new TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController agendaController = TextEditingController();
  bool isLoading = true;
  bool _displayNameValid = true;
  final format = DateFormat('yyyy-MM-dd');
  bool loading = true;
  bool selectedPrivacy = false;
  bool selectedStatus = false;
  bool onPressed = false;
  bool userAgreed = false;
  bool valueFirst = false;
  String accountType;
  UserModel _user = UserModel();
  var _repository = Repository();
  UserModel currentuser, user, followingUser;
  bool isSelected = false;
  List<String> reportList = [
    "Marketing",
    "Sales",
    "Project",
    "Designing",
    "Production",
    "Maintainance",
    "Store",
    "Procurement",
    "Quality",
    "Inspection",
    "Packaging",
    "Finance",
    "Dispatch",
    "Accounts",
    "Research & Development",
    "Information Technology",
    "Human Resource",
    "Security",
    "Administration",
    "Other"
  ];

  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;

      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentuser = user;
        });
      });
    });
  }

  setselectedPrivacy(bool val) {
    setState(() {
      selectedPrivacy = val;
    });
  }

  setSelectedStatus(bool val) {
    setState(() {
      selectedStatus = val;
    });
  }

  List<String> selectedDepartmentList = [];
  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Departments",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedDepartmentList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: textSubTitle(context),
                      fontFamily: FontNameDefault,
                      color: Colors.black),
                ),
                onPressed: () {
                  //  print('$selectedDepartmentList');
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.white),
                ),
                onPressed: () {
                  print('$selectedDepartmentList');
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget row(Location location) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          location.name,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        // Text(
        //   user.email,
        // ),
      ],
    );
  }

  // Future _openAgreeDialog(context) async {
  //   String result = await Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         return fullDialog.CreateAgreement();
  //       },
  //       //true to display with a dismiss button rather than a return navigation arrow
  //       fullscreenDialog: true));
  //   if (result != null) {
  //     accept(result, context);
  //   } else {
  //     decline(result, context);
  //   }
  // }

  accept(String result, context) {
    setState(() {
      userAgreed = true;
    });
  }

  decline(String result, context) {
    setState(() {
      userAgreed = false;
    });
  }

  submit() async {
    _repository.getCurrentUser().then((currentUser) {
      if (currentUser != null) {
        _repository.retreiveUserDetails(currentUser).then((user) {
          _repository
              .addTeamToDb(
                  user,
                  displayNameController.text,
                  selectedDepartmentList,
                  Colors.primaries[Random().nextInt(Colors.primaries.length)]
                      .value)
              .then((value) {
            print("Team added to db");
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => Home())));
          }).catchError((e) => print("Error adding current team to db : $e"));
        }).catchError((e) {
          print("Error uploading image to storage : $e");
        });
      } else {
        print("Current User is null");
      }
    });

    const snackBar = SnackBar(
      content: Text('Team Created'),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Padding buildTitleLine() {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: screenSize.height * 0.005, left: 0.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: screenSize.width * 0.14,
          height: 2.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        key: _scaffoldKey,
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenSize.width / 11,
                screenSize.height * 0.02,
                screenSize.width / 11,
                screenSize.height * 0.025,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create a Team',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textAppTitle(context),
                            ),
                          ),
                          buildTitleLine()
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.2,
                  ),
                  Image.asset(
                    'assets/images/4380.png',
                    height: screenSize.height * 0.27,
                    width: screenSize.width * 0.9,
                    cacheHeight: 200,
                    cacheWidth: 300,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenSize.height * 0.09,
                          child: TextFormField(
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            controller: displayNameController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                hintText: 'Your Team name',
                                errorText: _displayNameValid
                                    ? null
                                    : 'Name too short'),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        // Text('Add Departments'),
                        InkWell(
                          onTap: _showDialog,
                          child: Chip(
                            label: Text(
                              'Add Departments +',
                              style: TextStyle(
                                  fontSize: textBody1(context),
                                  fontFamily: FontNameDefault,
                                  color: Colors.white),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        getTextWidgets(selectedDepartmentList)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.red,
                      fontSize: textSubTitle(context),
                      fontWeight: FontWeight.bold),
                ),
              ),
              displayNameController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: submit,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.deepPurple,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.002),
                child: chip(items, Colors.grey[600]),
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
          color: Colors.white,
          fontSize: screenSize.height * 0.018,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.01),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              fontSize: textBody1(context),
              fontFamily: FontNameDefault,
              color: Colors.white),
          backgroundColor: Colors.grey[400],
          selectedColor: Theme.of(context).primaryColor,
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

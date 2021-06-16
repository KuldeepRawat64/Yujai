import 'package:Yujai/pages/home.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import '../models/location.dart';
import '../models/user.dart';
import '../style.dart';
import 'agreementDialog.dart' as fullDialog;

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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
    "Be Kind and Courteous",
    "No Hate Speech or Bullying",
    "No Promotions or Spam",
    "Respect Everyone's Privacy",
    "No 18+ content",
    "It’s OK to agree to disagree",
    "Confidentiality"
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

  List<String> selectedReportList = List();
  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Group Rules",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textHeader(context)),
            ),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black),
                ),
                onPressed: () {
                  //  print('$selectedReportList');
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.white),
                ),
                onPressed: () {
                  print('$selectedReportList');
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

  Future _openAgreeDialog(context) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return fullDialog.CreateAgreement();
        },
        //true to display with a dismiss button rather than a return navigation arrow
        fullscreenDialog: true));
    if (result != null) {
      accept(result, context);
    } else {
      decline(result, context);
    }
  }

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
              .addGroupToDb(
                  user,
                  displayNameController.text,
                  aboutController.text,
                  locationController.text,
                  agendaController.text,
                  selectedPrivacy,
                  selectedStatus,
                  selectedReportList)
              .then((value) {
            print("Group added to db");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: ((context) => Home())));
          }).catchError((e) => print("Error adding current post to db : $e"));
        }).catchError((e) {
          print("Error uploading image to storage : $e");
        });
      } else {
        print("Current User is null");
      }
    });

    SnackBar snackbar = SnackBar(content: Text("Group Created!"));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    //Navigator.pop(context);
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
                screenSize.height * 0.01,
                screenSize.width / 11,
                screenSize.height * 0.025,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            size: screenSize.height * 0.05,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: [
                          Text(
                            'Create a Group',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                fontSize: textAppTitle(context)),
                          ),
                          Text(
                            'Fill the details below to continue',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              //color:Colors.grey,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Group Name',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
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
                                hintText: 'Your group name',
                                errorText: _displayNameValid
                                    ? null
                                    : 'Name too short'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desciption',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          // height: screenSize.height * 0.09,
                          child: TextFormField(
                            maxLines: 3,
                            minLines: 3,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            keyboardType: TextInputType.multiline,
                            controller: aboutController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: 'Group details',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agenda',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: screenSize.height * 0.09,
                          child: TextFormField(
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            controller: agendaController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              hintText: 'Purpose of this group',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: screenSize.height * 0.09,
                          child: TextFormField(
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            controller: locationController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              hintText: 'e.g. Mumbai',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.010),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: _showReportDialog,
                            child: Column(
                              children: [
                                Text(
                                  'Select Rules',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                Chip(
                                  label: Text(
                                    'Rules',
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Privacy',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Radio(
                                        value: false,
                                        groupValue: selectedPrivacy,
                                        activeColor: Colors.deepPurpleAccent,
                                        onChanged: (val) {
                                          // print("Gender $val");
                                          setselectedPrivacy(val);
                                        },
                                      ),
                                      Text(
                                        'Public',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Radio(
                                        value: true,
                                        groupValue: selectedPrivacy,
                                        activeColor: Colors.deepPurpleAccent,
                                        onChanged: (val) {
                                          //print("Gender $val");
                                          setselectedPrivacy(val);
                                        },
                                      ),
                                      Text(
                                        'Private',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: screenSize.width / 30,
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Status',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Radio(
                                        value: false,
                                        groupValue: selectedStatus,
                                        activeColor: Colors.deepPurpleAccent,
                                        onChanged: (val) {
                                          //print("Status $val");
                                          setSelectedStatus(val);
                                        },
                                      ),
                                      Text(
                                        'Visible',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Radio(
                                        value: true,
                                        groupValue: selectedStatus,
                                        activeColor: Colors.deepPurpleAccent,
                                        onChanged: (val) {
                                          //print("Status $val");
                                          setSelectedStatus(val);
                                        },
                                      ),
                                      Text(
                                        'Hidden',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.001),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.deepPurpleAccent,
                          value: this.valueFirst,
                          onChanged: (bool value) {
                            setState(() {
                              _openAgreeDialog(context);
                              this.valueFirst = value;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            //_openAgreeDialog(context);
                          },
                          child: Text(
                            'Accept Terms & Conditions',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  valueFirst &&
                          (displayNameController.text.isNotEmpty &&
                                  aboutController.text.isNotEmpty &&
                                  agendaController.text.isNotEmpty ||
                              locationController.text.isNotEmpty)
                      ? GestureDetector(
                          onTap: submit,
                          child: Container(
                            height: screenSize.height * 0.08,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.white,
                                    fontSize: textSubTitle(context),
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: screenSize.height * 0.08,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.white,
                                    fontSize: textSubTitle(context),
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
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

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            color: Colors.white,
          ),
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

import 'package:Yujai/pages/edit_purpose.dart';
import 'package:Yujai/pages/home.dart';
//import 'package:Yujai/pages/login_page.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class SearchPurpose extends StatefulWidget {
  final String currentUserId;
  final String title;
  SearchPurpose({this.currentUserId, this.title});

  @override
  _SearchPurposeState createState() => _SearchPurposeState();
}

class _SearchPurposeState extends State<SearchPurpose>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key;
  List<Purpose> _purposes;
  List<String> _filters;
  bool isLoading = false;
  bool isSelected = false;
  UserModel user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    //  getUser();
    _key = GlobalKey<ScaffoldState>();
    _filters = <String>[];
    _purposes = <Purpose>[
      const Purpose('Full-time jobs'),
      const Purpose('Part-time jobs'),
      const Purpose('Event-based jobs'),
      const Purpose('Task-based jobs'),
      const Purpose('Freelancing'),
      const Purpose('Mentoring'),
      const Purpose('Research & Development'),
      const Purpose('Seeking help'),
      const Purpose('Social work'),
      const Purpose('Promote yourself'),
      const Purpose('Build network'),
      const Purpose('Find opportunities'),
      const Purpose('Career switch'),
    ];
  }

  // getUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
  //   user = User.fromDocument(doc);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  submit() async {
    User currentUser = _auth.currentUser;
    usersRef.doc(currentUser.uid).update({
      "purpose": _filters,
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EditPurpose(
                  purpose: _filters,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.015,
                  horizontal: screenSize.width / 50,
                ),
                child: GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: screenSize.height * 0.055,
                    width: screenSize.width / 5,
                    child: Center(
                        child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.height * 0.018,
                      ),
                    )),
                    decoration: ShapeDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            elevation: 0.5,
            leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black54,
                  size: screenSize.height * 0.06,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text('Purpose',
                style: TextStyle(
                  fontSize: screenSize.height * 0.022,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))),
        key: _key,
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.only(top: screenSize.height * 0.012),
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                    child: Text(
                      '* You can choose any 5 options from below',
                      style: TextStyle(
                        fontSize: screenSize.height * 0.018,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: purposeWidgets.toList(),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Iterable<Widget> get purposeWidgets sync* {
    var screenSize = MediaQuery.of(context).size;
    for (Purpose purpose in _purposes) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Colors.grey[200],
          elevation: 0.0,
          selectedColor: Colors.grey[400],
          labelStyle: TextStyle(
            fontSize: screenSize.height * 0.018,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          avatar: CircleAvatar(
            child: Text(purpose.name[0].toUpperCase()),
          ),
          label: Text(purpose.name),
          selected: _filters.contains(purpose.name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(purpose.name);
                isSelected = selected;
              } else {
                _filters.removeWhere((String name) {
                  return name == purpose.name;
                });
                isSelected = false;
              }
            });
          },
        ),
      );
    }
  }

  Widget chip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(6.0),
    );
  }
}

class Purpose {
  const Purpose(this.name);
  final String name;
}

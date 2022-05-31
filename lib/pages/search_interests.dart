import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'home.dart';

class SearchInterests extends StatefulWidget {
  final String title;
  final String currentUserId;
  SearchInterests({this.title, this.currentUserId});

  @override
  _SearchInterestsState createState() => _SearchInterestsState();
}

class _SearchInterestsState extends State<SearchInterests>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key;
  List<Interest> _interests;
  List<String> _filters;
  bool isLoading = false;
  bool isSelected = false;
  UserModel user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // getUser();
    _key = GlobalKey<ScaffoldState>();
    _filters = <String>[];
    _interests = <Interest>[
      const Interest('Computers'),
      const Interest('Software'),
      const Interest('Finance'),
      const Interest('Management'),
      const Interest('Video Games'),
      const Interest('Artificial Intelligence'),
      const Interest('Creative Writing'),
      const Interest('Renewable Energy'),
      const Interest('Space Exploration'),
      const Interest('Mindfulness'),
      const Interest('Theater'),
      const Interest('Recycling'),
      const Interest('Fashion'),
      const Interest('Food'),
      const Interest('Music'),
      const Interest('Lifestyle'),
      const Interest('Fitness'),
      const Interest('DIY'),
      const Interest('Politics'),
      const Interest('Parenting'),
      const Interest('Business'),
      const Interest('News'),
      const Interest('Caligraphy'),
      const Interest('Travelling'),
      const Interest('Solar Energy'),
      const Interest('Mountain Climbing'),
      const Interest('Photography'),
      const Interest('Design'),
      const Interest('Creative Art'),
      const Interest('Sketching'),
      const Interest('Writing'),
      const Interest('Blogging'),
      const Interest('Podcasting'),
      const Interest('Marketing'),
      const Interest('Sports'),
      const Interest('Reading'),
      const Interest('Public Speaking'),
      const Interest('Camping'),
      const Interest('Exploring other cultures'),
      const Interest('Local meetups'),
      const Interest('Dancing'),
      const Interest('Language classes'),
    ];
  }

  submit() async {
    User currentUser = _auth.currentUser;
    usersRef.doc(currentUser.uid).update({
      "interests": FieldValue.arrayUnion(_filters),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: submit,
                child: Container(
                  height: screenSize.height * 0.055,
                  width: screenSize.width * 0.15,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      color: Colors.white,
                      fontSize: textButton(context),
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
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 0.5,
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Interests',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        key: _key,
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.only(top: screenSize.height * 0.012),
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenSize.height * 0.01,
                    ),
                    child: Text(
                      '* You can choose any 5 options from below',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: interestWidgets.toList(),
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

  Iterable<Widget> get interestWidgets sync* {
    for (Interest interest in _interests) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Colors.grey[200],
          elevation: 0.0,
          selectedColor: Colors.grey[400],
          avatar: CircleAvatar(
            child: Text(interest.name[0].toUpperCase()),
          ),
          label: Text(interest.name),
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textBody1(context),
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          selected: _filters.contains(interest.name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(interest.name);
                isSelected = selected;
              } else {
                _filters.removeWhere((String name) {
                  return name == interest.name;
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
      elevation: 12.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(6.0),
    );
  }
}

class Interest {
  const Interest(this.name);
  final String name;
}

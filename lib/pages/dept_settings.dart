import 'package:Yujai/models/department.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/models/user.dart';

class DeptSettings extends StatefulWidget {
  final String gid;
  final String dId;
  final String name;
  final String description;
  final Team team;
  final Department dept;
  final UserModel currentuser;
  const DeptSettings({
    this.gid,
    this.dId,
    this.name,
    this.currentuser,
    this.team,
    this.dept,
    this.description,
  });
  @override
  _DeptSettingsState createState() => _DeptSettingsState();
}

class _DeptSettingsState extends State<DeptSettings> {
  //Team _team;
  // Department _department;
  bool isPrivate = false;
  bool isHidden = false;
  // UserModel _user;
  // Icon _icon;
  // var _repository = Repository();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // retrieveTeamDetails() async {
  //   //FirebaseUser currentUser = await _repository.getCurrentUser();
  //   Team team = await _repository.retreiveTeamDetails(widget.gid);
  //   if (!mounted) return;
  //   setState(() {
  //     _team = team;
  //   });
  //     Department department =
  //       await _repository.fetchDepartmentDetailsById(widget.gid, widget.dId);
  //   if (!mounted) return;
  //   setState(() {
  //     _department = department;
  //   });
  // }

  Future<IconData> _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context,
        iconPackMode: IconPack.fontAwesomeIcons);

    return icon;
  }

  @override
  void initState() {
    super.initState();
    // retrieveTeamDetails();
    if (!mounted) return;
    _nameController.text = widget.name;
    _descriptionController.text = widget.description;
  }

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      teamsRef
          .doc(widget.team.uid)
          .collection('departments')
          .doc(widget.dept.uid)
          .update({
        "departmentName": _nameController.text,
        "description": _descriptionController.text,
      });
      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          title: Text(
            'Department settings',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.fromLTRB(
                screenSize.width / 11,
                screenSize.height * 0.025,
                screenSize.width / 11,
                screenSize.height * 0.025,
              ),
              children: [
                widget.dept != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Basic Info',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  //color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textHeader(context)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder(
                                stream: teamsRef
                                    .doc(widget.gid)
                                    .collection('departments')
                                    .doc(widget.dId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.active ||
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return CircleAvatar(
                                        radius: screenSize.height * 0.045,
                                        backgroundImage: AssetImage(
                                            'assets/images/error.png'),
                                      );
                                    }
                                    if (snapshot.hasData) {
                                      return Row(
                                        children: [
                                          Container(
                                            width: screenSize.width * 0.1,
                                            height: screenSize.height * 0.06,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  screenSize.height * 0.01),
                                              child: Icon(
                                                deserializeIcon(snapshot.data[
                                                    'departmentProfilePhoto']),
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: ShapeDecoration(
                                              color:
                                                  Color(snapshot.data['color']),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenSize.height *
                                                            0.01),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenSize.width * 0.08,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _pickIcon().then((icon) {
                                                teamsRef
                                                    .doc(widget.team.uid)
                                                    .collection('departments')
                                                    .doc(widget.dept.uid)
                                                    .update({
                                                  'departmentProfilePhoto':
                                                      serializeIcon(icon)
                                                }).catchError((e) => print(
                                                        'Error changing department icon : $e'));
                                              }).catchError((e) =>
                                                  print('Error picking : $e'));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      side: BorderSide(
                                                          width: 0.3,
                                                          color: Colors.grey))),
                                              child: Text(
                                                'Change icon',
                                                style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  // fontSize: textSubTitle(context)
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Select a color',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontSize:
                                                                  textSubTitle(
                                                                      context),
                                                            )),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: BlockPicker(
                                                        pickerColor: Color(
                                                            snapshot
                                                                .data['color']),
                                                        onColorChanged:
                                                            (Color color) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'teams')
                                                              .doc(widget.gid)
                                                              .collection(
                                                                  'departments')
                                                              .doc(widget.dId)
                                                              .update({
                                                            'color': color.value
                                                          }).then((value) =>
                                                                  Navigator.pop(
                                                                      context));
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                StreamBuilder(
                                                    stream: teamsRef
                                                        .doc(widget.gid)
                                                        .collection(
                                                            'departments')
                                                        .doc(widget.dId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return CircleAvatar(
                                                          backgroundColor:
                                                              Color(
                                                                  snapshot.data[
                                                                      'color']),
                                                        );
                                                      }
                                                      return Container();
                                                    }),
                                                Positioned(
                                                    top: 0,
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),
                          ),
                          Container(
                            //   color: const Color(0xffffffff),
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please enter a team name';
                                return null;
                              },
                              onFieldSubmitted: (val) {
                                _nameController.text = val;
                              },
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold),
                              controller: _nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  //  hintText: 'Name',
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.grey,
                                      //   fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context))),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          Container(
                            //      color: const Color(0xffffffff),
                            child: TextFormField(
                              onFieldSubmitted: (val) {
                                _descriptionController.text = val;
                              },
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold),
                              controller: _descriptionController,
                              minLines: 6,
                              maxLines: 6,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  //  hintText: 'Description',
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.grey,
                                      //   fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context))),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                        ],
                      )
                    : Container(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     SizedBox(
                //       height: screenSize.height * 0.02,
                //     ),
                //     Divider(),
                //     Padding(
                //       padding: const EdgeInsets.only(bottom: 10.0),
                //       child: Text(
                //         'Danger zone',
                //         style: TextStyle(
                //             fontFamily: FontNameDefault,
                //             //color: Colors.black54,
                //             fontWeight: FontWeight.bold,
                //             fontSize: textHeader(context)),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: deleteDialog,
                //       child: Container(
                //         decoration: ShapeDecoration(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(6.0),
                //                 side:
                //                     BorderSide(width: 0.5, color: Colors.red))),
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           'Delete team',
                //           style: TextStyle(
                //             fontFamily: FontNameDefault,
                //             color: Colors.red,
                //             fontWeight: FontWeight.bold,
                //             // fontSize: textSubTitle(context)
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                //  Divider(),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenSize.height * 0.02,
                          left: screenSize.width * 0.01,
                          right: screenSize.width * 0.01),
                      child: InkWell(
                        onTap: () {
                          submit(context);
                        },
                        child: Container(
                            //  height: screenSize.height * 0.07,
                            width: screenSize.width * 0.3,
                            decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenSize.height * 0.012),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenSize.height * 0.02,
                          left: screenSize.width * 0.01,
                          right: screenSize.width * 0.01),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            //  height: screenSize.height * 0.07,
                            width: screenSize.width * 0.3,
                            decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey[300]),
                                    borderRadius: BorderRadius.circular(8.0))),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenSize.height * 0.012),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }

  deleteDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              //    overflow: Overflow.visible,
              children: [
                Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Team',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textHeader(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: screenSize.height * 0.09,
                        child: Text(
                          'Are you sure you want to delete this team? This action will delete this team and all the data in this team permanently!',
                          style: TextStyle(color: Colors.black54),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('teams')
                                  .doc(widget.gid)
                                  .get()
                                  .then((doc) {
                                if (doc.exists) {
                                  doc.reference.delete();
                                }
                              }).then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              });
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }
}

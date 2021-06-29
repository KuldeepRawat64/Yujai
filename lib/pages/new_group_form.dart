import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';
import 'agreementDialog.dart' as fullDialog;
import '../style.dart';

class NewGroupForm extends StatefulWidget {
  final UserModel currentUser;

  const NewGroupForm({Key key, this.currentUser}) : super(key: key);
  @override
  _NewGroupFormState createState() => _NewGroupFormState();
}

class _NewGroupFormState extends State<NewGroupForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  var _detailController;
  var _captionController;
  var _locationController;
  var _agendaController;
  final _repository = Repository();
  String location = '';
  bool isSelected = false;
  bool selectedPrivacy = false;
  bool selectedStatus = false;
  bool onPressed = false;
  bool userAgreed = false;
  bool valueFirst = false;

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
    _captionController = TextEditingController();
    _detailController = TextEditingController();
    _locationController = TextEditingController();
    _agendaController = TextEditingController();
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

  List<String> selectedDepartmentList = List();
  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Departments",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                  ),
                ),
                // SizedBox(
                //   width: 10.0,
                // ),
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.close),
                  ),
                )
              ],
            ),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedDepartmentList = selectedList;
                });
              },
            ),
            // actions: <Widget>[
            //   FlatButton(
            //     child: Text(
            //       "Cancel",
            //       style: TextStyle(
            //           fontSize: textSubTitle(context),
            //           fontFamily: FontNameDefault,
            //           color: Colors.black),
            //     ),
            //     onPressed: () {
            //       //  print('$selectedDepartmentList');
            //       Navigator.of(context).pop();
            //     },
            //   ),
            //   FlatButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(40.0)),
            //     color: Theme.of(context).primaryColor,
            //     child: Text(
            //       "Submit",
            //       style: TextStyle(
            //           fontFamily: FontNameDefault,
            //           fontSize: textSubTitle(context),
            //           color: Colors.white),
            //     ),
            //     onPressed: () {
            //       print('$selectedDepartmentList');
            //       Navigator.of(context).pop();
            //     },
            //   )
            // ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                screenSize.height * 0.01,
                0,
                screenSize.height * 0.025,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                    child: TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                      ),
                      controller: _captionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],

                        labelText: 'Group name',
                        hintStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: new BorderRadius.circular(10),
                        // ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Enter a group name';
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                    child: TextFormField(
                      maxLines: 3,
                      minLines: 3,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                      ),
                      keyboardType: TextInputType.multiline,
                      controller: _detailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],

                        labelText: 'Description',
                        hintStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: new BorderRadius.circular(10),
                        // ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Enter a description';
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                    child: TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                      ),
                      controller: _agendaController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Agenda',
                        hintStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                    child: TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                      ),
                      controller: _locationController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Location',
                        hintStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.01),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: screenSize.height * 0.05,
                          // ),
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
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                    child: InkWell(
                      onTap: _showReportDialog,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Select Rules',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Chip(
                            label: Text(
                              'Rules',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.white),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical: screenSize.height * 0.001),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Checkbox(
                  //         checkColor: Colors.white,
                  //         activeColor: Colors.deepPurpleAccent,
                  //         value: this.valueFirst,
                  //         onChanged: (bool value) {
                  //           setState(() {
                  //             _openAgreeDialog(context);
                  //             this.valueFirst = value;
                  //           });
                  //         },
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           //_openAgreeDialog(context);
                  //         },
                  //         child: Text(
                  //           'Accept Terms & Conditions',
                  //           style: TextStyle(
                  //               fontFamily: FontNameDefault,
                  //               fontSize: textBody1(context)),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.01,
                  left: screenSize.width * 0.01,
                  right: screenSize.width * 0.01),
              child: InkWell(
                onTap: () {
                  _submitForm(context);
                },
                child: Container(
                    height: screenSize.height * 0.07,
                    width: screenSize.width * 0.8,
                    decoration: ShapeDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.height * 0.015),
                      child: Center(
                        child: Text(
                          'Create',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textAppTitle(context),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
              ),
            )

            // FlatButton(
            //     child: Text('Submit'),
            //     onPressed: () {
            //       _submitForm(context);
            //     }),
          ],
        ),
      ),
    );
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  // getUserLocation() async {
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemarks = await Geolocator()
  //       .placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placemarks[0];
  //   String completeAddress =
  //       '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
  //   print(completeAddress);
  //   String formattedAddress = "${placemark.locality}, ${placemark.country}";
  //   setState(() {
  //     location = formattedAddress;
  //   });
  // }

  _submitForm(BuildContext context) {
    //
    if (_formKey.currentState.validate()) {
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null) {
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository
                .addGroupToDb(
                    user,
                    _captionController.text,
                    _detailController.text,
                    _locationController.text,
                    _agendaController.text,
                    selectedPrivacy,
                    selectedStatus,
                    selectedReportList)
                .then((value) {
              print("Team added to db");
            }).catchError((e) => print("Error adding current team to db : $e"));
          }).catchError((e) {
            print("Error uploading image to storage : $e");
          });
        } else {
          print("Current User is null");
        }
      });
      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.002),
                child: chip(items, Colors.grey[500]),
              ))
          .toList(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      deleteIcon: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey[600])],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          size: 20,
          color: Colors.white,
        ),
      ),
      onDeleted: () {
        setState(() {
          selectedDepartmentList.remove(label);
        });
      },
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
  List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
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

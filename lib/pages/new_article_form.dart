import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/pages/places_location.dart';
import 'package:Yujai/widgets/custom_drop_down.dart';
import 'package:Yujai/widgets/custom_radio_button.dart';
import 'package:Yujai/widgets/education_widget.dart';
import 'package:Yujai/widgets/flow_widget.dart';
import 'package:Yujai/widgets/skill_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../style.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:date_field/date_field.dart';

class NewArticleForm extends StatefulWidget {
  final User currentUser;

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  const NewArticleForm({
    Key key,
    this.currentUser,
  }) : super(key: key);
  @override
  _NewJobFormState createState() => _NewJobFormState();
}

class _NewJobFormState extends State<NewArticleForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  var _locationController;
  var _captionController;
  TextEditingController articleTitleController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final _repository = Repository();
  String location = '';
  final format = DateFormat('yyyy-MM-dd');
  int startDate = 0;
  int endDate = 0;
  int startTime = 0;
  int endTime = 0;
  double lat, lng;
  PickResult selectedPlace;
  bool isVisible = false;
  double number = 5;
  bool skillFirst = false;
  bool skillSecond = false;
  bool skillThird = false;
  User _user;
  List<dynamic> selectedSkills = [];
  String valueEmpType;
  String valueIndustry;

  List<String> categoryList = [
    'Conference',
    'Seminar',
    'Covention',
    'Festival',
    'Fair',
    'Concert',
    'Performance',
    'Screening',
    'Dinner',
    'Gala',
    'Class',
    'Training',
    'Workshop',
    'Party',
    'Social Gathering',
    'Rally',
    'Tournament',
    'Game',
    'Endurance',
    'Tour',
    'Other',
  ];
  List industries = [
    'Architecture and planning',
    'Art, culture and sport',
    'Auditing, tax and law',
    'Automotive and vehicle manufacturing',
    'Banking and financial services',
    'Civil service, associations and institutions',
    'Consulting',
    'Consumer goods and trade',
    'Education and science',
    'Energy, water and environment',
    'HR services',
    'Health and social',
    'Insurance',
    'Internet and IT',
    'Marketing, PR and design',
    'Media and publishing',
    'Medical services',
    'Other services',
    'Real Estate',
    'Telecommunication',
    'Tourism and food service',
    'Transport and logistics',
  ];

  @override
  void initState() {
    super.initState();
    super.initState();
    retrieveUserDetails();
  }

  getPercent(double level) {
    if (level == 0) {
      return 0.0;
    } else {
      return level / 10 * 1.0;
    }
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  Widget getSkillsListView(List<dynamic> skills) {
    var screenSize = MediaQuery.of(context).size;
    selectedSkills = skills;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Skills",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            color: Colors.black87,
            fontSize: textHeader(context),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: skills.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skills[index]['skill'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      //     color: Colors.white,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      LinearPercentIndicator(
                        width: screenSize.width * 0.65,
                        backgroundColor: Colors.grey[100],
                        //  lineHeight: 10.0,
                        animation: true,
                        animationDuration: 500,
                        progressColor: Theme.of(context).primaryColor,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        //   fillColor: Theme.of(context).primaryColor,
                        percent: getPercent(skills[index]['level']),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            skills.removeAt(index);
                          });
                        },
                        child: Icon(
                          Icons.cancel_rounded,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              );
            }),
      ],
    );
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
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
              child: Container(
                height: screenSize.height * 0.25,
                width: screenSize.width,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: imageFile != null
                    ? Stack(
                        overflow: Overflow.visible,
                        children: [
                          Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                            height: screenSize.height * 0.25,
                            width: screenSize.width,
                          ),
                          Positioned(
                            right: 5.0,
                            top: 5.0,
                            child: InkResponse(
                              onTap: () {
                                if (imageFile != null) {
                                  setState(() {
                                    imageFile = null;
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 15,
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _pickImage('Gallery').then((selectedImage) {
                                setState(() {
                                  imageFile = selectedImage;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/picture.png',
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextFormField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context)),
              decoration: InputDecoration(
                // icon: Icon(
                //   Icons.work_outline,
                //   size: screenSize.height * 0.035,
                //   color: Colors.black54,
                // ),
                filled: true,
                fillColor: Colors.grey[100],
                //   hintText: 'Designation',
                labelText: 'Article title',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.grey,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              controller: articleTitleController,
              validator: (value) {
                if (value.isEmpty) return "Please enter an article headline";
                return null;
              },
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextFormField(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context)),
              decoration: InputDecoration(
                // icon: Icon(
                //   Icons.work_outline,
                //   size: screenSize.height * 0.035,
                //   color: Colors.black54,
                // ),
                filled: true,
                fillColor: Colors.grey[100],
                //   hintText: 'Designation',
                labelText: 'Article source',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.grey,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              controller: websiteController,
              validator: (value) {
                if (value.isEmpty)
                  return "Please enter the source of this article";
                return null;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            imageFile == null
                ? Column(
                    children: [
                      Text(
                        'Add article image to continue',
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            color: Colors.red),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenSize.height * 0.01,
                          //left: screenSize.width * 0.01,
                          //right: screenSize.width * 0.01
                        ),
                        child: InkWell(
                          onTap: () {
                            //   _submitForm(context);
                          },
                          child: Container(
                              height: screenSize.height * 0.07,
//width: screenSize.width * 0.8,
                              decoration: ShapeDecoration(
                                  color: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.2, color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.height * 0.015),
                                child: Center(
                                  child: Text(
                                    'Create',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textAppTitle(context),
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.01,
                      //           left: screenSize.width * 0.01,
                      //            right: screenSize.width * 0.01
                    ),
                    child: InkWell(
                      onTap: () {
                        _submitForm(context);
                      },
                      child: Container(
                          height: screenSize.height * 0.07,
                          //        width: screenSize.width * 0.8,
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

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      _locationController.text = formattedAddress;
    });
  }

  _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null) {
          compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository.uploadImageToStorage(imageFile).then((url) {
              _repository
                  .addNewsToDb(
                user,
                url,
                articleTitleController.text,
                websiteController.text,
              )
                  .then((value) {
                print('News added to db');
              }).catchError(
                      (e) => print('Error adding current news to db : $e'));
            }).catchError((e) {
              print('Error uploading image to storage : $e');
            });
          });
        } else {
          print('Current User is null');
        }
      });

      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }

  String selectedEventList = "";
  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Event Category",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
            content: MultiSelectChipSingle(
              categoryList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedEventList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: textSubTitle(context),
                      fontFamily: FontNameDefault,
                      color: Colors.black),
                ),
                onPressed: () {
                  //  print('$selectedEventList');
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
                  print('$selectedEventList');
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class MultiSelectChipSingle extends StatefulWidget {
  final List<String> categoryList;
  final Function(String) onSelectionChanged;
  MultiSelectChipSingle(this.categoryList, {this.onSelectionChanged});
  @override
  _MultiSelectChipSingleState createState() => _MultiSelectChipSingleState();
}

class _MultiSelectChipSingleState extends State<MultiSelectChipSingle> {
  String selectedChoice = "";
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.categoryList.forEach((item) {
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
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              widget.onSelectionChanged(selectedChoice);
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

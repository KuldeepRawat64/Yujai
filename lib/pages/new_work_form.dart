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

class NewWorkForm extends StatefulWidget {
  final User currentUser;

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  const NewWorkForm({
    Key key,
    this.currentUser,
  }) : super(key: key);
  @override
  _NewWorkFormState createState() => _NewWorkFormState();
}

class _NewWorkFormState extends State<NewWorkForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  var _locationController;
  var _captionController;
  var _dateStartController;
  var _timeStartController;
  var _dateEndController;
  var _timeEndController;
  var _descriptionController;
  var _hostController;
  var _portfolioController;
  var _ticketWebsiteController;
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

  @override
  void initState() {
    super.initState();
    super.initState();
    retrieveUserDetails();
    _captionController = TextEditingController();
    _locationController = TextEditingController();
    _locationController.text = widget.currentUser.location;
    _dateStartController = TextEditingController();
    _timeStartController = TextEditingController();
    _dateEndController = TextEditingController();
    _timeEndController = TextEditingController();
    _descriptionController = TextEditingController();
    _descriptionController.text = widget.currentUser.bio;
    _hostController = TextEditingController();
    _portfolioController = TextEditingController();
    _portfolioController.text = widget.currentUser.website;
    _ticketWebsiteController = TextEditingController();
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
            Container(
              margin: EdgeInsets.only(top: screenSize.height * 0.01),
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              height: screenSize.height * 0.2,
              width: screenSize.width,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black45,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black45,
                        ),
                        Icon(
                          Icons.work,
                          color: Colors.black87,
                        )
                      ],
                    ),
                    Text(
                      'Skills, work experiences and other professional informations from your profile will be added to this work applications automatically.',
                      style: TextStyle(
                          fontFamily: FontNameDefault, color: Colors.black45),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
                //   left: screenSize.width * 0.1,
                //    right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _captionController,
                key: Key("designationField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: "Job Title",
                  labelStyle: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return "Please enter a title for your application";
                  return null;
                },
              ),
            ),
            isVisible
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          //   left: 0,
                          //    left: screenSize.width * 0.06,
                          //     right: screenSize.width * 0.1,
                          bottom: screenSize.height * 0.01,
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          controller: _portfolioController,
                          key: Key("portfolioField"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            icon: IconButton(
                              icon: Icon(
                                Icons.web_asset,
                                color: Colors.black54,
                              ),
                              onPressed: null,
                            ),
                            labelText: "Portfolio Website",
                            labelStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              //fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          //   left: 0,
                          //      left: screenSize.width * 0.06,
                          //      right: screenSize.width * 0.1,
                          bottom: screenSize.height * 0.01,
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          controller: _locationController,
                          key: Key("locationField"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            icon: IconButton(
                              icon: Icon(
                                Icons.location_on_outlined,
                                color: Colors.black54,
                              ),
                              onPressed: null,
                            ),
                            labelText: "Location",
                            labelStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              //fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          // validator: (value) {
                          //   if (value.isEmpty)
                          //     return "Please enter a text for your post";
                          //   return null;
                          // },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          //      left: screenSize.width * 0.06,
                          //       right: screenSize.width * 0.1,
                          bottom: screenSize.height * 0.01,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          controller: _descriptionController,
                          key: Key("descriptionField"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            icon: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.black54,
                              ),
                              onPressed: null,
                            ),
                            labelText: "Bio",
                            labelStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              //fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter a detail for your application";
                            return null;
                          },
                        ),
                      ),
                      _user.education != []
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Education",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    color: Colors.black87,
                                    fontSize: textHeader(context),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  // margin: EdgeInsets.symmetric(
                                  //     horizontal: screenSize.width * 0.035,
                                  //     vertical: screenSize.height * 0.02),
                                  child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return FlowEducationRow(FlowEducation(
                                            isPresent: _user.education[index]
                                                ['isPresent'],
                                            university: _user.education[index]
                                                ['university'],
                                            degree: _user.education[index]
                                                ['degree'],
                                            field: _user.education[index]
                                                ['field'],
                                            startDate: _user.education[index]
                                                ['startUniversity'],
                                            endDate: _user.education[index]
                                                ['endUniversity']));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 2,
                                        );
                                      },
                                      itemCount: _user.education.length),
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.25,
                                  vertical: screenSize.height * 0.01),
                              child: Text(
                                'Add your Education details to show in your profile',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: FontNameDefault,
                                    color: Colors.grey,
                                    fontSize: textBody1(context)),
                              ),
                            ),
                      _user.experience != []
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Experience",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    color: Colors.black87,
                                    fontSize: textHeader(context),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  // margin: EdgeInsets.symmetric(
                                  //     horizontal: screenSize.width * 0.2,
                                  //     vertical: screenSize.height * 0.02
                                  //     ),
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      Positioned(
                                          left: 21,
                                          top: 15,
                                          bottom: 15,
                                          child: VerticalDivider(
                                            width: 1,
                                            color: Colors.black54,
                                          )),
                                      ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return FlowEventRow(FlowEvent(
                                                employmentType:
                                                    _user.experience[index]
                                                        ['employmentType'],
                                                isPresent:
                                                    _user.experience[index]
                                                        ['isPresent'],
                                                industry:
                                                    _user.experience[index]
                                                        ['industry'],
                                                company: _user.experience[index]
                                                    ['company'],
                                                designation:
                                                    _user.experience[index]
                                                        ['designation'],
                                                startDate:
                                                    _user.experience[index]
                                                        ['startCompany'],
                                                endDate: _user.experience[index]
                                                    ['endCompany']));
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              height: 2,
                                            );
                                          },
                                          itemCount: _user.experience.length)
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      _user.skills == []
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.25,
                                  vertical: screenSize.height * 0.01),
                              child: Text(
                                'Add your Skills to grab attention of similar minded people or companies',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : getSkillsListView(_user.skills),
                    ],
                  )
                : Container(),
            isVisible
                ? Padding(
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
                : Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.01,
                      //        left: screenSize.width * 0.01,
                      //         right: screenSize.width * 0.01
                    ),
                    child: InkWell(
                      onTap: () {
                        _submitForm(context);

                        setState(() {
                          isVisible = true;
                        });
                      },
                      child: Container(
                          height: screenSize.height * 0.07,
                          //   width: screenSize.width * 0.8,
                          decoration: ShapeDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          child: Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.015),
                            child: Center(
                              child: Text(
                                'Review',
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
          //    compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            //   _repository.uploadImageToStorage(imageFile).then((url) {
            _repository
                .addPromotionToDb(
                    user,
                    _captionController.text,
                    _locationController.text,
                    _portfolioController.text,
                    _descriptionController.text,
                    selectedSkills,
                    _user.experience,
                    _user.education)
                .catchError((e) =>
                    print('Error adding current application to db : $e'));
            //    }).catchError((e) {
            //        print('Error uploading image to storage : $e');
            //       });
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

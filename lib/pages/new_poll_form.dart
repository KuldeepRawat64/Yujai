import 'package:Yujai/widgets/custom_radio_button.dart';
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
import '../style.dart';

class NewPollForm extends StatefulWidget {
  final Group group;
  final UserModel currentUser;

  const NewPollForm({Key key, this.group, this.currentUser}) : super(key: key);
  @override
  _NewPollFormState createState() => _NewPollFormState();
}

class _NewPollFormState extends State<NewPollForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  List<RadioModel> sampleData = List<RadioModel>();
  File imageFile;
  var _option1Controller;
  var _captionController;
  var _option2Controller;
  var _option3Controller;
  var _option4Controller;
  final _repository = Repository();
  String location = '';
  var _currentDate = DateTime.now();
  var threeHoursFromNow = DateTime.now().add(new Duration(hours: 3));
  var sixHoursFromNow = DateTime.now().add(new Duration(hours: 6));
  var oneDayFromNow = DateTime.now().add(new Duration(days: 1));
  var twoDaysFromNow = DateTime.now().add(new Duration(days: 2));
  //var seletedTime;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
    _option1Controller = TextEditingController();
    _option2Controller = TextEditingController();
    _option3Controller = TextEditingController();
    _option4Controller = TextEditingController();
    sampleData.add(RadioModel(false, '3 h', '3h'));
    sampleData.add(RadioModel(true, '6 h', '6h'));
    sampleData.add(RadioModel(false, '1 d', '1d'));
    sampleData.add(RadioModel(false, '2 d', '2d'));
  }

  checkSelected(RadioModel _item) {
    if (_item.subText == '3h') {
      setState(() {
        _currentDate = threeHoursFromNow;
      });
    } else if (_item.subText == '6h') {
      setState(() {
        _currentDate = sixHoursFromNow;
      });
    } else if (_item.subText == '1d') {
      setState(() {
        _currentDate = oneDayFromNow;
      });
    } else if (_item.subText == '2d') {
      setState(() {
        _currentDate = twoDaysFromNow;
      });
    } else {
      setState(() {
        _currentDate = sixHoursFromNow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.02,
                    right: screenSize.width * 0.1,
                    left: screenSize.width * 0.1,
                    bottom: screenSize.height * 0.02,
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    maxLength: 350,
                    minLines: 1,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    controller: _captionController,
                    key: Key("nameField"),
                    //   onSaved: (val) => post.caption = val,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Ask a question',
                      labelStyle: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter a text for your poll";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenSize.height * 0.01,
                    left: screenSize.width * 0.1,
                  ),
                  child: Text(
                    'Choose your options',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    //   left: 0,
                    left: screenSize.width * 0.1,
                    right: screenSize.width * 0.1,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 25,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      //    fontWeight: FontWeight.bold,
                    ),
                    controller: _option1Controller,
                    key: Key("option1Field"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: _option1Controller.text == ''
                          ? Text('')
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                              onPressed: () {
                                if (_option1Controller.text == '') {
                                  return;
                                } else {
                                  setState(() {
                                    _option1Controller.text = '';
                                  });
                                }
                              },
                            ),
                      labelText: "Option #1",
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
                        return "Please enter an option #1 for your poll";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    //   left: 0,
                    left: screenSize.width * 0.1,
                    right: screenSize.width * 0.1,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 25,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      //     fontWeight: FontWeight.bold,
                    ),
                    controller: _option2Controller,
                    key: Key("option2Field"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: _option2Controller.text == ''
                          ? Text('')
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                              onPressed: () {
                                if (_option2Controller.text == '') {
                                  return;
                                } else {
                                  setState(() {
                                    _option2Controller.text = '';
                                  });
                                }
                              },
                            ),
                      labelText: "Option #2",
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
                        return "Please enter an option #2 for your poll";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    //   left: 0,
                    left: screenSize.width * 0.1,
                    right: screenSize.width * 0.1,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 25,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      //    fontWeight: FontWeight.bold,
                    ),
                    controller: _option3Controller,
                    key: Key("option3Field"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: _option3Controller.text == ''
                          ? Text('')
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                              onPressed: () {
                                if (_option3Controller.text == '') {
                                  return;
                                } else {
                                  setState(() {
                                    _option3Controller.text = '';
                                  });
                                }
                              },
                            ),
                      labelText: "Option #3",
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
                    left: screenSize.width * 0.1,
                    right: screenSize.width * 0.1,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 25,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      //     fontWeight: FontWeight.bold,
                    ),
                    controller: _option4Controller,
                    key: Key("option4Field"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: _option4Controller.text == ''
                          ? Text('')
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                              onPressed: () {
                                if (_option4Controller.text == '') {
                                  return;
                                } else {
                                  setState(() {
                                    _option4Controller.text = '';
                                  });
                                }
                              },
                            ),
                      labelText: "Option #4",
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
                    //   bottom: screenSize.height * 0.01,
                    left: screenSize.width * 0.1,
                    top: screenSize.height * 0.01,
                  ),
                  child: Text(
                    'Choose poll length',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: screenSize.height * 0.12,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    //   physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sampleData.length,
                    // itemExtent: screenSize.height * 0.15,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        // height: 60.0,
                        width: screenSize.width * 0.22,
                        child: InkWell(
                          //highlightColor: Colors.red,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              sampleData.forEach(
                                  (element) => element.isSelected = false);
                              sampleData[index].isSelected = true;
                            });
                            checkSelected(sampleData[index]);
                          },
                          child: RadioItem(sampleData[index]),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.01,
                      left: screenSize.width * 0.1,
                      right: screenSize.width * 0.1),
                  child: InkWell(
                    onTap: () {
                      _submitForm(context);
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //    width: screenSize.width * 0.8,
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
        if (currentUser != null &&
                currentUser.uid == widget.group.currentUserUid ||
            widget.group.isPrivate == false) {
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository
                .addPollToForum(
                  widget.group.uid,
                  user,
                  _captionController.text,
                  'poll',
                  _currentDate.millisecondsSinceEpoch,
                  _option1Controller.text,
                  _option2Controller.text,
                  _option3Controller.text,
                  _option4Controller.text,
                )
                .catchError(
                    (e) => print("Error adding current post to db : $e"));
          });
        } else {
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository
                .addPollToReview(
                  widget.group.uid,
                  user,
                  _captionController.text,
                  'poll',
                  _currentDate.millisecondsSinceEpoch,
                  _option1Controller.text,
                  _option2Controller.text,
                  _option3Controller.text,
                  _option4Controller.text,
                )
                .catchError(
                    (e) => print("Error adding current post to db : $e"));
          });
        }
      });
      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }
}

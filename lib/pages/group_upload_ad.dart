import 'dart:io';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:Yujai/models/group.dart';

import '../style.dart';

// ignore: must_be_immutable
class GroupUploadAd extends StatefulWidget {
  final String gid;
  final String name;
  File imageFile;
  final Group group;

  GroupUploadAd({this.gid, this.name, this.imageFile, this.group});

  @override
  _GroupUploadAdState createState() => _GroupUploadAdState();
}

class _GroupUploadAdState extends State<GroupUploadAd> {
  var _locationController;
  var _captionController;
  var _aboutController;
  var _priceController = CurrencyTextFieldController(
      decimalSymbol: "", thousandSymbol: ",", rightSymbol: "INR ");
  final _repository = Repository();

  List<String> reportList = ["New", "Used", "Like New", "Good", "Ok"];
  String selectedReportList;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
    _aboutController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
    _aboutController?.dispose();
    _priceController?.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // centerTitle: true,
          title: Text(
            'Create an Ad',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: textAppTitle(context)),
          ),
          backgroundColor: const Color(0xffffffff),
          actions: <Widget>[
            _visibility
                ? Padding(
                    padding: EdgeInsets.only(
                      right: screenSize.width / 30,
                    ),
                    child: GestureDetector(
                      child: Icon(
                        Icons.send,
                        size: screenSize.height * 0.035,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        // To show the CircularProgressIndicator
                        _changeVisibility(false);

                        _repository.getCurrentUser().then((currentUser) {
                          if (currentUser != null &&
                                  currentUser.uid ==
                                      widget.group.currentUserUid ||
                              widget.group.isPrivate == false) {
                            compressImage();
                            _repository
                                .retreiveUserDetails(currentUser)
                                .then((user) {
                              _repository
                                  .uploadImageToStorage(widget.imageFile)
                                  .then((url) {
                                _repository
                                    .addAdToForum(
                                        widget.gid,
                                        user,
                                        url,
                                        _captionController.text,
                                        _aboutController.text,
                                        _priceController.text,
                                        selectedReportList,
                                        _locationController.text)
                                    .then((value) {
                                  print("Ad added to db");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => GroupPage(
                                                isMember: false,
                                                currentUser: user,
                                                gid: widget.gid,
                                                name: widget.name,
                                              ))));
                                }).catchError((e) => print(
                                        "Error adding current post to db : $e"));
                              }).catchError((e) {
                                print("Error uploading image to storage : $e");
                              });
                            });
                          } else {
                            compressImage();
                            _repository
                                .retreiveUserDetails(currentUser)
                                .then((user) {
                              _repository
                                  .uploadImageToStorage(widget.imageFile)
                                  .then((url) {
                                _repository
                                    .addAdToReview(
                                        widget.gid,
                                        user,
                                        url,
                                        _captionController.text,
                                        _aboutController.text,
                                        _priceController.text,
                                        selectedReportList,
                                        _locationController.text,
                                        'marketplace')
                                    .then((value) {
                                  print("Ad added to review");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => GroupPage(
                                                isMember: false,
                                                currentUser: user,
                                                gid: widget.gid,
                                                name: widget.name,
                                              ))));
                                }).catchError((e) => print(
                                        "Error adding current post to db : $e"));
                              }).catchError((e) {
                                print("Error uploading image to storage : $e");
                              });
                            });
                          }
                        });
                      },
                    ),
                  )
                : Container()
          ],
        ),
        body: ListView(
          children: <Widget>[
            !_visibility ? linearProgress() : Container(),
            Column(children: [
              widget.imageFile != null
                  ? Container(
                      width: screenSize.width / 1.8,
                      height: screenSize.height * 0.2,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(widget.imageFile),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Text(
                'Note: Choose image that have clear information about your ad.',
                style: TextStyle(
                    fontSize: textBody1(context),
                    fontFamily: FontNameDefault,
                    color: Colors.black54,
                    decoration: TextDecoration.underline),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screenSize.width / 30,
                  screenSize.height * 0.01,
                  screenSize.width / 30,
                  screenSize.height * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      //  color: const Color(0xffffffff),
                      width: screenSize.width,
                      child: TextField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                        controller: _captionController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: "Write a title...",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      // color: const Color(0xffffffff),
                      width: screenSize.width,
                      child: TextField(
                        //  maxLength: 1000,
                        minLines: 4,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                        controller: _aboutController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: "Detail about your product",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      'Select product condition',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MultiSelectChip(
                      reportList,
                      onSelectionChanged: (selectedList) {
                        setState(() {
                          selectedReportList = selectedList;
                        });
                      },
                    ),
                    //  Text(selectedReportList.toString()),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    Text(
                      'Price',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      //    color: const Color(0xffffffff),
                      width: screenSize.width,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                        controller: _priceController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: "Price",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      //    color: const Color(0xffffffff),
                      width: screenSize.width,
                      child: TextField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                        controller: _locationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          hintText: "Location",
                        ),
                      ),
                    ),
                    Container(
                      width: screenSize.width,
                      color: const Color(0xffffffff),
                      alignment: Alignment.center,
                      child: RaisedButton.icon(
                        label: Text(
                          "Use Current Location",
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenSize.height * 0.05),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: getUserLocation,
                        icon: Icon(
                          Icons.my_location,
                          size: screenSize.height * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      widget.imageFile = newim2;
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
    _locationController.text = formattedAddress;
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(String) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Theme.of(context).primaryColor,
          label: Text(
            item,
            style: TextStyle(
                fontSize: textBody1(context),
                fontFamily: FontNameDefault,
                color: selectedChoice == item ? Colors.white : Colors.black),
          ),
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

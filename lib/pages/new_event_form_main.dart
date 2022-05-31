import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/pages/places_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import '../style.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:date_field/date_field.dart';

class NewEventFormMain extends StatefulWidget {
  final UserModel currentUser;
  final bool isOnline;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  const NewEventFormMain({Key key, this.currentUser, this.isOnline})
      : super(key: key);
  @override
  _NewEventFormState createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventFormMain> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  var _locationController;
  var _captionController;
  var _descriptionController;
  var _hostController;
  var _eventWebsiteController;
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
    _captionController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();
    _hostController = TextEditingController();
    _eventWebsiteController = TextEditingController();
    _ticketWebsiteController = TextEditingController();
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
                height: screenSize.height * 0.15,
                width: screenSize.width,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: imageFile != null
                    ? Stack(
                        clipBehavior: Clip.none,
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
                                child: Icon(Icons.close),
                                backgroundColor: Colors.grey,
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
                                  'Add Cover',
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
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
                // left: screenSize.width * 0.1,
                // right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _captionController,
                key: Key("nameField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: "Event Name",
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
                  if (value.isEmpty) return "Please enter a text for your post";
                  return null;
                },
              ),
            ),
            widget.isOnline
                ? Padding(
                    padding: EdgeInsets.only(
                      //   left: 0,
                      // left: screenSize.width * 0.06,
                      // right: screenSize.width * 0.1,
                      bottom: screenSize.height * 0.01,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _eventWebsiteController,
                      key: Key("eventWebsiteField"),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        icon: IconButton(
                          icon: Icon(
                            Icons.web_outlined,
                            color: Colors.black54,
                          ),
                          onPressed: null,
                        ),
                        labelText: "Event Website",
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
                          return "Please enter a text for your post";
                        return null;
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      //   left: 0,
                      // left: screenSize.width * 0.06,
                      // right: screenSize.width * 0.1,
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
                        suffixIcon: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return SafeArea(
                                    child: PlacePicker(
                                      apiKey: APIKeys.apiKey,
                                      initialPosition:
                                          PlacesLocation.kInitialPosition,
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,

                                      //usePlaceDetailSearch: true,
                                      onPlacePicked: (result) {
                                        selectedPlace = result;
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _locationController.text =
                                              selectedPlace.formattedAddress;
                                          // location =
                                          //     selectedPlace.types.elementAt(1);
                                        });
                                      },
                                      //forceSearchOnZoomChanged: true,
                                      //automaticallyImplyAppBarLeading: false,
                                      //autocompleteLanguage: "ko",
                                      //region: 'au',
                                      //selectInitialPosition: true,
                                      selectedPlaceWidgetBuilder: (_,
                                          selectedPlace,
                                          state,
                                          isSearchBarFocused) {
                                        print(
                                            "state: $state, isSearchBarFocused: $isSearchBarFocused");
                                        return isSearchBarFocused
                                            ? Container()
                                            : FloatingCard(
                                                bottomPosition:
                                                    0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                                leftPosition: 65.0,
                                                rightPosition: 65.0,
                                                //width: 50,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: state ==
                                                        SearchingState.Searching
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : ElevatedButton(
                                                        child: Text(
                                                          "Pick Here",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                          //            this will override default 'Select here' Button.
                                                          lat = selectedPlace
                                                              .geometry
                                                              .location
                                                              .lat;
                                                          lng = selectedPlace
                                                              .geometry
                                                              .location
                                                              .lng;
                                                          print(
                                                              "do something with [selectedPlace] data");
                                                          _locationController
                                                                  .text =
                                                              selectedPlace
                                                                  .formattedAddress;
                                                          location = selectedPlace
                                                              .addressComponents[
                                                                  2]
                                                              .longName;
                                                          print(location);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                              );
                                      },
                                      // pinBuilder: (context, state) {
                                      //   if (state == PinState.Idle) {
                                      //     return Icon(Icons.favorite_border);
                                      //   } else {
                                      //     return Icon(Icons.favorite);
                                      //   }
                                      // },
                                    ),
                                  );
                                },
                              ));
                            },
                            child: Icon(Icons.location_pin, size: 15.0)),
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
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please enter a text for your post";
                        return null;
                      },
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(
                  // left: screenSize.width * 0.06,
                  // right: screenSize.width * 0.05,
                  //  bottom: screenSize.height * 0.02,
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenSize.width * 0.5,
                    child: DateTimeFormField(
                      dateTextStyle: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          isDense: true,
                          icon: IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.black54,
                            ),
                            onPressed: null,
                          ),
                          labelText: 'Start Date',
                          hintStyle: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          startDate = value.millisecondsSinceEpoch;
                        });
                        print(value);
                      },
                      onSaved: (DateTime value) {
                        setState(() {
                          startDate = value.millisecondsSinceEpoch;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        //   bottom: screenSize.height * 0.02,
                        // right: screenSize.width * 0.05
                        ),
                    child: Container(
                      width: screenSize.width * 0.3,
                      child: DateTimeFormField(
                        dateTextStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            isDense: true,
                            labelText: 'End Date',
                            hintStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        onSaved: (DateTime value) {
                          setState(() {
                            endDate = value.millisecondsSinceEpoch;
                          });
                        },
                        onDateSelected: (DateTime value) {
                          setState(() {
                            endDate = value.millisecondsSinceEpoch;
                          });
                          print(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  // left: screenSize.width * 0.06,
                  // right: screenSize.width * 0.05,
                  // top: screenSize.height * 0.02,
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenSize.width * 0.5,
                    child: DateTimeFormField(
                      dateTextStyle: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          isDense: true,
                          icon: IconButton(
                            icon: Icon(
                              MdiIcons.clockOutline,
                              color: Colors.black54,
                            ),
                            onPressed: null,
                          ),
                          labelText: 'Start Time',
                          hintStyle: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none),
                      mode: DateTimeFieldPickerMode.time,
                      autovalidateMode: AutovalidateMode.always,
                      onSaved: (DateTime value) {
                        setState(() {
                          startTime = value.millisecondsSinceEpoch;
                        });
                      },
                      onDateSelected: (DateTime value) {
                        setState(() {
                          startTime = value.millisecondsSinceEpoch;
                        });
                        print(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.01,
                      bottom: screenSize.height * 0.01,
                      // right: screenSize.width * 0.05
                    ),
                    child: Container(
                      width: screenSize.width * 0.3,
                      child: DateTimeFormField(
                        dateTextStyle: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            isDense: true,
                            labelText: 'End Time',
                            hintStyle: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.grey,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none),
                        mode: DateTimeFieldPickerMode.time,
                        autovalidateMode: AutovalidateMode.always,
                        onSaved: (DateTime value) {
                          setState(() {
                            endTime = value.millisecondsSinceEpoch;
                          });
                        },
                        onDateSelected: (DateTime value) {
                          setState(() {
                            endTime = value.millisecondsSinceEpoch;
                          });
                          print(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                // left: screenSize.width * 0.06,
                // right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 3,
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
                  labelText: "Details",
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
                  if (value.isEmpty) return "Please enter a text for your post";
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                // left: screenSize.width * 0.06,
                // right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _hostController,
                key: Key("hostField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  icon: IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: Colors.black54,
                    ),
                    onPressed: null,
                  ),
                  labelText: "Speaker",
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
                  if (value.isEmpty) return "Please enter a text for your post";
                  return null;
                },
              ),
            ),
            widget.isOnline
                ? Padding(
                    padding: EdgeInsets.only(
                      //   left: 0,
                      // left: screenSize.width * 0.06,
                      // right: screenSize.width * 0.1,
                      bottom: screenSize.height * 0.01,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _ticketWebsiteController,
                      key: Key("ticketField"),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        icon: IconButton(
                          icon: Icon(
                            Icons.payment_outlined,
                            color: Colors.black54,
                          ),
                          onPressed: null,
                        ),
                        labelText: "Event Registration",
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
                          return "Please enter a text for your post";
                        return null;
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
                // left: screenSize.width * 0.1,
                //  bottom: screenSize.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Add Category',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  selectedEventList.isEmpty
                      ? InkWell(
                          onTap: _showDialog,
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.deepPurple,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              selectedEventList,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black,
                                //  fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedEventList = "";
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
            imageFile == null
                ? Column(
                    children: [
                      Text(
                        'Add event cover image to continue',
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
                      //left: screenSize.width * 0.01,
                      // right: screenSize.width * 0.01
                    ),
                    child: InkWell(
                      onTap: () {
                        _submitForm(context);
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
  //     _locationController.text = formattedAddress;
  //   });
  // }

  _submitForm(BuildContext context) {
    //
    if (_formKey.currentState.validate()) {
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null) {
          compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository.uploadImageToStorage(imageFile).then((url) {
              if (!widget.isOnline) {
                _repository
                    .addOfflineEventToDb(
                        user,
                        url,
                        _captionController.text,
                        location,
                        _locationController.text,
                        _hostController.text,
                        _descriptionController.text,
                        selectedEventList,
                        startDate,
                        endDate,
                        startTime,
                        endTime,
                        _ticketWebsiteController.text,
                        GeoPoint(lat, lng) ?? GeoPoint(0, 0))
                    .catchError(
                        (e) => print('Error adding offline event to db : $e'));
              } else {
                _repository
                    .addOnlineEventToDb(
                      user,
                      url,
                      _captionController.text,
                      _hostController.text,
                      _eventWebsiteController.text,
                      _descriptionController.text,
                      selectedEventList,
                      startDate,
                      endDate,
                      startTime,
                      endTime,
                      _ticketWebsiteController.text,
                    )
                    .catchError(
                        (e) => print('Error adding online event to db : $e'));
              }
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
              TextButton(
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
              TextButton(
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
    List<Widget> choices = [];
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

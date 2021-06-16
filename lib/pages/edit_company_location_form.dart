import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/pages/places_location.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';

class EditCompanyLocationForm extends StatefulWidget {
  final UserModel currentUser;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  EditCompanyLocationForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditCompanyLocationForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  User currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PickResult selectedPlace;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    locationController.text = widget.currentUser.location;

    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  File imageFile;

  submit() async {
    if (_formKey.currentState.validate()) {
      User currentUser = await _auth.currentUser;
      _firestore.collection('users').doc(currentUser.uid).update({
        "location": locationController.text,
      });
      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.04,
            screenSize.height * 0.05,
            screenSize.width * 0.04,
            screenSize.height * 0.1,
          ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TextFormField(
                //   autocorrect: true,
                //   keyboardType: TextInputType.multiline,
                //   minLines: 4,
                //   maxLines: 10,
                //   style: TextStyle(
                //     fontFamily: FontNameDefault,
                //     fontSize: textSubTitle(context),
                //     fontWeight: FontWeight.bold,
                //   ),
                //   controller: locationController,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.grey[100],
                //     //   hintText: 'Bio',
                //     labelText: 'About',
                //     labelStyle: TextStyle(
                //       fontFamily: FontNameDefault,
                //       color: Colors.grey,
                //       fontSize: textSubTitle(context),
                //       //fontWeight: FontWeight.bold,
                //     ),
                //     border: InputBorder.none,
                //     isDense: true,
                //   ),
                // ),
                TextFormField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
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
                                        locationController.text =
                                            selectedPlace.formattedAddress;
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
                                                  : RaisedButton(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      child: Text(
                                                        "Pick Here",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                        //            this will override default 'Select here' Button.
                                                        print(
                                                            "do something with [selectedPlace] data");
                                                        locationController
                                                                .text =
                                                            selectedPlace
                                                                .formattedAddress;

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
                            ),
                          );
                        },
                      )),
                  controller: locationController,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.05,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      submit();
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //  width: screenSize.width * 0.8,
                        decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.015),
                          child: Center(
                            child: Text(
                              'Update',
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
}

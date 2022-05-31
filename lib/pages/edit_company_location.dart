import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/pages/places_location.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import '../style.dart';

class EditCompanyLocation extends StatefulWidget {
  final String location;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  const EditCompanyLocation({Key key, this.location}) : super(key: key);

  @override
  _EditCompanyLocationState createState() => _EditCompanyLocationState();
}

class _EditCompanyLocationState extends State<EditCompanyLocation> {
  var _repository = Repository();
  User currentUser;
  // final _controller = TextEditingController();
  PickResult selectedPlace;
  TextEditingController locationController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    locationController.text = widget.location;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  submit() async {
    User currentUser = _auth.currentUser;
    _firestore.collection('users').doc(currentUser.uid).update({
      "location": locationController.text,
    });
    Navigator.pop(context);
    const snackBar = SnackBar(
      content: Text('Profile Updated'),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: new Color(0xfff6f6f6),
          key: _scaffoldKey,
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
            title: Text(
              'Edit Location',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textAppTitle(context),
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xffffffff),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //  color: const Color(0xffffffff),
              //  padding: const EdgeInsets.symmetric(horizontal: 4.0),
              height: screenSize.height * 0.09,
              child: TextFormField(
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PlacePicker(
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
                                selectedPlaceWidgetBuilder: (_, selectedPlace,
                                    state, isSearchBarFocused) {
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
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                    //            this will override default 'Select here' Button.
                                                    print(
                                                        "do something with [selectedPlace] data");
                                                    locationController.text =
                                                        selectedPlace
                                                            .formattedAddress;

                                                    Navigator.of(context).pop();
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
                              );
                            },
                          ),
                        );
                      },
                    )),
                controller: locationController,
              ),
            ),
          )),
    );
  }
}

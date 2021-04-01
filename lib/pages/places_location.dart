import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'keys.dart';

class PlacesLocation extends StatefulWidget {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  @override
  _PlacesLocationState createState() => _PlacesLocationState();
}

class _PlacesLocationState extends State<PlacesLocation> {
  PickResult selectedPlace;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xfff6f6f6),
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0.5,
              backgroundColor: const Color(0xffffffff),
              title: Text(
                'Map',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textAppTitle(context),
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              )),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Load Google Map",
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            apiKey: APIKeys.apiKey,
                            initialPosition: PlacesLocation.kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,

                            //usePlaceDetailSearch: true,
                            onPlacePicked: (result) {
                              selectedPlace = result;
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            //forceSearchOnZoomChanged: true,
                            //automaticallyImplyAppBarLeading: false,
                            //autocompleteLanguage: "ko",
                            //region: 'au',
                            //selectInitialPosition: true,
                            selectedPlaceWidgetBuilder:
                                (_, selectedPlace, state, isSearchBarFocused) {
                              print(
                                  "state: $state, isSearchBarFocused: $isSearchBarFocused");
                              return isSearchBarFocused
                                  ? Container()
                                  : FloatingCard(
                                      bottomPosition:
                                          0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                      leftPosition: 0.0,
                                      rightPosition: 0.0,
                                      width: 500,
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: state == SearchingState.Searching
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : RaisedButton(
                                              child: Text("Pick Here"),
                                              onPressed: () {
                                                // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                //            this will override default 'Select here' Button.
                                                print(
                                                    "do something with [selectedPlace] data");

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
                ),
                selectedPlace == null
                    ? Container()
                    : Text(selectedPlace.formattedAddress ?? ""),
              ],
            ),
          )),
    );
  }
}

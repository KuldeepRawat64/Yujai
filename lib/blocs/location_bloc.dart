import 'package:Yujai/models/place_search.dart';
import 'package:Yujai/services/geolocator_service.dart';
import 'package:Yujai/services/places_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationBloc with ChangeNotifier {
  final geoLocatorServie = GeolocatorService();
  final placesService = PlacesService();

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;

  // LocationBloc(){
  //   setCurrentLocation();
  // }

  setCurrentLocation() async {
    currentLocation = await geoLocatorServie.getCurrentPosition();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}

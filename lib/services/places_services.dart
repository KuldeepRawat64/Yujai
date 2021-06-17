import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:Yujai/models/place_search.dart';

import 'package:Yujai/pages/keys.dart';

class PlacesService {
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=${APIKeys.apiKey}";

    var res = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(res.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}

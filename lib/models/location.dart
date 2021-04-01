class Location {
  int id;
  String name;

  Location({this.id, this.name});

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

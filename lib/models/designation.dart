class Designation {
  int id;
  String name;

  Designation({this.id, this.name});

  factory Designation.fromJson(Map<String, dynamic> parsedJson) {
    return Designation(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

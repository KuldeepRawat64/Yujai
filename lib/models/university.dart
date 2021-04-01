class University {
  int id;
  String name;

  University({this.id, this.name});

  factory University.fromJson(Map<String, dynamic> parsedJson) {
    return University(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

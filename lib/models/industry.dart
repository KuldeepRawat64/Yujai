class Industry {
  int id;
  String name;

  Industry({this.id, this.name});

  factory Industry.fromJson(Map<String, dynamic> parsedJson) {
    return Industry(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

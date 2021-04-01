class School {
  int id;
  String name;

  School({this.id, this.name});

  factory School.fromJson(Map<String, dynamic> parsedJson) {
    return School(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

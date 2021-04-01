class Company {
  int id;
  String name;

  Company({this.id, this.name});

  factory Company.fromJson(Map<String, dynamic> parsedJson) {
    return Company(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

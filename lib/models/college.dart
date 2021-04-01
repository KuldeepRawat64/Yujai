class College {
  int id;
  String name;

  College({this.id, this.name});

  factory College.fromJson(Map<String, dynamic> parsedJson) {
    return College(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

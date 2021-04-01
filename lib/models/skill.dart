class Skill {
  int id;
  String name;

  Skill({this.id, this.name});

  factory Skill.fromJson(Map<String, dynamic> parsedJson) {
    return Skill(
      id: parsedJson['id'],
      name: parsedJson['name'] as String,
    );
  }
}

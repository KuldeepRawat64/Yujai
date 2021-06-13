class Experiences {
  String id;
  String company;
  String designation;
  int startCompany;
  int endCompany;

  Experiences(
      {this.company, this.designation, this.startCompany, this.endCompany});

  Map toMap(Experiences experiences) {
    var data = Map<String, dynamic>();
    data['id'] = experiences.id;
    data['company'] = experiences.company;
    data['designation'] = experiences.designation;
    data['startCompany'] = experiences.startCompany;
    data['endCompany'] = experiences.endCompany;
    return data;
  }

  Experiences.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['id'];
    this.company = mapData['company'];
    this.designation = mapData['company'];
    this.startCompany = mapData['startCompany'];
    this.endCompany = mapData['endCompany'];
  }
}

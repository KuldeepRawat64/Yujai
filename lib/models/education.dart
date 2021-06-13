class Education {
  String university;
  String field;
  int startUniversity;
  int endUniversity;

  Education(
      {this.university, this.field, this.startUniversity, this.endUniversity});

  Map toMap(Education education) {
    var data = Map<String, dynamic>();
    data['university'] = education.university;
    data['field'] = education.field;
    data['startUniversity'] = education.startUniversity;
    data['endUniversity'] = education.endUniversity;
    return data;
  }

  Education.fromMap(Map<String, dynamic> mapData) {
    this.university = mapData['university'];
    this.field = mapData['university'];
    this.startUniversity = mapData['startUniversity'];
    this.endUniversity = mapData['endUniversity'];
  }
}

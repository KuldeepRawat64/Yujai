class List {
  final int taskVal;
  final String listName;
  final int colorVal;
  List(this.listName, this.taskVal, this.colorVal);

  List.fromMap(Map<String, dynamic> map)
      : assert(map['listName'] != null),
        assert(map['taskVal'] != null),
        assert(map['color'] != null),
        listName = map['listName'],
        taskVal = map['taskVal'],
        colorVal = map['color'];

  @override
  String toString() => "Record<$taskVal:$listName>";
}

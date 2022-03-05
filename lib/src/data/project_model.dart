//import 'package:time_tracker/src/data/sql_table.dart';
import 'package:flutter/material.dart';

class Project {
  int id;
  String name;
  Color color;
  //has many activities
  Project({required this.id, required this.name, required this.color});

  factory Project.fromMap(Map<String, dynamic> map) => Project(
      id: map["id"],
      name: map["name"],
      color: Color(int.parse((map["color"] as String).substring(6, 16))));

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "color": color.toString()};

  static bool identical(Project? proj1, Project? proj2) {
    if (proj1 == null && proj2 == null) {
      return true;
    } else if ((proj1 != null && proj2 == null) ||
        (proj1 == null && proj2 != null)) {
      return false;
    } else if (proj1!.id == proj2!.id) {
      return true;
    }
    return false;
  }
}

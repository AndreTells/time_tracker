//import 'package:time_tracker/src/data/sql_table.dart';
import 'package:flutter/material.dart';

class Project {
  final int _id;
  String _name;
  Color _color;
  //has many activities
  Project._({required int id, required String name, required Color color})
      : _id = id,
        _name = name,
        _color = color;

  String getName() {
    return _name;
  }

  Color getColor() {
    return _color;
  }

  int getId() {
    return _id;
  }

  static bool identical(Project? proj1, Project? proj2) {
    if (proj1 == null && proj2 == null) {
      return true;
    } else if ((proj1 != null && proj2 == null) ||
        (proj1 == null && proj2 != null)) {
      return false;
    } else if (proj1!._id == proj2!._id) {
      return true;
    }
    return false;
  }
}

class ProjectTable {
  static final ProjectTable _table = ProjectTable._();
  final List<Project> _projects = [];
  int _nextId = 0;

  ProjectTable._();
  static ProjectTable getTable() {
    return _table;
  }

  void addProject(String name, Color color) {
    Project newProject = Project._(id: _nextId, name: name, color: color);
    _projects.add(newProject);
    _nextId++;
  }

  List<Project> getProjects() {
    return _projects;
  }

  void editProject(int id, String name, Color color) {
    _projects[id]._name = name;
    _projects[id]._color = color;
  }

  Project getProjectById(int id) {
    return _projects[id];
  }
}

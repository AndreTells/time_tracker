//import 'package:time_tracker/src/data/sql_table.dart';
//import 'package:sqflite/sqflite.dart';

class Activity {
  final int _id;
  String _name;
  Duration _totalTime; //stored as seconds
  int _projectId;
  Activity(
      {required int id,
      required String name,
      required Duration totalTime,
      required int projectId})
      : _id = id,
        _name = name,
        _totalTime = totalTime,
        _projectId = projectId;

  factory Activity.fromMap(Map<String, dynamic> map) => Activity(
      id: map["id"],
      name: map["name"],
      totalTime: Duration(seconds: map["total_time"]),
      projectId: map["project_id"]);

  Map<String, dynamic> toMap() => {
        "id": _id,
        "name": _name,
        "total_time": _totalTime.inSeconds,
        "project_id": _projectId
      };

  String get name {
    return _name;
  }

  Duration get totalTime {
    return _totalTime;
  }

  int get projectId {
    return _projectId;
  }

  int get id {
    return _id;
  }

  void addTime(Duration time) {
    _totalTime += time;
  }

  static bool identical(Activity? activity1, Activity? activity2) {
    if (activity1 == null && activity2 == null) {
      return true;
    } else if ((activity1 != null && activity2 == null) ||
        (activity1 == null && activity2 != null)) {
      return false;
    } else if (activity1!._id == activity2!._id) {
      return true;
    }
    return false;
  }
}

class ActivityTable {
  static final ActivityTable _table = ActivityTable._();
  final List<Activity> _activities = [];
  int _nextId = 0;

  ActivityTable._();
  static ActivityTable getTable() {
    return _table;
  }

  void addActivity(String name, int projectId) {
    Activity newActivity = Activity(
        id: _nextId,
        name: name,
        totalTime: Duration.zero,
        projectId: projectId);
    _activities.add(newActivity);
    _nextId++;
  }

  List<Activity> getActivities() {
    return _activities;
  }

  List<Activity> getActivitiesOfProject(int projectId) {
    return _activities
        .where((element) => element._projectId == projectId)
        .toList();
  }

  void editActivity(int id, String name, int projectId) {
    _activities[id]._name = name;
    _activities[id]._projectId = projectId;
  }

  Activity getActivityById(int id) {
    return _activities[id];
  }
}

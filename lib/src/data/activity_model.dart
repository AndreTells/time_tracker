//import 'package:time_tracker/src/data/sql_table.dart';
//import 'package:sqflite/sqflite.dart';

class Activity {
  int id;
  String name;
  Duration totalTime; //stored as seconds
  int projectId;
  Activity(
      {required this.id,
      required this.name,
      required this.totalTime,
      required this.projectId});

  factory Activity.fromMap(Map<String, dynamic> map) => Activity(
      id: map["id"],
      name: map["name"],
      totalTime: Duration(seconds: map["total_time"]),
      projectId: map["project_id"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "total_time": totalTime.inSeconds,
        "project_id": projectId
      };

  void addTime(Duration time) {
    totalTime += time;
  }

  static bool identical(Activity? activity1, Activity? activity2) {
    if (activity1 == null && activity2 == null) {
      return true;
    } else if ((activity1 != null && activity2 == null) ||
        (activity1 == null && activity2 != null)) {
      return false;
    } else if (activity1!.id == activity2!.id) {
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
        .where((element) => element.projectId == projectId)
        .toList();
  }

  void editActivity(int id, String name, int projectId) {
    _activities[id].name = name;
    _activities[id].projectId = projectId;
  }

  Activity getActivityById(int id) {
    return _activities[id];
  }
}

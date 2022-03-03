//import 'package:time_tracker/src/data/sql_table.dart';
//import 'package:sqflite/sqflite.dart';

class Activity {
  final int _id;
  String _name;
  Duration _totalTime;
  int _projectId;
  Activity._(
      {required int id,
      required String name,
      required Duration totalTime,
      required int projectId})
      : _id = id,
        _name = name,
        _totalTime = totalTime,
        _projectId = projectId;

  String getName() {
    return _name;
  }

  Duration getTotalTime() {
    return _totalTime;
  }

  int getProjectId() {
    return _projectId;
  }

  int getId() {
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
    Activity newActivity = Activity._(
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

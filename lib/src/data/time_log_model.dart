//import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/sql_handler.dart';

class TimeLog {
  int id;
  DateTime start; //stored as milliseconds since epoch
  DateTime end; //stored as milliseconds since epoch
  Duration time; //stored as seconds
  int activityId;

  TimeLog(
      {required this.id,
      required this.start,
      required this.end,
      required this.activityId})
      : time = end.difference(start);

  factory TimeLog.fromMap(Map<String, dynamic> map) => TimeLog(
      id: map["id"],
      start: DateTime.fromMillisecondsSinceEpoch(map["start"]),
      end: DateTime.fromMillisecondsSinceEpoch(map["end"]),
      activityId: map["activity_id"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "start": start.millisecondsSinceEpoch,
        "end": end.millisecondsSinceEpoch,
        "activity_id": activityId
      };

  Future<Project?> fetchProject() async {
    //TODO: evaluate possible error
    Activity activity = (await fetchActivity())!;

    return DBProvider.db.getProjectById(activity.projectId);
  }

  Future<Activity?> fetchActivity() async {
    return DBProvider.db.getActivityById(activityId);
  }
}

class TimeLogTable {
  static final TimeLogTable _table = TimeLogTable._();
  final List<TimeLog> _timeLogs = [];
  int _nextId = 0;

  TimeLogTable._();
  static TimeLogTable getTable() {
    return _table;
  }

  void addTimeLog(DateTime start, DateTime end, int activtiyId) {
    TimeLog newTimeLog =
        TimeLog(id: _nextId, start: start, end: end, activityId: activtiyId);
    _timeLogs.add(newTimeLog);
    _nextId++;
  }

  List<TimeLog> getTimeLogs() {
    return _timeLogs;
  }

  List<TimeLog> getTimeLogsOfActivity(int activityId) {
    return _timeLogs
        .where((element) => element.activityId == activityId)
        .toList();
  }

  void ediTimeLog(int id, DateTime start, DateTime end, int activityId) {
    TimeLog selectedTimeLog = _timeLogs[id];
    //ActivityTable activities = ActivityTable.getTable();
    //Activity currentActivity =
    //    activities.getActivityById(selectedTimeLog.activityId);
    //currentActivity.addTime(selectedTimeLog.time * (-1));

    selectedTimeLog.start = start;
    selectedTimeLog.end = end;
    selectedTimeLog.time = end.difference(start);
    selectedTimeLog.activityId = activityId;

    //Activity newActivity =
    //activities.getActivityById(selectedTimeLog.activityId);
    //newActivity.addTime(selectedTimeLog.time);

    _timeLogs[id] = selectedTimeLog;
  }
}

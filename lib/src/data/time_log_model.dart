//import 'package:time_tracker/src/data/sql_table.dart';
//import 'package:sqflite/sqflite.dart';

// ignore_for_file: unused_field

import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';

class TimeLog {
  final int _id;
  DateTime _start; //stored as milliseconds since epoch
  DateTime _end; //stored as milliseconds since epoch
  Duration _time; //stored as seconds
  int _activityId;

  TimeLog(
      {required int id,
      required DateTime start,
      required DateTime end,
      required int activityId})
      : _id = id,
        _start = start,
        _end = end,
        _time = end.difference(start),
        _activityId = activityId;

  factory TimeLog.fromMap(Map<String, dynamic> map) => TimeLog(
      id: map["id"],
      start: DateTime.fromMillisecondsSinceEpoch(map["start"]),
      end: DateTime.fromMillisecondsSinceEpoch(map["end"]),
      activityId: map["activity_id"]);

  Map<String, dynamic> toMap() => {
        "id": _id,
        "start": _start.millisecondsSinceEpoch,
        "end": _end.millisecondsSinceEpoch,
        "activity_id": _activityId
      };

  Duration get time {
    return _time;
  }

  DateTime get start {
    return _start;
  }

  DateTime get end {
    return _end;
  }

  Project get project {
    ProjectTable table = ProjectTable.getTable();

    return table.getProjectById(activity.getProjectId());
  }

  Activity get activity {
    ActivityTable table = ActivityTable.getTable();
    return table.getActivityById(_activityId);
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
        .where((element) => element._activityId == activityId)
        .toList();
  }

  void ediTimeLog(int id, DateTime start, DateTime end, int activityId) {
    TimeLog selectedTimeLog = _timeLogs[id];
    ActivityTable activities = ActivityTable.getTable();
    Activity currentActivity =
        activities.getActivityById(selectedTimeLog._activityId);
    currentActivity.addTime(selectedTimeLog._time * (-1));

    selectedTimeLog._start = start;
    selectedTimeLog._end = end;
    selectedTimeLog._time = end.difference(start);
    selectedTimeLog._activityId = activityId;

    Activity newActivity =
        activities.getActivityById(selectedTimeLog._activityId);
    newActivity.addTime(selectedTimeLog._time);

    _timeLogs[id] = selectedTimeLog;
  }
}

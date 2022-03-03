//import 'package:time_tracker/src/data/sql_table.dart';
//import 'package:sqflite/sqflite.dart';

// ignore_for_file: unused_field

import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';

class TimeLog {
  final int _id;
  DateTime _start; //00:00:00
  DateTime _end;
  Duration _time;
  int _projectId;
  int _activityId;

  TimeLog._(
      {required int id,
      required DateTime start,
      required DateTime end,
      required int projectId,
      required int activityId})
      : _id = id,
        _start = start,
        _end = end,
        _time = end.difference(start),
        _projectId = projectId,
        _activityId = activityId;

  Duration getTime() {
    return _time;
  }

  DateTime getStart() {
    return _start;
  }

  DateTime getEnd() {
    return _end;
  }

  Project getProject() {
    ProjectTable table = ProjectTable.getTable();
    return table.getProjectById(_projectId);
  }

  Activity getActivity() {
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

  void addTimeLog(DateTime start, DateTime end, int projectId, int activtiyId) {
    TimeLog newTimeLog = TimeLog._(
        id: _nextId,
        start: start,
        end: end,
        projectId: projectId,
        activityId: activtiyId);
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

  void ediTimeLog(
      int id, DateTime start, DateTime end, int projectId, int activityId) {
    TimeLog selectedTimeLog = _timeLogs[id];
    ActivityTable activities = ActivityTable.getTable();
    Activity currentActivity =
        activities.getActivityById(selectedTimeLog._activityId);
    currentActivity.addTime(selectedTimeLog._time * (-1));

    selectedTimeLog._start = start;
    selectedTimeLog._end = end;
    selectedTimeLog._time = end.difference(start);
    selectedTimeLog._projectId = projectId;
    selectedTimeLog._activityId = activityId;

    Activity newActivity =
        activities.getActivityById(selectedTimeLog._activityId);
    newActivity.addTime(selectedTimeLog._time);

    _timeLogs[id] = selectedTimeLog;
  }
}

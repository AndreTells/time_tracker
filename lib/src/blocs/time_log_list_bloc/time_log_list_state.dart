part of 'time_log_list_bloc.dart';

class TimeLogListState {
  List<TimeLog> timeLogs;
  List<Project> projects;
  List<Activity> activities;
  TimeLogListState(
      {this.timeLogs = const [],
      this.projects = const [],
      this.activities = const []});
}

abstract class TimeLogListEvent {}

class DeleteItem extends TimeLogListEvent {
  int id;
  DeleteItem({required this.id});
}

class SyncToDB extends TimeLogListEvent {
  List<TimeLog> timeLogs;
  List<Project> projects;
  List<Activity> activities;
  SyncToDB(
      {required this.timeLogs,
      required this.projects,
      required this.activities});
}

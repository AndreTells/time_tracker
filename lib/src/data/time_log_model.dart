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

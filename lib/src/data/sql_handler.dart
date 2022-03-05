import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/src/data/activity_model.dart';

import 'project_model.dart';
import 'time_log_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "trackerDB.db";
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        //creating the project table
        await db.execute("CREATE TABLE Project("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "color TEXT"
            ")");

        //createing the activity table
        await db.execute("CREATE TABLE Activity("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "total_time INTEGER,"
            "project_id INTEGER,"
            "FOREIGN KEY (project_id) REFERENCES Project(id)"
            ")");

        //creating the time log table
        await db.execute("CREATE TABLE Time_Log("
            "id INTEGER PRIMARY KEY,"
            "start INTEGER,"
            "end INTEGER,"
            "time INTEGER,"
            "activity_id INTEGER,"
            "FOREIGN KEY (activity_id) REFERENCES Activity(id)"
            ")");
      },
    );
  }

  //CRUD operations for Project table
  //CREATE
  Future<int> newProject(Project project, {bool useLargestId = true}) async {
    final db = await database;
    if (useLargestId) {
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM  Project");
      int id = table.first["id"] == null ? 0 : table.first["id"] as int;
      project.id = id;
      var res = await db.insert("Project", project.toMap());
      return res;
    } else {
      var res = await db.insert("Project", project.toMap());
      return res;
    }
  }

  //READ
  Future<Project?> getProjectById(int id) async {
    final db = await database;
    var result = await db.query("Project", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Project.fromMap(result.first) : null;
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    var result = await db.query("Project");
    List<Project>? list =
        result.isNotEmpty ? result.map((e) => Project.fromMap(e)).toList() : [];
    return list;
  }

  //UPDATE
  Future<int> updateProject(Project newProject) async {
    final db = await database;
    var res = db.update("Project", newProject.toMap(),
        where: "id = ?", whereArgs: [newProject.id]);
    return res;
  }

  //DELETE
  Future<void> deleteProject(int id) async {
    final db = await database;
    List<Activity> activities = await getActivitiesFromProject(id);
    for (Activity a in activities) {
      deleteActivity(a.id);
    }
    db.delete("Project", where: "id = ?", whereArgs: [id]);
  }

  /*
  Future<void> deleteAllProjects() async{
    final db = await database;
    db.rawDelete("DELETE * From Project");
  }
  */

  //CRUD operations for Activity table
  //CREATE
  Future<int> newActivity(Activity activity, {bool useLargestId = true}) async {
    final db = await database;
    if (useLargestId) {
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM  Activity");
      int id = table.first["id"] == null ? 0 : table.first["id"] as int;
      activity.id = id;
      var res = await db.insert("Activity", activity.toMap());
      return res;
    } else {
      var res = await db.insert("Activity", activity.toMap());
      return res;
    }
  }

  //READ
  Future<Activity?> getActivityById(int id) async {
    final db = await database;
    var result = await db.query("Activity", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Activity.fromMap(result.first) : null;
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await database;
    var result = await db.query("Activity");
    List<Activity>? list = result.isNotEmpty
        ? result.map((e) => Activity.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<List<Activity>> getActivitiesFromProject(int id) async {
    final db = await database;
    var result =
        await db.query("Activity", where: "project_id = ?", whereArgs: [id]);
    List<Activity>? list = result.isNotEmpty
        ? result.map((e) => Activity.fromMap(e)).toList()
        : [];
    return list;
  }

  //UPDATE
  Future<int> updateActivity(Activity newActivity) async {
    final db = await database;
    var res = db.update("Activity", newActivity.toMap(),
        where: "id = ?", whereArgs: [newActivity.id]);
    return res;
  }

  //DELETE
  Future<void> deleteActivity(int id) async {
    final db = await database;
    List<TimeLog> timeLogs = await getTimeLogsFromActivity(id);
    for (TimeLog t in timeLogs) {
      deleteActivity(t.id);
    }
    db.delete("Activity", where: "id = ?", whereArgs: [id]);
  }

  //CRUD operations for Time Log table
  //CREATE
  Future<int> newTimeLog(TimeLog timeLog, {bool useLargestId = true}) async {
    final db = await database;
    if (useLargestId) {
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM  Time_Log");
      int id = table.first["id"] == null ? 0 : table.first["id"] as int;
      timeLog.id = id;
      var res = await db.insert("Time_Log", timeLog.toMap());
      return res;
    } else {
      var res = await db.insert("Time_Log", timeLog.toMap());
      return res;
    }
  }

  //READ
  Future<TimeLog?> getTimeLogById(int id) async {
    final db = await database;
    var result = await db.query("Time_Log", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? TimeLog.fromMap(result.first) : null;
  }

  Future<List<TimeLog>> getAllTimeLogs() async {
    final db = await database;
    var result = await db.query("Time_Log");
    List<TimeLog>? list =
        result.isNotEmpty ? result.map((e) => TimeLog.fromMap(e)).toList() : [];
    return list;
  }

  Future<List<TimeLog>> getTimeLogsFromActivity(int id) async {
    final db = await database;
    var result =
        await db.query("Time_Log", where: "activity_id = ?", whereArgs: [id]);
    List<TimeLog>? list =
        result.isNotEmpty ? result.map((e) => TimeLog.fromMap(e)).toList() : [];
    return list;
  }

  //UPDATE
  Future<int> updateTimeLog(TimeLog newTimeLog) async {
    final db = await database;
    var res = db.update("Time_Log", newTimeLog.toMap(),
        where: "id = ?", whereArgs: [newTimeLog.id]);
    return res;
  }

  //DELETE
  Future<void> deleteTimeLog(int id) async {
    final db = await database;
    db.delete("Time_Log", where: "id = ?", whereArgs: [id]);
  }
}

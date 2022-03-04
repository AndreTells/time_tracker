import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'project_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static late Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
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
            "name TEXT"
            "color TEXT"
            ")");

        //createing the activity table
        await db.execute("CREATE TABLE Activity("
            "id INTEGER PRIMARY KEY,"
            "name TEXT"
            "total_time INTEGER"
            "project_id INTEGER"
            "FOREIGN KEY (project_id) REFERENCES Project(id)"
            ")");

        //creating the time log table
        await db.execute("CREATE TABLE Time_Log("
            "id INTEGER PRIMARY KEY"
            "start INTEGER"
            "end INTEGER"
            "time INTEGER"
            "activity_id INTEGER"
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
      int id = table.first["id"] as int;
      var raw = await db.rawInsert(
          "INSERT Into Project (id, name, color)"
          " VALUES (?,?,?)",
          [id, project.name, project.color]);
      return raw;
    } else {
      var raw = await db.rawInsert(
          "INSERT Into Project (id, name, color)"
          " VALUES (?,?,?)",
          [project.id, project.name, project.color]);
      return raw;
    }
  }

  //READ
  Future<Project?> getProjectById(int id) async {
    final db = await database;
    var result = await db.query("Project", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Project.fromMap(result.first) : null;
  }

  Future<List<Project>?> getAllProjects() async {
    final db = await database;
    var result = await db.query("Projects");
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
    db.delete("Project", where: "id = ?", whereArgs: [id]);
  }

  /*
  Future<void> deleteAllProjects() async{
    final db = await database;
    db.rawDelete("DELETE * From Project");
  }
  */
}

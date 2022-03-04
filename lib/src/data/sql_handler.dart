import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
}

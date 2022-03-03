/*
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//change so that only a single .db file is necessary
abstract class SQLDataTable {
  final String tableName;
  static late Future<Database> dataBase = getDatabase();
  SQLDataTable({required this.tableName});

  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'planner_database.db'),
        version: 1);
  }

  //creates the table if it doesn't exist already
  static Future<void> createTable(
      String tableName, String sqlAttributes) async {
    final db = await dataBase;
    await db
        .execute("""CREATE TABLE if not exists $tableName($sqlAttributes)""");
  }

  //inserts an element into the table
  Future<void> insertElement(SQLDataTableItem item) async {
    final db = await dataBase;
    item.id = await db.insert(tableName, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //returns the elemenst of the table
  Future<List<SQLDataTableItem>> getElements();
}

abstract class SQLDataTableItem {
  int? id;
  SQLDataTableItem({this.id});
  Map<String, dynamic> toMap();
}
*/
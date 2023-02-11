import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class Statics {
  static double titleSize = 18;
  static String dbName = "Tasks.db";
  static String taskTableCreate =
      "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task_title TEXT, task_desc TEXT, task_color INTEGER);";
  static String projectTableCreate =
      "CREATE TABLE projects(id INTEGER PRIMARY KEY AUTOINCREMENT,project_name TEXT, project_tasks TEXT, project_taskDone INTEGER, project_color INTEGER);";
  static List<dynamic> addedTask = [];
  static String language = 'EN';
  static String theme = 'litght';
  static TextDirection appTextDirection = TextDirection.ltr;
  static Future<void> onCreateDatabase(Database db, int version) async {
    await db.execute(taskTableCreate);
    await db.execute(projectTableCreate);
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Controllers/DatabaseController.dart';

import 'package:todo_app/Statics/Statics.dart';

class TasksController {
  getTasks() async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);
    return DatabaseController(database: dbOpen)
        .retrieveInfo(tableName: 'tasks');
  }

  insertTask(String taskTitle, String taskDes, int taskColor) async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);
    DatabaseController(database: dbOpen)
        .insert('tasks', {'task_title': taskTitle, 'task_desc': taskDes,'task_color': taskColor});
  }

  updateTask(int id, String taskTitle, String taskDes, int taskColor) async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);

    DatabaseController(database: dbOpen).updateInfo(
        tableName: 'tasks',
        data: {'task_title': taskTitle, 'task_desc': taskDes, 'task_color': taskColor},
        where: 'id = ?',
        whereArgs: [id]);
  }

  deleteTask(int id) async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);

    DatabaseController(database: dbOpen)
        .deleteInfo(tableName: 'tasks', where: 'id = ?', whereArgs: [id]);
  }
}

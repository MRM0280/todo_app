import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Controllers/DatabaseController.dart';
import 'package:todo_app/Statics/Statics.dart';

class ProjectsController {
  getProjects() async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);
    return DatabaseController(database: dbOpen)
        .retrieveInfo(tableName: 'projects');
  }

  insertProject(
      String projectName, String projectTasks, int projectColor) async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);
    DatabaseController(database: dbOpen).insert('projects', {
      'project_name': projectName,
      'project_tasks': projectTasks,
      'project_taskDone': 0,
      'project_color': projectColor
    }).then((value) {
      return {
        'project_name': projectName,
        'project_tasks': projectTasks,
        'project_taskDone': 0,
        'project_color': projectColor
      };
    });
  }

  updateProject(int id, String projectName, String projectTasks,
      int projectTaskDone, int projectColor) async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);

    DatabaseController(database: dbOpen)
        .updateInfo(
            tableName: 'projects',
            data: {
              'project_name': projectName,
              'project_tasks': projectTasks,
              'project_taskDone': projectTaskDone,
              'project_color': projectColor
            },
            where: 'id = ?',
            whereArgs: [id])
        .then((value) {
      print(value);
    });
  }

  deleteProject(int id) async {
    Future<Database> dbOpen = openDatabase(
        (await getDatabasesPath() + '/' + Statics.dbName),
        onCreate: Statics.onCreateDatabase,
        version: 1);

    DatabaseController(database: dbOpen)
        .deleteInfo(tableName: 'projects', where: 'id = ?', whereArgs: [id]);
  }
}

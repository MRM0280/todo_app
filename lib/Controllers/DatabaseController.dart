import 'package:sqflite/sqflite.dart';

class DatabaseController {
  Future<Database> database;
  DatabaseController({this.database});

  Future<String> insert(String tableName, dynamic data) async {
    final Database db = await database;
    try {
      await db.insert(
        tableName,
        data,
      );
    } catch (error) {
      print(error);
    } /*finally{
      db.close();
    }*/
    return "ثبت اطلاعات با موفقیت انجام شد";
  }

  Future<List<Map<String, dynamic>>> retrieveInfo({String tableName}) async {
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> data = await db.query(
        tableName,
      );
      return data;
    } catch (e) {} /*finally{
      db.close();
    }*/
  }

  Future<String> updateInfo(
      {String tableName,
      dynamic data,
      String where,
      List<dynamic> whereArgs}) async {
    final Database db = await database;
    try {
      await db.update(
        tableName,
        data,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (error) {} /*finally{
      db.close();
    }*/
    return "بروزرسانی اطلاعات با موفقیت انجام شد";
  }

  Future<String> deleteInfo(
      {String tableName, String where, List<dynamic> whereArgs}) async {
    final Database db = await database;
    try {
      await db.delete(
        tableName,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (error) {} /*finally{
      db.close();
    }*/
    return "حذف اطلاعات با موفقیت انجام شد";
  }
}

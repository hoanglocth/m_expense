import 'package:m_expense/database/DatabaseConnection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  insertTrip(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }
  readTrip(table) async {
    var connection = await database;
    return await connection?.query(table);
  }
  deleteTripById(table, itemId) async {
    var connection = await database;
    return await connection
        ?.rawDelete("delete from $table where id_trip=$itemId");
  }
  deleteAllTrip(table) async {
    var connection = await database;
    return await connection
        ?.rawQuery("delete from $table");
  }
  updateTrip(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id_trip=?', whereArgs: [data['id_trip']]);
  }
}

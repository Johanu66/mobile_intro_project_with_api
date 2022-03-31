import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE persons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstname TEXT,
        lastname TEXT,
        birthday TEXT,
        address TEXT,
        phone TEXT,
        mail TEXT,
        gender TEXT,
        picture TEXT,
        citation TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'ifri.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createPerson(String? firstname, String? lastname, String? birthday, String? address, String? phone, String? mail, String? gender, String? picture, String? citation) async {
    final db = await SQLHelper.db();

    final data = {'firstname': firstname, 'lastname': lastname, 'birthday': birthday, 'address': address, 'phone': phone, 'mail': mail, 'gender': gender, 'picture': picture, 'citation': citation};
    final id = await db.insert('persons', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getPersons() async {
    final db = await SQLHelper.db();
    return db.query('persons', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getPerson(int id) async {
    final db = await SQLHelper.db();
    return db.query('persons', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updatePerson(
      int id, String? firstname, String? lastname, String? birthday, String? address, String? phone, String? mail, String? gender, String? picture, String? citation) async {
    final db = await SQLHelper.db();

    final data = {
      'firstname': firstname,
      'lastname': lastname,
      'birthday': birthday,
      'address': address,
      'phone': phone,
      'mail': mail,
      'gender': gender,
      'picture': picture,
      'citation': citation,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('persons', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deletePerson(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("persons", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a person: $err");
    }
  }
}
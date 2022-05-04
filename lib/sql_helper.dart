import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;

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

  static createPerson(String? firstname, String? lastname, String? address, String? phone, String? gender, String? picture, String? citation) async {
    //final db = await SQLHelper.db();

    final data = {'firstname': firstname, 'lastname': lastname, 'adress': address, 'phone': phone, 'gender': gender, 'picture': picture, 'citation': citation};
    http.post(
      Uri.parse('https://ifri.raycash.net/adduser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  static Future<List<Map<String, dynamic>>> getPersons() async {
    final response = await http.get(Uri.parse('https://ifri.raycash.net/getusers'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json.decode(response.body)['message']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
    //final db = await SQLHelper.db();
    //return db.query('persons', orderBy: "id");
  }

  static Future<Map<String, dynamic>> getPerson(String id) async {
    final response = await http.get(Uri.parse('https://ifri.raycash.net/getuser/'+id.toString()));


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return jsonDecode(response.body);
      return Map<String, dynamic>.from(json.decode(response.body)['message']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
    //final db = await SQLHelper.db();
    //return db.query('persons', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static updatePerson(String id, String? firstname, String? lastname, String? address, String? phone, String? gender, String? picture, String? citation) async {
    //final db = await SQLHelper.db();

    final data = {
      'firstname': firstname,
      'lastname': lastname,
      'adress': address,
      'phone': phone,
      'gender': gender,
      'picture': picture,
      'citation': citation,
      'createdAt': DateTime.now().toString()
    };

    http.post(
      Uri.parse('https://ifri.raycash.net/updateuser/'+id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  static Future<void> deletePerson(String id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("persons", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a person: $err");
    }
  }
}
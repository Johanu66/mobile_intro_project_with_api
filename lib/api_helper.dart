import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHelper {

  static createPerson(String? firstname, String? lastname, String? address, String? phone, String? gender, String? picture, String? citation) async {

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
  }

  static updatePerson(String id, String? firstname, String? lastname, String? address, String? phone, String? gender, String? picture, String? citation) async {

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

}
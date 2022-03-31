import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_intro_project/sql_helper.dart';

class ShowPerson extends StatefulWidget {
  @override
  _ShowPerson createState() => _ShowPerson();

  int id;

  ShowPerson({Key? key, required this.id}) : super(key: key);

}
class _ShowPerson extends State<ShowPerson> {

  List<Map<String, dynamic>> person = [];
  bool isLoading = true;

  _refreshPerson() async {
    final data = await SQLHelper.getPerson(widget.id);
    setState(() {
      person = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshPerson(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.first['firstname']+' '+person.first['lastname']),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            person.first['picture']!=null ? Image.file(File(person.first['picture']!)) : Container(),
            const SizedBox(
              height: 10,
            ),
            Text('First Name : '+person.first['firstname'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Last Name : '+person.first['lastname'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Birthday : '+person.first['birthday']!, style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Address : '+person.first['address'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Phone : '+person.first['phone'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Mail : '+person.first['mail'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Sexe : '+person.first['gender'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Citation : '+person.first['citation'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

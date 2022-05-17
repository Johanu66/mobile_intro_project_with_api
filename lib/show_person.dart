import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_intro_project/api_helper.dart';

class ShowPerson extends StatefulWidget {
  @override
  _ShowPerson createState() => _ShowPerson();

  String id;

  ShowPerson({Key? key, required this.id}) : super(key: key);

}
class _ShowPerson extends State<ShowPerson> {

  Map<String, dynamic> person = {};
  bool isLoading = true;

  _refreshPerson() async {
    final data = await APIHelper.getPerson(widget.id);
    setState(() {
      person = data;
      isLoading = false;
    });
  }

  _myImage(String? image){
    if(image==null || image==""){
      return ClipRRect(borderRadius: BorderRadius.circular(250.0), child: SizedBox(width: 250, height: 250, child: Image.asset("assets/default_picture.png",fit:BoxFit.fill)));
    }
    return ClipRRect(borderRadius: BorderRadius.circular(250.0), child: SizedBox(width: 250, height: 250, child: Image.file(File(image), fit:BoxFit.fill)));
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
        title: Text("Detail"),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              _myImage(person['picture']),
              const SizedBox(
                height: 50,
              ),
              Text(person['lastname']+' '+person['firstname'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 10,
              ),
              Text('Address : '+person['adress'], style: const TextStyle(fontSize: 22),),
              const SizedBox(
                height: 10,
              ),
              Text('Phone : '+person['phone'], style: const TextStyle(fontSize: 22),),
              const SizedBox(
                height: 10,
              ),
              Text('Sexe : '+person['gender'], style: const TextStyle(fontSize: 22),),
              const SizedBox(
                height: 10,
              ),
              Text('Citation : '+person['citation'], style: const TextStyle(fontSize: 22),),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

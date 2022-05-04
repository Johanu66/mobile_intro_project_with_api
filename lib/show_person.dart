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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //person['picture']!=null && person['picture']!="" ? Image.file(File(person['picture']!)) : Container(),
            const SizedBox(
              height: 10,
            ),
            Text('First Name : '+person['firstname'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Last Name : '+person['lastname'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Address : '+person['adress'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Phone : '+person['phone'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Sexe : '+person['gender'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
            Text('Citation : '+person['citation'], style: const TextStyle(fontSize: 18),),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

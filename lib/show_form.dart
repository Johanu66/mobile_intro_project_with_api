import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_intro_project/main.dart';
import 'package:mobile_intro_project/api_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class ShowForm extends StatefulWidget {
  @override
  _ShowForm createState() => _ShowForm();

  String? id;

  ShowForm({Key? key, this.id}) : super(key: key);

}

class _ShowForm extends State<ShowForm> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _gender;
  String? _picture;
  final TextEditingController _citationController = TextEditingController();
  bool isLoading = true;
  String? pictureName = '';

  _refreshFrom() async {
    if (widget.id != null) {
      final data = await APIHelper.getPerson(widget.id!);
      setState(() {
          // id == null -> create new person
          // id != null -> update an existing person
          final existingJournal = data;
          _firstnameController.text = existingJournal['firstname'];
          _lastnameController.text = existingJournal['lastname'];
          _addressController.text = existingJournal['adress'];
          _phoneController.text = existingJournal['phone'];
          _gender = existingJournal['gender'];
          _picture = existingJournal['picture'];
          _citationController.text = existingJournal['citation'];
        });
    };
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _refreshFrom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Form'),
      ),
      body:  isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _firstnameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value){
                      return (value==null || value=="") ? "This field is required" : null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value){
                      return (value==null || value=="") ? "This field is required" : null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: 'Address'),
                    validator: (String? value){
                      return (value==null || value=="") ? "This field is required" : null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(hintText: 'Phone'),
                    validator: (String? value){
                      return (value==null || value=="") ? "This field is required" : null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    hint: const Text("Sexe"),
                    value: _gender,
                    items: <String>['Masculin', 'Féminin'].map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (String? v) async{
                      setState(() {
                        _gender = v;
                      });
                    },
                    validator: (str) => str==null ? "This field is required" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _citationController,
                    decoration: const InputDecoration(hintText: 'Citation'),
                    validator: (String? value){
                      return (value==null || value=="") ? "This field is required" : null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _picture!=null ? Image.file(File(_picture!)) : Container(),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();
                            if (result != null) {
                              PlatformFile file = result.files.first;
                              final newFile = await saveFilePermanently(file);
                              setState(() {
                                pictureName = file.name;
                                _picture = newFile.path;
                              });
                              //OpenFile.open(_picture);
                            } else {
                              // User canceled the picker
                            }
                          });
                        },
                        child: const Text("Click here to choose a profile picture.")
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate()) {
                          // Save new journal
                          if (widget.id == null) {
                            await _addPerson();
                          }

                          if (widget.id != null) {
                            await _updatePerson(widget.id!);
                          }

                          // Clear the text fields
                          //id=null;
                          _firstnameController.text = '';
                          _lastnameController.text = '';
                          _addressController.text = '';
                          _phoneController.text = '';
                          _gender = null;
                          _picture = '';
                          _citationController.text = '';

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyHomePage(title: "Persons List")),
                          );
                        }
                      },
                      child: Text(widget.id == null ? 'Create New' : 'Update'),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  // Insert a new journal to the database
  Future<void> _addPerson() async {
    await APIHelper.createPerson(
        _firstnameController.text,
        _lastnameController.text,
        _addressController.text,
        _phoneController.text,
        _gender,
        _picture,
        _citationController.text
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('User successfully added!'),
    ));
  }

  // Update an existing journal
  Future<void> _updatePerson(String id) async {
    await APIHelper.updatePerson(
        id,
        _firstnameController.text,
        _lastnameController.text,
        _addressController.text,
        _phoneController.text,
        _gender,
        _picture,
        _citationController.text
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('User successfully updated !'),
    ));
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
     final appStorage = await getApplicationDocumentsDirectory();
     final newFile = File('${appStorage.path}/${file.name}');
     return File(file.path!).copy(newFile.path);
  }
}

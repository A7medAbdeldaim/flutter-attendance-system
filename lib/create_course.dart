import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MultiSelect.dart';

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

List<String> _selectedItemsTeacher = [];
List<String> _selectedItemsStudent = [];

void insertData(unmodifiedData) {
  final db = FirebaseFirestore.instance;

  var data = {
    "name": unmodifiedData['name'],
    "students": _selectedItemsStudent,
    "teachers": _selectedItemsTeacher
  };

  db.collection("courses").add(data).then((DocumentReference doc) {
    print('DocumentSnapshot added with ID: ${doc.id}');
  });
}

class _CreateCourseState extends State<CreateCourse> {
  @override
  Widget build(BuildContext context) {
    return const CompleteForm();
  }
}

class CompleteForm extends StatefulWidget {
  const CompleteForm({Key? key}) : super(key: key);

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<CompleteForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = true;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void _showMultiSelectStudents() async {
    final db = FirebaseFirestore.instance;
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    List studentsArr = [];

    await db.collection("students").get().then((value) {
      for (var item in value.docs) {
        studentsArr.add(Member(item.get('name'), item.id));
      }
    });

    List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: studentsArr);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItemsStudent = results;
      });
    }
  }

  void _showMultiSelectTeachers() async {
    final db = FirebaseFirestore.instance;
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    List teachersArr = [];

    await db.collection("teachers").get().then((value) {
      for (var item in value.docs) {
        teachersArr.add(Member(item.get('name'), item.id));
      }
    });

    List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: teachersArr);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItemsTeacher = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new course'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState!.save();
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: 'Course Name',
                        // labelStyle: const TextStyle(color: Colors.pink),
                        suffixIcon: _nameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _nameHasError = !(_formKey
                                  .currentState?.fields['name']
                                  ?.validate() ??
                              false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      // initialValue: '0000000',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    Row(children: [
                      ElevatedButton(
                        onPressed: _showMultiSelectTeachers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.all(20.0),
                        ),
                        child: const Text('Add Teachers'),
                      ),
                      // display selected items
                      Chip(
                          label: Text('${_selectedItemsTeacher.length.toString()} teachers added')
                      ),
                    ]),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _showMultiSelectStudents,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.all(20.0),
                          ),
                          child: const Text('Add Students'),
                        ),
                        // display selected items
                        Chip(
                          label: Text('${_selectedItemsStudent.length.toString()} students added')
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          insertData(_formKey.currentState?.value);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Added Successfully"),
                          ));
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Validation Failed"),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink, // background
                        padding: const EdgeInsets.all(20.0),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20.0),
                      ),
                      // color: Theme.of(context).colorScheme.secondary,
                      child:
                          Text('Reset', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Member {
  String name;
  String id;

  Member(this.name, this.id);

  @override
  String toString() {
    return name;
  }

  String getID() {
    return id;
  }
}

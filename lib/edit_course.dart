import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MultiSelect.dart';

class EditCourse extends StatefulWidget {
  const EditCourse({super.key, required this.courseID});
  final String courseID;

  @override
  State<EditCourse> createState() => _EditCourseState(courseID: this.courseID);
}

List _selectedItemsTeacher = [];
List _selectedItemsStudent = [];

void editData(unmodifiedData, courseID) {
  final db = FirebaseFirestore.instance;

  List studentIDs = _selectedItemsStudent.map((e) => jsonDecode(e)["id"]).toList();
  List teacherIDs = _selectedItemsTeacher.map((e) => jsonDecode(e)["id"]).toList();

  var data = {
    "name": unmodifiedData['name'],
    "code": unmodifiedData['code'],
    "duration": unmodifiedData['duration'],
    "students": _selectedItemsStudent,
    "teachers": _selectedItemsTeacher,
    "student_ids": studentIDs,
    "teacher_ids": teacherIDs,
  };

  db.collection("courses").doc(courseID).set(data, SetOptions(merge: true));
}

class _EditCourseState extends State<EditCourse> {
  _EditCourseState({required this.courseID});

  final String courseID;

  @override
  Widget build(BuildContext context) {
    return CompleteForm(courseID: courseID);
  }
}

class CompleteForm extends StatefulWidget {
  CompleteForm({Key? key, required this.courseID}) : super(key: key);
  final String courseID;

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState(courseID: courseID);
  }
}

class _CompleteFormState extends State<CompleteForm> {
  _CompleteFormState({required this.courseID});
  final String courseID;

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = false;
  bool _codeHasError = true;
  bool _durationHasError = true;
  bool loaded = false;
  final db = FirebaseFirestore.instance;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void _showMultiSelectStudents() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    List studentsArr = [];

    await db.collection("students").get().then((value) {
      for (var item in value.docs) {
        studentsArr.add(Member(item.get('name'), item.id));
      }
    });

    List? results = await showDialog(
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
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    List teachersArr = [];

    await db.collection("teachers").get().then((value) {
      for (var item in value.docs) {
        teachersArr.add(Member(item.get('name'), item.id));
      }
    });

    List? results = await showDialog(
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
    return FutureBuilder(
        future: db.collection("courses").doc(courseID).get(),
    builder: (ctx, snapshot) {
      if (snapshot.connectionState != ConnectionState.done && !loaded) {
        return const CircularProgressIndicator();
      } else {
        loaded = true;
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit course'),
          backgroundColor: Colors.blueGrey,
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
                        initialValue: snapshot.data?.get('name'),
                        decoration: InputDecoration(
                          labelText: 'Course Name',
                          // labelStyle: const TextStyle(color: Colors.blueGrey),
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
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'code',
                        initialValue: snapshot.data?.get('code'),
                        decoration: InputDecoration(
                          labelText: 'Course Code',
                          // labelStyle: const TextStyle(color: Colors.blueGrey),
                          suffixIcon: _codeHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _codeHasError = !(_formKey
                                .currentState?.fields['code']
                                ?.validate() ??
                                false);
                          });
                        },
                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        // initialValue: '0000000',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 25),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'duration',
                        initialValue: snapshot.data?.get('duration'),
                        decoration: InputDecoration(
                          labelText: 'Course Duration in Hours',
                          // labelStyle: const TextStyle(color: Colors.blueGrey),
                          suffixIcon: _durationHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _durationHasError = !(_formKey
                                .currentState?.fields['duration']
                                ?.validate() ??
                                false);
                          });
                        },
                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required(),
                        ]),
                        // initialValue: '0000000',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 25),
                      Row(children: [
                        ElevatedButton(
                          onPressed: _showMultiSelectTeachers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.all(20.0),
                          ),
                          child: const Text('Add Teachers'),
                        ),
                        // display selected items
                        Chip(
                            label: Text('${_selectedItemsTeacher.length
                                .toString()} teachers added')
                        ),
                      ]),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _showMultiSelectStudents,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.all(20.0),
                            ),
                            child: const Text('Add Students'),
                          ),
                          // display selected items
                          Chip(
                              label: Text('${_selectedItemsStudent.length
                                  .toString()} students added')
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
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            debugPrint(_formKey.currentState?.value.toString());
                            editData(_formKey.currentState?.value, courseID);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Edited Successfully"),
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
                          backgroundColor: Colors.blueGrey, // background
                          padding: const EdgeInsets.all(20.0),
                        ),
                        child: const Text(
                          'Edit',
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

  Map toJson() => {
    'name': name,
    'id': id,
  };
}
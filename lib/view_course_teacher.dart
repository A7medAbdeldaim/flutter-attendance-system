import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/list_course_students.dart';

import 'MultiSelect.dart';
import 'dart:convert';

import 'list_student_lectures.dart';
import 'list_teacher_lectures.dart';

class ViewCourseTeacher extends StatefulWidget {
  const ViewCourseTeacher({super.key, required this.courseID});

  final String courseID;

  @override
  State<ViewCourseTeacher> createState() =>
      _ViewCourseTeacherState(courseID: this.courseID);
}

class _ViewCourseTeacherState extends State<ViewCourseTeacher> {
  _ViewCourseTeacherState({required this.courseID});

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
  bool loaded = false;
  final db = FirebaseFirestore.instance;

  void _onChanged(dynamic val) => debugPrint(val.toString());

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
              title: const Text('View course'),
              backgroundColor: Colors.blueGrey,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _formKey,
                      enabled: false,
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
                            decoration: const InputDecoration(
                              labelText: 'Course Name',
                            ),
                          ),
                          const SizedBox(height: 25),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'code',
                            initialValue: snapshot.data?.get('code'),
                            decoration: const InputDecoration(
                              labelText: 'Course Code',
                            ),
                          ),
                          const SizedBox(height: 25),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'duration',
                            initialValue: snapshot.data?.get('duration'),
                            decoration: const InputDecoration(
                              labelText: 'Course Duration in Hours',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 25),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'teacher_name',
                            initialValue: jsonDecode(
                                snapshot.data?.get('teachers')?[0])['name'],
                            decoration: const InputDecoration(
                              labelText: 'Teacher Name',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 25),
                          Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListTeacherLectures(
                                          courseID: courseID)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: const EdgeInsets.all(20.0),
                              ),
                              child: const Text('View Lectures'),
                            ),
                            const SizedBox(width: 25),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListCourseStudents(
                                          courseID: courseID)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: const EdgeInsets.all(20.0),
                              ),
                              child: const Text('View Students'),
                            ),
                          ])
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

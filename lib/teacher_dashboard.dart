import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:localstorage/localstorage.dart';
import 'package:untitled/create_course.dart';
import 'package:untitled/create_teacher.dart';
import 'package:untitled/create_teacher.dart';
import 'package:untitled/edit_course.dart';
import 'package:untitled/edit_teacher.dart';
import 'package:untitled/edit_teacher.dart';
import 'package:untitled/list_lectures.dart';
import 'package:untitled/list_teacher_courses.dart';
import 'package:untitled/mobile.dart';
import 'package:untitled/view_report_student.dart';
import 'package:untitled/view_report_teacher.dart';
import 'SecondScreen.dart';
import 'list_teacher_courses.dart';
import 'login_teacher.dart';
import 'nav_drawer.dart';


class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final db = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {

    print(storage.getItem('teacherID'));
    return Scaffold(
        backgroundColor: Colors.white,
        body: MaterialApp(
          home: Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
              title: const Text('Teacher Dashboard'),
              backgroundColor: Colors.blueGrey,
            ),
            body: Column(children: [
              SizedBox(
                height: 200, // constrain height
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 1,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                        boxShadow: const [
                          BoxShadow(color: Colors.white, spreadRadius: 5),
                        ],
                      ),
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "No. of My Courses",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                FutureBuilder(
                                    future: db
                                        .collection("courses")
                                        .where("teacher_ids",
                                        arrayContains:
                                        storage.getItem('teacherID'))
                                        .count()
                                        .get(),
                                    builder: (ctx, snapshot) {
                                      print(storage.getItem('teacherID'));
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return const CircularProgressIndicator();
                                      }
                                      return Text(
                                        '${snapshot.data?.count}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }),
                              ])),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 200, // constrain height
                child: ListView(
                  children: ListTile.divideTiles(context: context, tiles: [
                    ListTile(
                      title: const Text('View Courses'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListTeacherCourses()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('View Attendance Report'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewReportTeacher()),
                        );
                      },
                    )
                  ]).toList(),
                ),
              ),
            ]),
          ),
        ));
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:untitled/generate_otp.dart';

import 'enter_otp.dart';

class ListCourseStudents extends StatefulWidget {
  const ListCourseStudents({super.key, required this.courseID});

  final String courseID;
  @override
  State<ListCourseStudents> createState() => _ListCourseStudentsState(courseID: this.courseID);
}

class _ListCourseStudentsState extends State<ListCourseStudents> {
  final LocalStorage storage = LocalStorage('localstorage_app');

  _ListCourseStudentsState({required this.courseID});
  final String courseID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Students"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body:
      StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("courses")
              .doc(courseID)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Transform.scale(
                scale: 0.25,
                child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),),
              );
            }
            if (!snapshot.hasData) {
              return const Text("No Data");
            }

            final userSnapshot = snapshot.data?.get('students');

            return ListView.builder(
                itemCount: userSnapshot.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(jsonDecode(userSnapshot[index])['name'][0]),
                    ),
                    title: Text(jsonDecode(userSnapshot[index])['name']),
                    onTap: () { }, //
                  );
                });
          }),
    );
  }
}

bool isClickable(snapshot) {
  DateTime startDate = snapshot.get('start_date').toDate();
  DateTime endDate = snapshot.get('end_date').toDate();
  DateTime now = DateTime.now();

  Duration diff1 = now.difference(startDate); // Is negative means start date is larger than now
  Duration diff2 = now.difference(endDate); // Is negative means end date is larger than now

  if (!diff1.isNegative && diff2.isNegative) {
    return true;
  }

  return false;
}
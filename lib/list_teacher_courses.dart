import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:untitled/generate_otp.dart';
import 'package:untitled/list_teacher_lectures.dart';
import 'enter_otp.dart';

class ListTeacherCourses extends StatefulWidget {
  const ListTeacherCourses({super.key});

  @override
  State<ListTeacherCourses> createState() => _ListTeacherCoursesState();
}

class _ListTeacherCoursesState extends State<ListTeacherCourses> {
  final LocalStorage storage = LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Courses"),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body:
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("courses")
              .where("teachers", arrayContains: storage.getItem('ID'))
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Transform.scale(
                scale: 0.25,
                child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),),
              );
            }
            final userSnapshot = snapshot.data?.docs;
            if (userSnapshot!.isEmpty) {
              return const Text("No Data");
            }
            return ListView.builder(
                itemCount: userSnapshot.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink,
                      child: Text(userSnapshot[index]["name"][0]),
                    ),
                    title: Text(userSnapshot[index]["name"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListTeacherLectures(courseID:userSnapshot[index].id)),
                      );
                    }, //
                  );
                });
          }),
    );
  }
}

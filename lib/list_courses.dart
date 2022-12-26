import 'package:flutter/material.dart';
import 'package:untitled/generate_otp.dart';

import 'enter_otp.dart';

class ListCourses extends StatefulWidget {
  const ListCourses({super.key});

  @override
  State<ListCourses> createState() => _ListCoursesState();
}

class _ListCoursesState extends State<ListCourses> {
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
      ListView.builder(
        itemCount: 5,
        itemBuilder: (context, position) {
          return ListTile(
            title: Text('Course $position'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GenerateOTP()),
              );
            }, // Handle your onTap here.
          );
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Course " + position.toString(),
                style: TextStyle(fontSize: 22.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

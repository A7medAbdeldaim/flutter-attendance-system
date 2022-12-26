import 'package:flutter/material.dart';
import 'enter_otp.dart';

class ListCourses2 extends StatefulWidget {
  const ListCourses2({super.key});

  @override
  State<ListCourses2> createState() => _ListCourses2State();
}

class _ListCourses2State extends State<ListCourses2> {
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
                MaterialPageRoute(builder: (context) => const EnterOTP()),
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

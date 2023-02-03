import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/create_course.dart';
import 'package:untitled/create_lecture.dart';
import 'package:untitled/create_student.dart';
import 'package:untitled/create_teacher.dart';
import 'SecondScreen.dart';
import 'edit_lecture.dart';
import 'login_teacher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListLectures extends StatefulWidget {
  const ListLectures({super.key, required this.courseID});

  final String courseID;

  @override
  State<ListLectures> createState() =>
      _ListLecturesState(courseID: this.courseID);
}

class _ListLecturesState extends State<ListLectures> {
  _ListLecturesState({required this.courseID});

  final String courseID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Lectures"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("lectures")
              .where("course_id", isEqualTo: courseID)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Transform.scale(
                scale: 0.25,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                ),
              );
            }
            final userSnapshot = snapshot.data?.docs;
            if (userSnapshot!.isEmpty) {
              return const Text("No Data");
            }
            return ListView.builder(
                itemCount: userSnapshot.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditLecture(lectureID: userSnapshot[index].id)));
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            remove(userSnapshot[index].id);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Remove',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: ListTile(
                      title: Text(userSnapshot[index]["name"]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text(userSnapshot[index]["name"][0]),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateLecture(courseID: courseID)));
        },
        tooltip: 'Add a new Lecture',
        label: const Text('Add a new Lecture'),
        backgroundColor: Colors.blueGrey,
        icon: const Icon(Icons.add),
      ),
    );
  }
}

void remove(String lectureID) {
  final db = FirebaseFirestore.instance;

  db.collection("lectures").doc(lectureID).delete();
}

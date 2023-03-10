import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:untitled/generate_otp.dart';

import 'enter_otp.dart';

class ListStudentLectures extends StatefulWidget {
  const ListStudentLectures({super.key, required this.courseID});

  final String courseID;
  @override
  State<ListStudentLectures> createState() => _ListStudentLecturesState(courseID: this.courseID);
}

class _ListStudentLecturesState extends State<ListStudentLectures> {
  final LocalStorage storage = LocalStorage('localstorage_app');

  _ListStudentLecturesState({required this.courseID});
  final String courseID;

  @override
  Widget build(BuildContext context) {
    print('Hena2: ${storage.getItem('studentID')}');
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Lectures"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body:
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("lectures")
              .where("course_id", isEqualTo: courseID)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Transform.scale(
                scale: 0.25,
                child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),),
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
                      backgroundColor: Colors.blueGrey,
                      child: Text(userSnapshot[index]["name"][0]),
                    ),
                    title: Text(userSnapshot[index]["name"]),
                    subtitle: Text(getText(userSnapshot[index])),
                    onTap: () {
                      if (isClickable(userSnapshot[index])) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterOTP(snapshot: userSnapshot[index])),
                        );
                      }
                    }, //
                  );
                });
          }),
    );
  }
}

String getText(snapshot) {
  DateTime startDate = snapshot.get('start_date').toDate();
  DateTime endDate = snapshot.get('end_date').toDate();
  DateTime now = DateTime.now();

  Duration diff1 = now.difference(startDate); // Is negative means start date is larger than now
  Duration diff2 = now.difference(endDate); // Is negative means end date is larger than now

  if(diff1.isNegative) {
    return 'Lecture did not started yet, will start at ${startDate.toString()}';
  } else if (!diff1.isNegative && diff2.isNegative) {
    return 'Lecture started and will end at ${endDate.toString()}';
  }

  return 'Lecture ended at ${endDate.toString()}';
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

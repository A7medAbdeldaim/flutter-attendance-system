import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:untitled/student_dashboard.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key, required this.snapshot});

  final snapshot;

  @override
  State<SecondScreen> createState() => _SecondScreenState(snapshot: snapshot);
}

class _SecondScreenState extends State<SecondScreen> {
  _SecondScreenState({this.snapshot});

  final db = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('localstorage_app');

  final snapshot;

  @override
  Widget build(BuildContext context) {
    print('${snapshot}');
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Check-in"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Center(
          child: SizedBox(
            height: 200, // constrain height
            child: FutureBuilder(
                future:
                    db.collection("students_attendance").doc(snapshot).get(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }
                  return Column(children: [
                    Text(
                      "You checked in at ${snapshot.data?.get('check_in').toDate().toString()}",
                      style: TextStyle(fontSize: 38, color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      snapshot.data?.get('is_late'),
                      style: const TextStyle(fontSize: 38, color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        var data = {
                          "check_out": DateTime.now(),
                        };

                        await db.collection("students_attendance")
                            .doc('${snapshot.data?.id}')
                            .set(data, SetOptions(merge: true));

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => StudentDashboard()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.all(20.0),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ]);
                }),
          ),
        ),
      ),
    );
  }
}

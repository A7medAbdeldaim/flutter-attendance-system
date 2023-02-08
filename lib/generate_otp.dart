import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:math';
import 'SecondScreen.dart';

const _chars = '1234567890';
Random _rnd = Random();
int otpTimeout = 300;

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class GenerateOTP extends StatefulWidget {
  GenerateOTP({super.key, required this.snapshot});

  final snapshot;

  @override
  State<GenerateOTP> createState() =>
      _GenerateOTPState(snapshot: this.snapshot);
}

class _GenerateOTPState extends State<GenerateOTP> {
  _GenerateOTPState({required this.snapshot});

  final snapshot;
  final LocalStorage storage = LocalStorage('localstorage_app');
  final db = FirebaseFirestore.instance;

  String otp = '';
  String btnText1 = 'Generate';
  bool shouldAbsorb = false;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (shouldAbsorb == true) {
          otpTimeout--;
          btnText1 = 'Available until ${getTimeLeft(otpTimeout)}';
          if (otpTimeout < 0) {
            otp = '';
            btnText1 = 'Generate';
            shouldAbsorb = false;
          }
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Generate OTP"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 65),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Text(
                  otp,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 75,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 10),
                ),
              ),
              const SizedBox(height: 35),
              AbsorbPointer(
                absorbing: shouldAbsorb,
                child: GestureDetector(
                  onTap: () async {
                    otp = getRandomString(6);
                    await db.collection("lectures").doc(snapshot).set({
                      'otp': otp,
                      'otp_expire': DateTime.now()
                          .add(const Duration(seconds: 300))
                          .millisecondsSinceEpoch,
                    }, SetOptions(merge: true));

                    var lecture_data;
                    await db.collection("lectures").doc(snapshot).get().then(
                      (DocumentSnapshot doc) {
                        lecture_data = doc.data() as Map<String, dynamic>;
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );

                    var course_data;
                    await db
                        .collection("courses")
                        .doc(lecture_data['course_id'])
                        .get()
                        .then(
                      (DocumentSnapshot doc) {
                        course_data = doc.data() as Map<String, dynamic>;
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );
                    course_data = jsonDecode(jsonEncode(course_data));
                    print(course_data['student_ids']);
                    await db
                        .collection("students")
                        .where(FieldPath.documentId,
                            whereIn: course_data['student_ids'])
                        .get()
                        .then(
                      (doc) async {
                        print(doc.docs.length);
                        for (var element in doc.docs) {
                          var data = {
                            "lecture_id": snapshot,
                            "lecture_name": lecture_data['name'],
                            "student_id": element.id,
                            "student_name": element['name'],
                            "course_name": course_data['name'],
                            "teacher_id": course_data['teacher_ids']?[0],
                            "is_late": 'Absent'
                          };

                          await db
                              .collection('students_attendance')
                              .doc('$snapshot-${element.id}')
                              .get().then((value) => {
                                if (!value.exists) {
                                  db.collection("students_attendance")
                                      .doc('$snapshot-${element.id}')
                                      .set(data, SetOptions(merge: true))
                                }
                              });
                        }
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );

                    setState(() {
                      otp;
                      otpTimeout = 300;
                      btnText1 = 'Available until ${getTimeLeft(otpTimeout)}';
                      shouldAbsorb = true;
                    });
                  },
                  child: Container(
                    width: 350.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blueGrey,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          btnText1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTimeLeft(int timeLeft) {
    return '${getNumberFormat(timeLeft ~/ 60)}:${getNumberFormat(timeLeft % 60)}';
  }

  String getNumberFormat(int num) {
    return num < 10 ? '0$num' : num.toString();
  }
}

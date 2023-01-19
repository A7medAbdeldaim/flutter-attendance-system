import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'secondscreen.dart';
import 'list_student_lectures.dart';

class EnterOTP extends StatefulWidget {
  const EnterOTP({super.key, required this.snapshot});
  final snapshot;

  @override
  State<EnterOTP> createState() => _EnterOTPState(snapshot: this.snapshot);
}

class _EnterOTPState extends State<EnterOTP> {
  _EnterOTPState({required this.snapshot});
  final snapshot;
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }
  final db = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {
    print('Hena3: ${storage.getItem('studentID')}');
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Enter OTP"),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 70,
                    fieldWidth: 70,
                    activeFillColor:
                    hasError ? Colors.orange : Colors.white,
                  ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    textStyle: TextStyle(fontSize: 20, height: 1.6),
                    backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                  onChanged: (value) async {
                    if (value == snapshot.get('otp')) {
                      var data = {
                        "lecture_id": snapshot.id,
                        "student_id": storage.getItem('studentID'),
                        "course_id": snapshot.get('course_id'),
                        "check_in": DateTime.now(),
                        "is_late": DateTime.now().difference(snapshot.get('start_date').toDate()).isNegative,
                      };

                      await db.collection("students_attendance")
                          .doc('${snapshot.id}-${storage.getItem('studentID')}')
                          .set(data, SetOptions(merge: true));

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SecondScreen(snapshot: '${snapshot.id}-${storage.getItem('studentID')}')));

                    } else if (value != snapshot.get('otp') && value.length == 6) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text("Wrong OTP"),
                      ));
                    }
                  },
                  appContext: context,
                ),
              ),
              ),
              const SizedBox(height: 35),
              GestureDetector(
                child: Container(
                  width: 350.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.pink,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Enter OTP',
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
            ],
          ),
        ),
      ),
    );
  }
}

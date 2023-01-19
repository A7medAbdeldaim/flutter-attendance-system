import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:math';
import 'SecondScreen.dart';

const _chars = '1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class GenerateOTP extends StatefulWidget {
  GenerateOTP({super.key, required this.snapshot});
  final snapshot;

  @override
  State<GenerateOTP> createState() => _GenerateOTPState(snapshot: this.snapshot);
}

class _GenerateOTPState extends State<GenerateOTP> {
  _GenerateOTPState({required this.snapshot});
  final snapshot;
  final LocalStorage storage = LocalStorage('localstorage_app');
  final db = FirebaseFirestore.instance;

  String otp = '';
  String btnText1 = 'Generate';
  int x = 600;
  bool shouldAbsorb = false;
  late Timer _timer;

  @override
  void initState() {

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (shouldAbsorb == true) {
            x--;
            btnText1 = 'Available until $x';
            if (x < 0) {
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
        backgroundColor: Colors.pink,
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
                    await db.collection("lectures")
                        .doc(snapshot)
                        .set({'otp': otp}, SetOptions(merge: true));
                    setState(() {
                      otp;
                      x = 600;
                      btnText1 = 'Available until $x';
                      shouldAbsorb = true;

                    });
                  },
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
}

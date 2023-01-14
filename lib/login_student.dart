import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:untitled/login_teacher.dart';
import 'SecondScreen.dart';
import 'list_courses.dart';

class LoginStudent extends StatefulWidget {
  const LoginStudent({super.key});

  @override
  State<LoginStudent> createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _passwordHasError = true;
  bool _idHasError = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pinkAccent,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.9,
              child: Center(
                child: const Text(
                  'Attendance System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white60.withOpacity(0.65),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: FormBuilder(
                      key: _formKey,
                      // enabled: false,
                      onChanged: () {
                        _formKey.currentState!.save();
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      skipDisabled: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'id',
                            decoration: InputDecoration(
                              labelText: 'KKU ID',
                              // labelStyle: const TextStyle(color: Colors.pink),
                              suffixIcon: _idHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check,
                                  color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _idHasError = !(_formKey
                                    .currentState?.fields['id']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                            ]),
                            // initialValue: '0000000',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 15),
                          FormBuilderTextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            autovalidateMode: AutovalidateMode.always,
                            name: 'password',
                            decoration: InputDecoration(
                              labelText: 'Password',
                              // labelStyle: const TextStyle(color: Colors.pink),
                              suffixIcon: _passwordHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check,
                                  color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _passwordHasError = !(_formKey
                                    .currentState?.fields['password']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            // initialValue: '0000000',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,

                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 35),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                debugPrint(
                                    _formKey.currentState?.value.toString());
                                final db = FirebaseFirestore.instance;
                                await db
                                    .collection("students")
                                    .where("id",
                                    isEqualTo:
                                    _formKey.currentState?.value['id'])
                                    .where("password",
                                    isEqualTo: _formKey
                                        .currentState?.value['password'])
                                    .get()
                                    .then((value) {
                                  for (var element in value.docs) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const ListCourses()));
                                  }
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Student Not Found"),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Validation Failed"),
                                ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.pink,
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Login Student',
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
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const LoginTeacher()));
                                  },
                                  child: const Text(
                                    'Login Teacher',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

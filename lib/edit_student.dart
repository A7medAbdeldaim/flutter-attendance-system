import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MultiSelect.dart';


class EditStudent extends StatefulWidget {
  const EditStudent({super.key, required this.studentID});
  final String studentID;

  @override
  State<EditStudent> createState() => _EditStudentState(studentID: this.studentID);
}

void editData(unmodifiedData, studentID) {
  final db = FirebaseFirestore.instance;

  db.collection("students").doc(studentID).set(unmodifiedData, SetOptions(merge: true));
}

class _EditStudentState extends State<EditStudent> {
  _EditStudentState({required this.studentID});

  final String studentID;

  @override
  Widget build(BuildContext context) {
    return CompleteForm(studentID: studentID);
  }
}

class CompleteForm extends StatefulWidget {
  CompleteForm({Key? key, required this.studentID}) : super(key: key);
  final String studentID;

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState(studentID: this.studentID);
  }
}

class _CompleteFormState extends State<CompleteForm> {
  _CompleteFormState({required this.studentID});
  final String studentID;

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _idHasError = false;
  bool _nameHasError = false;
  bool _emailHasError = false;
  bool _passwordHasError = false;
  final db = FirebaseFirestore.instance;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.collection("students").doc(studentID).get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !loaded) {
            return const CircularProgressIndicator();
          } else {
            loaded = true;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit student'),
              backgroundColor: Colors.blueGrey,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _formKey,
                      // enabled: false,
                      onChanged: () {
                        _formKey.currentState!.save();
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      skipDisabled: true,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 15),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'id',
                            initialValue: snapshot.data?.get('id'),
                            decoration: InputDecoration(
                              labelText: 'KKU ID',
                              // labelStyle: const TextStyle(color: Colors.blueGrey),
                              suffixIcon: _idHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check, color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _idHasError = !(_formKey.currentState?.fields['id']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                              FormBuilderValidators.equalLength(10),
                            ]),
                            // initialValue: '0000000',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'name',
                            initialValue: snapshot.data?.get('name'),
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              // labelStyle: const TextStyle(color: Colors.blueGrey),
                              suffixIcon: _nameHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check, color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _nameHasError = !(_formKey.currentState?.fields['name']
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
                          ),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'email',
                            initialValue: snapshot.data?.get('email'),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              // labelStyle: const TextStyle(color: Colors.blueGrey),
                              suffixIcon: _emailHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check, color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _emailHasError = !(_formKey.currentState?.fields['email']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                                  (input) => RegExp(
                                  r'^[A-Za-z0-9._%+-]+@kku\.edu\.sa$')
                                  .hasMatch(input!) ? null : "email should be on kku.edu.sa",
                            ]),
                            // initialValue: '0000000',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            name: 'password',
                            initialValue: snapshot.data?.get('password'),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              // labelStyle: const TextStyle(color: Colors.blueGrey),
                              suffixIcon: _passwordHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check, color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _passwordHasError = !(_formKey.currentState?.fields['password']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.equalLength(10),
                              (input) => RegExp(
                                  r'^(?=.*[a-zA-Z])(?=.*[0-9])')
                                  .hasMatch(input!) ? null : "Password should contain characters and numbers",
                            ]),
                            // initialValue: '0000000',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                debugPrint(
                                    _formKey.currentState?.value.toString());
                                editData(
                                    _formKey.currentState?.value, studentID);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Edited Successfully"),
                                ));
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Validation Failed"),
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey, // background
                              padding: const EdgeInsets.all(20.0),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20.0),
                            ),
                            // color: Theme.of(context).colorScheme.secondary,
                            child:
                            const Text(
                                'Reset', style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MultiSelect.dart';


class EditTeacher extends StatefulWidget {
  const EditTeacher({super.key, required this.teacherID});
  final String teacherID;

  @override
  State<EditTeacher> createState() => _EditTeacherState(teacherID: this.teacherID);
}

void editData(unmodifiedData, teacherID) {
  final db = FirebaseFirestore.instance;

  db.collection("teachers").doc(teacherID).set(unmodifiedData, SetOptions(merge: true));
}

class _EditTeacherState extends State<EditTeacher> {
  _EditTeacherState({required this.teacherID});

  final String teacherID;

  @override
  Widget build(BuildContext context) {
    return CompleteForm(teacherID: teacherID);
  }
}

class CompleteForm extends StatefulWidget {
  CompleteForm({Key? key, required this.teacherID}) : super(key: key);
  final String teacherID;

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState(teacherID: this.teacherID);
  }
}

class _CompleteFormState extends State<CompleteForm> {
  _CompleteFormState({required this.teacherID});
  final String teacherID;

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
        future: db.collection("teachers").doc(teacherID).get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !loaded) {
            return const CircularProgressIndicator();
          } else {
            loaded = true;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit teacher'),
              backgroundColor: Colors.pink,
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
                              // labelStyle: const TextStyle(color: Colors.pink),
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
                              // labelStyle: const TextStyle(color: Colors.pink),
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
                              // labelStyle: const TextStyle(color: Colors.pink),
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
                              // labelStyle: const TextStyle(color: Colors.pink),
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
                                    _formKey.currentState?.value, teacherID);
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
                              backgroundColor: Colors.pink, // background
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
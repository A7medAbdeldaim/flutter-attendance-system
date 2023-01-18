import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MultiSelect.dart';


class EditLecture extends StatefulWidget {
  const EditLecture({super.key, required this.lectureID});
  final String lectureID;

  @override
  State<EditLecture> createState() => _EditLectureState(lectureID: this.lectureID);
}

void editData(unmodifiedData, lectureID) {
  final db = FirebaseFirestore.instance;

  var data = {
    "name": unmodifiedData['name'],
    "start_date": unmodifiedData['start_date'],
    "end_date": unmodifiedData['end_date'],
  };

  db.collection("lectures").doc(lectureID).set(data, SetOptions(merge: true));
}

class _EditLectureState extends State<EditLecture> {
  _EditLectureState({required this.lectureID});

  final String lectureID;

  @override
  Widget build(BuildContext context) {
    return CompleteForm(lectureID: this.lectureID);
  }
}

class CompleteForm extends StatefulWidget {
  CompleteForm({Key? key, required this.lectureID}) : super(key: key);
  final String lectureID;

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState(lectureID: this.lectureID);
  }
}

class _CompleteFormState extends State<CompleteForm> {
  _CompleteFormState({required this.lectureID});
  final String lectureID;

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = false;
  bool _startDateHasError = false;
  bool _endDateHasError = false;
  final db = FirebaseFirestore.instance;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.collection("lectures").doc(lectureID).get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !loaded) {
            return const CircularProgressIndicator();
          } else {
            loaded = true;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit lecture'),
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
                            name: 'name',
                            initialValue: snapshot.data?['name'],
                            decoration: InputDecoration(
                              labelText: 'Lecture Name',
                              // labelStyle: const TextStyle(color: Colors.pink),
                              suffixIcon: _nameHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(
                                  Icons.check, color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _nameHasError = !(_formKey
                                    .currentState?.fields['name']
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
                          FormBuilderDateTimePicker(
                            name: 'start_date',
                            enabled: true,
                            initialValue: snapshot.hasData ? snapshot.data?.get('start_date').toDate() : null,
                            decoration: InputDecoration(
                                labelText: 'Start Date',
                                suffixIcon: _startDateHasError
                                    ? const Icon(Icons.error, color: Colors.red)
                                    : const Icon(
                                    Icons.check, color: Colors.green),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.normal)),

                            onChanged: (val) {
                              setState(() {
                                _startDateHasError = !(_formKey
                                    .currentState?.fields['start_date']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            style: const TextStyle(
                                fontWeight: FontWeight.normal),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 25),
                          FormBuilderDateTimePicker(
                            name: 'end_date',
                            enabled: true,
                            initialValue: snapshot.hasData ? snapshot.data?.get('end_date').toDate() : null,
                            decoration: InputDecoration(
                                labelText: 'End Date',
                                suffixIcon: _endDateHasError
                                    ? const Icon(Icons.error, color: Colors.red)
                                    : const Icon(
                                    Icons.check, color: Colors.green),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.normal)),

                            onChanged: (val) {
                              setState(() {
                                _endDateHasError = !(_formKey
                                    .currentState?.fields['end_date']
                                    ?.validate() ??
                                    false);
                              });
                            },
                            style: const TextStyle(
                                fontWeight: FontWeight.normal),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
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
                                    _formKey.currentState?.value, lectureID);
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
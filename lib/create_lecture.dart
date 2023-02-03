import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MultiSelect.dart';


class CreateLecture extends StatefulWidget {
  const CreateLecture({super.key, required this.courseID});
  final String courseID;

  @override
  State<CreateLecture> createState() => _CreateLectureState(courseID: this.courseID);
}

void insertData(unmodifiedData, courseID) {
  final db = FirebaseFirestore.instance;

  var data = {
    "name": unmodifiedData['name'],
    "start_date": unmodifiedData['start_date'],
    "end_date": unmodifiedData['end_date'],
    "course_id": courseID,
    "duration": unmodifiedData['duration'],
  };

  db.collection("lectures").add(data).then((DocumentReference doc) {
    print('DocumentSnapshot added with ID: ${doc.id}');
  });
}

class _CreateLectureState extends State<CreateLecture> {
  _CreateLectureState({required this.courseID});

  final String courseID;

  @override
  Widget build(BuildContext context) {
    return CompleteForm(courseID: courseID);
  }
}

class CompleteForm extends StatefulWidget {
  CompleteForm({Key? key, required this.courseID}) : super(key: key);
  final String courseID;

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState(courseID: this.courseID);
  }
}

class _CompleteFormState extends State<CompleteForm> {
  _CompleteFormState({required this.courseID});
  final String courseID;

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = true;
  bool _startDateHasError = true;
  bool _endDateHasError = true;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new lecture'),
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
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: 'Lecture Name',
                        // labelStyle: const TextStyle(color: Colors.blueGrey),
                        suffixIcon: _nameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
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
                      decoration: InputDecoration(
                          labelText: 'Start Date',
                          suffixIcon: _startDateHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
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
                      decoration: InputDecoration(
                          labelText: 'End Date',
                          suffixIcon: _endDateHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
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
                    FormBuilderRadioGroup(
                      name: 'duration',
                      initialValue: "Theoretical (1 Hour)",
                      decoration: const InputDecoration(
                          labelText: 'Duration',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal)),
                      options: const [
                        FormBuilderFieldOption(value: "Theoretical (1 Hour)"),
                        FormBuilderFieldOption(value: "Practical (2 Hours)"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          insertData(_formKey.currentState?.value, courseID);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Added Successfully"),
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
                        'Submit',
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
                          const Text('Reset', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
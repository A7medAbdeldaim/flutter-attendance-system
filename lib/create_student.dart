import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

void insertData(data) {
  final db = FirebaseFirestore.instance;
  db.collection("students").add(data).then((DocumentReference doc) {
    print('DocumentSnapshot added with ID: ${doc.id}');
  });
}

class _CreateStudentState extends State<CreateStudent> {

  @override
  Widget build(BuildContext context) {
    return const CompleteForm();
  }
}

class CompleteForm extends StatefulWidget {
  const CompleteForm({Key? key}) : super(key: key);

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<CompleteForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _idHasError = true;
  bool _nameHasError = true;
  bool _emailHasError = true;
  bool _passwordHasError = true;
  bool _majorHasError = true;


  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new student'),
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
                            (input) => RegExp(
                            r'^[a-zA-Z ]+$')
                            .hasMatch(input!) ? null : "Letters only",
                      ]),
                      // initialValue: '0000000',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'major',
                      decoration: InputDecoration(
                        labelText: 'Major',
                        // labelStyle: const TextStyle(color: Colors.blueGrey),
                        suffixIcon: _majorHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _majorHasError = !(_formKey.currentState?.fields['name']
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
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      name: 'password',
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          insertData(_formKey.currentState?.value);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Added Successfully"),
                          ));
                          Navigator.of(context).pop();

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
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
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Colors.black
                        )
                      ),
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
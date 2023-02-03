import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';


var report;

void download_pdf() async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Table.fromTextArray(context: context, data: <List>[
          <String>['Username', 'FirstName', 'LastName', 'Gender'],
          ...report
              .map((data) => [
                    data['course_name'],
                    data['course_name'],
                    data['course_name'],
                    data['course_name'],
                  ])
              .toList()
        ]),
      ],
    ),
  );
  final output = await getApplicationSupportDirectory();
  final path = "${output.path}/temp.pdf";
  final file = io.File(path);
  await file.writeAsBytes(await pdf.save());
}

class ViewReportTeacher extends StatefulWidget {
  const ViewReportTeacher({super.key});

  @override
  _ViewReportTeacher createState() => _ViewReportTeacher();
}

class _ViewReportTeacher extends State<ViewReportTeacher> {
  final db = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Teacher Report"),
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: db
                            .collection("students_attendance")
                            .where('teacher_id',
                                isEqualTo: storage.getItem('teacherID'))
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const SizedBox(
                              width: 2000,
                              height: 100,
                            );
                          return DataTable(columns: const [
                            DataColumn(label: Text('Course Name')),
                            DataColumn(label: Text('Lecture Name')),
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('Check-in')),
                            DataColumn(label: Text('Check-out')),
                            DataColumn(label: Text('is_late')),
                          ], rows: _buildList(context, snapshot.data!.docs));
                        },
                      )
                    ]
                )
            ),
            Divider(),
            const SizedBox(height: 40,),
            ElevatedButton(
              onPressed: download_pdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.all(20.0),
              ),
              child: const Text('Download Report'),
            ),
          ],
        ));
  }

  List<DataRow> _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    report = snapshot;
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(Text(data['course_name'])),
      DataCell(Text(data['lecture_name'])),
      DataCell(Text(data['student_name'])),
      DataCell(Text(data['check_in'].toDate().toString())),
      DataCell(Text(data['check_out'].toDate().toString())),
      DataCell(Text(data['is_late'] ? 'True' : 'False')),
    ]);
  }
}

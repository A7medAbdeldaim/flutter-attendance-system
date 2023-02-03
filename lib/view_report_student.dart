import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ViewReportStudent extends StatefulWidget {
  const ViewReportStudent({super.key});

  @override
  _ViewReportStudent createState() => _ViewReportStudent();
}

class _ViewReportStudent extends State<ViewReportStudent> {
  final db = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Student Report"),
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection("students_attendance")
                        .where('student_id', isEqualTo: storage.getItem('studentID'))
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox(width: 2000, height: 100,);
                      return DataTable(columns: const [
                        DataColumn(label: Text('Course Name')),
                        DataColumn(label: Text('Lecture Name')),
                        DataColumn(label: Text('Check-in')),
                        DataColumn(label: Text('Check-out')),
                        DataColumn(label: Text('is_late')),
                      ], rows: _buildList(context, snapshot.data!.docs));
                    },
                  )
                ]
            )
        )
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {

    return DataRow(cells: [
      DataCell(Text(data['course_name'])),
      DataCell(Text(data['lecture_name'])),
      DataCell(Text(data['check_in'].toDate().toString())),
      DataCell(Text(data['check_out'].toDate().toString())),
      DataCell(Text(data['is_late'] ? 'True' : 'False')),
    ]);
  }
}

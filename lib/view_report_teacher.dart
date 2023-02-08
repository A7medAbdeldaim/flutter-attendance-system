import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';

import 'mobile.dart';


class ViewReportTeacher extends StatefulWidget {
  const ViewReportTeacher({super.key});

  @override
  _ViewReportTeacher createState() => _ViewReportTeacher();
}

var data;

class _ViewReportTeacher extends State<ViewReportTeacher> {
  final db = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('localstorage_app');

  final HDTRefreshController _hdtRefreshController = HDTRefreshController();

  static const int sortName = 0;
  bool isAscending = true;
  int sortType = sortName;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db
            .collection("students_attendance")
            .where('teacher_id', isEqualTo: storage.getItem("teacherID"))
            .get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !loaded) {
            return const CircularProgressIndicator();
          } else {
            loaded = true;
            data = snapshot.data!.docs;
            if (user.userInfo.isEmpty) {
              user.initData();
            }
          }
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text("Teacher Report"),
              backgroundColor: Colors.blueGrey,
            ),
            backgroundColor: Colors.white,
            body: _getBodyWidget(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: createPDF,
              tooltip: 'Download Report',
              label: const Text('Download Report'),
              backgroundColor: Colors.blueGrey,
              icon: const Icon(Icons.download),
            ),
          );
        });
  }

  Future<void> createPDF() async {
    PdfDocument document = PdfDocument();

    PdfGrid grid = getGrid();

    grid.draw(page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
    List<int> bytes = document.save();

    document.dispose();

    saveAndLaunchFile2(bytes, 'report.pdf');
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 6);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Course Name';
    headerRow.cells[1].value = 'Lecture Name';
    headerRow.cells[2].value = 'Student Name';
    headerRow.cells[3].value = 'Check In';
    headerRow.cells[4].value = 'Check Out';
    headerRow.cells[5].value = 'Status';
    //Add rows

    for (int i = 0; i < user.userInfo.length; i++) {
      addProducts(user.userInfo[i].courseName, user.userInfo[i].lectureName,
          user.userInfo[i].studentName, user.userInfo[i].checkIn,
          user.userInfo[i].checkOut,
          user.userInfo[i].status, grid);
    }

    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  void addProducts(String courseName, String lectureName, String studentName,
      String checkIn, String checkOut, String status, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = courseName;
    row.cells[1].value = lectureName;
    row.cells[2].value = studentName.toString();
    row.cells[3].value = checkIn.toString();
    row.cells[4].value = checkOut.toString();
    row.cells[5].value = status.toString();
  }

  Widget _getBodyWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 0,
        rightHandSideColumnWidth: 1200,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: user.userInfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        verticalScrollbarStyle: const ScrollbarStyle(
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        enablePullToRefresh: true,
        refreshIndicator: const WaterDropHeader(),
        refreshIndicatorHeight: 60,
        onRefresh: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 500));
          _hdtRefreshController.refreshCompleted();
        },
        htdRefreshController: _hdtRefreshController,
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Course Name', 200),
      _getTitleItemWidget('Course Name', 200),
      _getTitleItemWidget('Lecture Name', 200),
      _getTitleItemWidget('Student Name', 200),
      _getTitleItemWidget('Check in', 200),
      _getTitleItemWidget('Check out', 200),
      _getTitleItemWidget('Status', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(user.userInfo[index].courseName),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(user.userInfo[index].courseName),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(user.userInfo[index].lectureName),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(user.userInfo[index].studentName),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(user.userInfo[index].checkIn),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(user.userInfo[index].checkOut),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(user.userInfo[index].status),
        ),
      ],
    );
  }
}

User user = User();

class User {
  List userInfo = [];

  void initData() {
    userInfo = [];
    for (int i = 0; i < data.length; i++) {

      userInfo.add(AttendanceInfo(
          data[i]['course_name'],
          data[i]['lecture_name'],
          data[i]['student_name'],
          data[i].data().containsKey('check_in') ? data[i].get('check_in').toDate().toString() : '--',
          data[i].data().containsKey('check_out') ? data[i].get('check_out').toDate().toString() : '--',
          data[i]['is_late'].toString()));
    }
  }
}

class AttendanceInfo {
  String courseName;
  String lectureName;
  String studentName;
  String checkIn;
  String checkOut;
  String status;

  AttendanceInfo(this.courseName, this.lectureName, this.studentName, this.checkIn, this.checkOut,
      this.status);
}

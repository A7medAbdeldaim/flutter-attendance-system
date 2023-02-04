import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class ViewReportStudent extends StatefulWidget {
  const ViewReportStudent({super.key});

  @override
  _ViewReportStudent createState() => _ViewReportStudent();
}

var data;

class _ViewReportStudent extends State<ViewReportStudent> {
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
            .where('student_id', isEqualTo: storage.getItem("studentID"))
            .get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !loaded) {
            return const CircularProgressIndicator();
          } else {
            loaded = true;
            data = snapshot.data!.docs;
            user.initData();
          }
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text("Student Report"),
              backgroundColor: Colors.blueGrey,
            ),
            backgroundColor: Colors.white,
            body: _getBodyWidget(),
          );
        });
  }

  Widget _getBodyWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 0,
        rightHandSideColumnWidth: 1000,
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
    for (int i = 0; i < data.length; i++) {
      userInfo.add(AttendanceInfo(
          data[i]['course_name'],
          data[i]['lecture_name'],
          data[i]['check_in'].toDate().toString(),
          data[i]['check_out'].toDate().toString(),
          data[i]['is_late'].toString()));
    }
  }
}

class AttendanceInfo {
  String courseName;
  String lectureName;
  String checkIn;
  String checkOut;
  String status;

  AttendanceInfo(this.courseName, this.lectureName, this.checkIn, this.checkOut,
      this.status);
}

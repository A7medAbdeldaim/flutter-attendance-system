import 'package:flutter/material.dart';

class ViewReport extends StatefulWidget {
  const ViewReport({super.key});

  @override
  _ViewReport createState() => _ViewReport();
}

class _ViewReport extends State<ViewReport> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Check-in"),
          backgroundColor: Colors.pink,
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(children: <Widget>[
              Text("Course Name"),
              Container(
                margin: EdgeInsets.all(20),
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(120.0),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('Student Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Lecture Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-in', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-out', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: [Text('Student Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Lecture Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-in', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-out', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: [Text('Student Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Lecture Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-in', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-out', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: [Text('Student Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Lecture Name', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-in', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                      Column(children: [Text('Check-out', style: TextStyle(
                          fontSize: 20.0))
                      ]),
                    ]),
                  ],
                ),
              ),
            ])
        ));
  }
}
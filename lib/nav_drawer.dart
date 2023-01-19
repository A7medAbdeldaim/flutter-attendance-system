import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'main.dart';

class NavDrawer extends StatelessWidget {
  final LocalStorage storage = LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              storage.deleteItem('adminID');
              storage.deleteItem('studentID');
              storage.deleteItem('teacherID');
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const MyApp();
              }), (r) {
                return false;
              });
            },
          ),
        ],
      ),
    );
  }
}

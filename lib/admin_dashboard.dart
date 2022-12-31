import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SecondScreen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MaterialApp(
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Admin Dashboard'),
              backgroundColor: Colors.pink,
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Text("Teachers"),
                  ),
                  Tab(
                    icon: Text("Students"),
                  ),
                  Tab(
                    icon: Text("Courses"),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, position) {
                    return ListTile(
                      title: Text('Teacher $position'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SecondScreen()),
                        );
                      }, // Handle your onTap here.
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, position) {
                    return ListTile(
                      title: Text('Student $position'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SecondScreen()),
                        );
                      }, // Handle your onTap here.
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, position) {
                    return ListTile(
                      title: Text('Course $position'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SecondScreen()),
                        );
                      }, // Handle your onTap here.
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

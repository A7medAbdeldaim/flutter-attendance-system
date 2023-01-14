import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/craete_course.dart';
import 'package:untitled/craete_student.dart';
import 'package:untitled/craete_teacher.dart';
import 'SecondScreen.dart';
import 'login_teacher.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

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
              bottom: TabBar(
                controller: _tabController,
                tabs: const <Widget>[
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
              controller: _tabController,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("teachers")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Transform.scale(
                          scale: 0.25,
                          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),),
                        );
                      }
                      final userSnapshot = snapshot.data?.docs;
                      if (userSnapshot!.isEmpty) {
                        return const Text("No Data");
                      }
                      return ListView.builder(
                          itemCount: userSnapshot.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.pink,
                                child: Text(userSnapshot[index]["name"][0]),
                              ),
                              title: Text(userSnapshot[index]["name"]),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SecondScreen()),
                                );
                              }, //
                            );
                          });
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("students")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Transform.scale(
                          scale: 0.25,
                          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),),
                        );
                      }
                      final userSnapshot = snapshot.data?.docs;
                      if (userSnapshot!.isEmpty) {
                        return const Text("No Data");
                      }
                      return ListView.builder(
                          itemCount: userSnapshot.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.pink,
                                child: Text(userSnapshot[index]["name"][0]),
                              ),
                              title: Text(userSnapshot[index]["name"]),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SecondScreen()),
                                );
                              }, //
                            );
                          });
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("courses")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Transform.scale(
                          scale: 0.25,
                          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),),
                        );
                      }
                      final userSnapshot = snapshot.data?.docs;
                      if (userSnapshot!.isEmpty) {
                        return const Text("No Data");
                      }
                      return ListView.builder(
                          itemCount: userSnapshot.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.pink,
                                child: Text(userSnapshot[index]["name"][0]),
                              ),
                              title: Text(userSnapshot[index]["name"]),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SecondScreen()),
                                );
                              }, //
                            );
                          });
                    }),
              ],
            ),
            floatingActionButton: _bottomButtons(),
          ),
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    int ind = _tabController.index;

    if (ind == 0) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTeacher()));
        },
        tooltip: 'Add a new Teacher',
        label: const Text('Add a new Teacher'),
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add),
      );
    } else if (ind == 1) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateStudent()));
        },
        tooltip: 'Add a new Student',
        label: const Text('Add a new Student'),
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add),
      );
    } else if (ind == 2) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateCourse()));
        },
        label: const Text('Add a new Course'),
        tooltip: 'Add a new Course',
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add),
      );
    }
    return FloatingActionButton(onPressed: () {});
  }
}

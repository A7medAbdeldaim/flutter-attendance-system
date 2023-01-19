import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:untitled/create_course.dart';
import 'package:untitled/create_student.dart';
import 'package:untitled/create_teacher.dart';
import 'package:untitled/edit_course.dart';
import 'package:untitled/edit_student.dart';
import 'package:untitled/edit_teacher.dart';
import 'package:untitled/list_lectures.dart';
import 'SecondScreen.dart';
import 'login_teacher.dart';
import 'nav_drawer.dart';

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
            drawer: NavDrawer(),
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
                            return Slidable(
                              // Specify a key if the Slidable is dismissible.
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditTeacher(teacherID: userSnapshot[index].id)));
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      remove('teachers', userSnapshot[index].id);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remove',
                                  ),
                                ],
                              ),

                              // The child of the Slidable is what the user sees when the
                              // component is not dragged.
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.pink,
                                  child: Text(userSnapshot[index]["name"][0]),
                                ),
                                title: Text(userSnapshot[index]["name"]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListLectures(courseID:userSnapshot[index].id)),
                                  );
                                }, //
                              ),
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
                            return Slidable(
                              // Specify a key if the Slidable is dismissible.
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditStudent(studentID: userSnapshot[index].id)));
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      remove('students', userSnapshot[index].id);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remove',
                                  ),
                                ],
                              ),

                              // The child of the Slidable is what the user sees when the
                              // component is not dragged.
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.pink,
                                  child: Text(userSnapshot[index]["name"][0]),
                                ),
                                title: Text(userSnapshot[index]["name"]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListLectures(courseID:userSnapshot[index].id)),
                                  );
                                }, //
                              ),
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
                            return Slidable(
                              // Specify a key if the Slidable is dismissible.
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditCourse(courseID: userSnapshot[index].id)));
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      remove('courses', userSnapshot[index].id);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remove',
                                  ),
                                ],
                              ),

                              // The child of the Slidable is what the user sees when the
                              // component is not dragged.
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.pink,
                                  child: Text(userSnapshot[index]["name"][0]),
                                ),
                                title: Text(userSnapshot[index]["name"]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListLectures(courseID:userSnapshot[index].id)),
                                  );
                                }, //
                              ),
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

void remove(String doctype, String id) {
  final db = FirebaseFirestore.instance;

  db.collection(doctype).doc(id).delete();
}
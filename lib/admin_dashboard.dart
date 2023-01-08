import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SecondScreen.dart';

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
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, position) {
                    return ListTile(
                      title: Text('Teacher $position'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecondScreen()),
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
                          MaterialPageRoute(
                              builder: (context) => const SecondScreen()),
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
                          MaterialPageRoute(
                              builder: (context) => const SecondScreen()),
                        );
                      }, // Handle your onTap here.
                    );
                  },
                ),
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
        onPressed: () {},
        tooltip: 'Add a new Teacher',
          label: const Text('Add a new Teacher'),
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add),
      );
    } else if (ind == 1) {
      return FloatingActionButton.extended(
        onPressed: () {},
        tooltip: 'Add a new Student',
          label: const Text('Add a new Student'),
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add),
      );
    } else if (ind == 2) {
      return FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add a new Course'),
        tooltip: 'Add a new Course',
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add),
      );
    }
    return FloatingActionButton(onPressed: (){});
  }
}

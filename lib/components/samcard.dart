import 'package:flutter/material.dart';
import 'package:school_bell_system/components/appbar.dart';
import 'package:school_bell_system/page/test.dart';

class SystemTabsPage extends StatefulWidget {
  const SystemTabsPage({super.key});

  @override
  State<SystemTabsPage> createState() => _SystemTabsPageState();
}

class _SystemTabsPageState extends State<SystemTabsPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  text: 'Bell System',
                ),
                Tab(
                  icon: Icon(Icons.people, color: Colors.black),
                  text: 'Attendance System',
                ),
              ],
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BellSystemTab(),
          AttendanceSystemTab()
          // ScheduleUpdate(),
          // AttendanceSystemTab(),
        ],
      ),
    );
  }
}
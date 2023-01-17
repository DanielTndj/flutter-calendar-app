import 'package:calendar/provider/TaskModel.dart';
import 'package:calendar/widget/ListAllTasksWidget.dart';
import 'package:calendar/widget/ListTasksByTabWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/library/globals.dart' as globals;

class ListTasksView extends StatefulWidget {
  const ListTasksView({super.key});

  @override
  State<ListTasksView> createState() => _ListTasksViewState();
}

class _ListTasksViewState extends State<ListTasksView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
            title: Text("List Tasks"),
            bottom: const TabBar(isScrollable: true, tabs: [
              Tab(
                text: "All",
              ),
              Tab(
                text: "Today",
              ),
              Tab(
                text: "Tomorrow",
              ),
              Tab(
                text: "This Week",
              ),
              Tab(
                text: "Next Week",
              ),
            ])),
        body: TabBarView(
          children: [
            ListAllTasksWidget(),
            ListTasksByTabWidget(tabKey: globals.today),
            ListTasksByTabWidget(tabKey: globals.tomorrow),
            ListTasksByTabWidget(tabKey: globals.thisWeek),
            ListTasksByTabWidget(tabKey: globals.nextWeek)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "addTask");
          },
        ),
      ),
    );
  }
}

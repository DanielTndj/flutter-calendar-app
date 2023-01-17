import 'package:calendar/provider/TaskModel.dart';
import 'package:calendar/view/AddTaskView.dart';
import 'package:calendar/view/ListTasksView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=>TaskModel())
  ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static final String title = "Scheduler App";

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        routes: {
          "listTasks": (context)=>ListTasksView(),
          "addTask": (context)=>AddTaskView()
        },
        home: ListTasksView());
  }
}

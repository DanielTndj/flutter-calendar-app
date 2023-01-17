import 'package:flutter/material.dart';

List<MaterialColor> primaries = <MaterialColor>[
  Colors.pink,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
];

const late = 'late';
const today = 'today';
const tomorrow = 'tomorrow';
const thisWeek = 'thisWeek';
const nextWeek = 'nextWeek';
const thisMonth = 'thisMonth';
const later = 'later';

const Map<String, String> taskCategoryNames = {
  late: 'Late',
  today: 'Today',
  tomorrow: 'Tomorrow',
  thisWeek: 'This Week',
  nextWeek: 'Next Week',
  thisMonth: 'This Month',
  later: 'Later'
};

const todoTasksKey = "todo_tasks";
const doneTasksKey = "done_tasks";
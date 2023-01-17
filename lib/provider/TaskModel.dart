import 'dart:convert';

import 'package:calendar/model/Task.dart';
import 'package:flutter/material.dart';
import 'package:calendar/library/globals.dart' as globals;
import 'package:dart_date/dart_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  TaskModel() {
    initState();
  }

  void initState() {
    loadTasksFromCache();
  }

  final List<Task> _doneTasks = [];

  final Map<String, List<Task>> _todoTasks = {
    globals.late: [],
    globals.today: [],
    globals.tomorrow: [],
    globals.thisWeek: [],
    globals.nextWeek: [],
    globals.thisMonth: [],
    globals.later: [],
  };

  Map<String, List<Task>> get todoTasks => _todoTasks;
  List<Task> get doneTasks => _doneTasks;

  void markAsChecked(String key, int index) {
    _todoTasks[key]![index].status = !_todoTasks[key]![index].status;
    notifyListeners();
  }

  void markAsDone(String key, Task _task) {
    _doneTasks.add(_task);
    syncDoneTaskToCache(_task);
    // _todoTasks[key]!.removeAt(index);
    _todoTasks[key]!.removeWhere((e) => e.id == _task.id);
    notifyListeners();
  }

  void add(Task _task) {
    String _key = guessTodoKeyFromDate(_task.deadline);
    if (todoTasks.containsKey(_key)) {
      _todoTasks[_key]!.add(_task);
      notifyListeners();
    }
  }

  int countTasksByDate(DateTime _datetime) {
    String _key = guessTodoKeyFromDate(_datetime);

    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!
          .where((task) =>
              task.deadline.day == _datetime.day &&
              task.deadline.month == _datetime.month &&
              task.deadline.year == _datetime.year)
          .length;
    }

    return 0;
  }

  String guessTodoKeyFromDate(DateTime deadline) {
    if (deadline.isPast && !deadline.isToday) {
      return globals.late;
    } else if (deadline.isToday) {
      return globals.today;
    } else if (deadline.isTomorrow) {
      return globals.tomorrow;
    } else if (deadline.getWeek == DateTime.now().getWeek &&
        deadline.year == DateTime.now().year) {
      return globals.thisWeek;
    } else if (deadline.getWeek == DateTime.now().getWeek + 1 &&
        deadline.year == DateTime.now().year) {
      return globals.nextWeek;
    } else if (deadline.isThisMonth) {
      return globals.thisMonth;
    } else {
      return globals.later;
    }
  }

  void AddTaskToCache(Task _task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> _tasksList = [];
    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> _oldTasks = json.decode(data!);
      _tasksList = List<Task>.from(_oldTasks.map((e) => Task.fromJson(e)));
    }
    _tasksList.add(_task);
    await prefs.setString(globals.todoTasksKey, json.encode(_tasksList));
  }

  loadTasksFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> _oldTasks = json.decode(data!);
      List<Task> _tasksList =
          List<Task>.from(_oldTasks.map((e) => Task.fromJson(e)));

      for (int i = 0; i < _tasksList.length; i++) {
        add(_tasksList[i]);
      }
    }
  }

  void syncDoneTaskToCache(Task _task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> _tasksList = [];
    List<Task> _doneList = [];
    //retrieve all todotasks from cache
    _tasksList = await getCacheValuesByKey(globals.todoTasksKey);
    //remove todotasks from prefs
    _tasksList.removeWhere((e) => e.id == _task.id);
    //update todotask cache
    await prefs.setString(globals.todoTasksKey, json.encode(_tasksList));

    //retrieve done todotasks from cache
    _doneList = await getCacheValuesByKey(globals.doneTasksKey);
    //add done task from prefs
    _doneList.add(_task);
    //update done task cache
    await prefs.setString(globals.doneTasksKey, json.encode(_doneList));
    final String? test = prefs.getString(globals.doneTasksKey);
    print(test);
  }

  Future<List<Task>> getCacheValuesByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      final String? data = prefs.getString(key);
      List<dynamic> _oldTasks = json.decode(data!);
      return List<Task>.from(_oldTasks.map((e) => Task.fromJson(e)));
    }

    return [];
  }
}

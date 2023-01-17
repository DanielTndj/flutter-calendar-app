import 'package:calendar/model/Task.dart';
import 'package:calendar/provider/TaskModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar/library/globals.dart' as globals;

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Add New Task")),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(children: <Widget>[
                TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, datetime, events) {
                    return model.countTasksByDate(datetime) == 0
                        ? Container()
                        : SizedBox(
                            height: 20,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: globals.primaries[
                                      model.countTasksByDate(datetime)],
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Center(
                                child: Text(
                                    model.countTasksByDate(datetime).toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          );
                  }, selectedBuilder: (context, datetime, focusedDay) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.0)),
                      margin:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                      child: Center(
                        child: Text(datetime.day.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    maxLength: 100,
                    decoration: InputDecoration(
                        hintText: "Enter Task Title",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLength: 500,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Enter Task Description (optional)",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0))),
                  ),
                ),
              ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Task _newTask = Task(_titleController.text, false,
                  _descriptionController.text, _focusedDay);
              model.add(_newTask);
              model.AddTaskToCache(_newTask);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task saved..')),
              );
              Navigator.pushReplacementNamed(context, "listTasks");
            }
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

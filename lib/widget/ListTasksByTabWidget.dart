import 'package:calendar/model/Task.dart';
import 'package:calendar/provider/TaskModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/library/globals.dart' as globals;

class ListTasksByTabWidget extends StatelessWidget {
  final String tabKey;
  const ListTasksByTabWidget({super.key, required this.tabKey});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return ListView.builder(
          itemCount: model.todoTasks[tabKey]!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(model.todoTasks[tabKey]![index].title),
                    subtitle: Text(
                        model.todoTasks[tabKey]![index].deadline.toString()),
                    leading: Checkbox(
                      value: model.todoTasks[tabKey]![index].status,
                      onChanged: (bool? _isChecked) {
                        if (_isChecked!) {
                          Task _task = model.todoTasks[key]![index];

                          model.markAsChecked(tabKey, index);
                          Future.delayed(Duration(seconds: 1),
                              () => {model.markAsDone(tabKey, _task)});
                        }
                      },
                    ),
                    // controlAffinity: ListTileControlAffinity.leading,
                  )),
            );
          });
    });
  }
}

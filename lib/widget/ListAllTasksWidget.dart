import 'package:calendar/model/Task.dart';
import 'package:calendar/provider/TaskModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar/library/globals.dart' as globals;

class ListAllTasksWidget extends StatelessWidget {
  const ListAllTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return ListView.builder(
          itemCount: model.todoTasks.length,
          itemBuilder: (BuildContext context, int index) {
            String key = model.todoTasks.keys.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(globals.taskCategoryNames[key]!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: model.todoTasks[key]!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title:
                                      Text(model.todoTasks[key]![index].title),
                                  subtitle: Text(model
                                      .todoTasks[key]![index].description),
                                  leading: Checkbox(
                                    value: model.todoTasks[key]![index].status,
                                    onChanged: (bool? _isChecked) {
                                      if (_isChecked!) {
                                        Task _task = mode l.todoTasks[key]![index];
                                        model.markAsChecked(key, index);
                                        Future.delayed(Duration(seconds:1), ()=>{
                                        model.markAsDone(
                                            key, _task)
                                        });
                                      }
                                    },
                                  )
                                  // controlAffinity: ListTileControlAffinity.leading,
                                  )),
                        );
                      })
                ],
              ),
            );
          });
    });
  }
}

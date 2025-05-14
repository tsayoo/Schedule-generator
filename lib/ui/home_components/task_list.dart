import 'package:flutter/material.dart';
import 'package:schedule_generator/models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int) onRemove;
  const TaskList({super.key, required this.tasks, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      // (_, i) maksudnya sintaks singkat utk mendefinisikan sebuh perkondisian kalo indexnya gak kosong.
      itemBuilder:
          (_, i) => Card(
            child: ListTile(
              title: Text(tasks[i].name),
              subtitle: Text(
                "Duration : ${tasks[i].duration} minutes and deadline on : ${tasks[i].deadline}",
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove(i),
              ),
            ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:schedule_generator/models/task.dart';

// IMPORTANT : Buat ngedefinisiin variable yang sifatnya publik / private, wajib utk memberikan deskripsi dalam blok kode(yg di dalem kurung kurawal)
class TaskInputSection extends StatefulWidget {
  //disini publik
  final void Function(Task) onTaskAdded;
  const TaskInputSection({super.key, required this.onTaskAdded});

  @override
  State<TaskInputSection> createState() => _TaskInputSectionState();
}

class _TaskInputSectionState extends State<TaskInputSection> {
  //disini private
  final taskController = TextEditingController();
  final durationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _addTask() {
    // kondisi kalo semua input area masih kosong
    // klo && itu artinya semua kondisi harus benar kalo || bisa salah satu saja.
    if (taskController.text.isEmpty ||
        durationController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null)
      return; //knp return nya disini, soalnya kalo salah satunya true/diisi, maish bsa dijalanin.

    final deadline = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedDate!.hour,
      selectedDate!.minute,
    );

    widget.onTaskAdded(
      Task(
        name: taskController.text,
        duration: int.tryParse(durationController.text) ?? 0,
        deadline: deadline,
      ),
    );
    // statement ini akan dijalankan 1 buah task lengkap sudah dibuat dan dimasukkan ke dalam container list tasks.
    taskController.clear();
    durationController.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
    });
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: "Task Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Duration (minutes)"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickDate,
                    child: Text(
                      selectedDate == null
                          ? "Pick Date" //klo kosong muncul ini
                          : "${selectedDate!.toLocal()}".split(
                            ' ',
                          )[0], //klo udh dipilih, nongolnya ini
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickTime,
                    child: Text(
                      selectedTime == null
                          ? "Pick Time"
                          : selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _addTask, child: Text("Add Task")),
          ],
        ),
      ),
    );
  }
}

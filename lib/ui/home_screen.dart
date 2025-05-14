import 'package:flutter/material.dart';
import 'package:schedule_generator/models/task.dart';
import 'package:schedule_generator/services/gemini_service.dart';
import 'package:schedule_generator/ui/home_components/generate_button.dart';
import 'package:schedule_generator/ui/home_components/task_input.dart';
import 'package:schedule_generator/ui/home_components/task_list.dart';
import 'package:schedule_generator/ui/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  final GeminiService geminiService = GeminiService();
  bool isLoading = false;
  String? generatedResult;

  // Code handling utk action nambah/input
  void addTask(Task task) {
    setState(() => tasks.add(task));
  }

  // code handling utk hapus task
  void removeTask(int index) {
    setState(
      () => tasks.removeAt(index),
    ); //kalo mauu inline, hapus kurung kurawal.
  }

  // Code handling utk melakukan generate schedule.
  Future<void> generateSchedule() async {
    setState(() => isLoading = true);
    try {
      final result = await geminiService.generateSchedule(tasks);
      generatedResult = result;
      if (context.mounted) _showSuccessDialog();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate, because: $e')),
        );
      } //mounted tuh maksudnya ada action yang valid. harus bener bener dari user (kalo misal ada yang kepencet sendiri, ga akan jalan)
    }
    setState(() => isLoading = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Success"),
            content: Text("Schedule generated successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ResultScreen(
                            result:
                                generatedResult ??
                                "There is no result. try to generate another task",
                          ),
                    ),
                  );
                },
                child: Text("View result"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionColor = Colors.lightBlueAccent;
    final sectionTitleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule generator"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              //utk nantinya task input
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sectionColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Task Input", style: sectionTitleStyle),
                  SizedBox(height: 12),
                  TaskInputSection(onTaskAdded: addTask),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sectionColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Task List", style: sectionTitleStyle),
                    SizedBox(height: 12),
                    Expanded(
                      child: TaskList(tasks: tasks, onRemove: removeTask),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GenerateButton(isLoading: isLoading, onPressed: generateSchedule),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'database_helper.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  TaskManagementScreenState createState() => TaskManagementScreenState();
}

class TaskManagementScreenState extends State<TaskManagementScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _taskNameController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await _databaseHelper.getTasks();
    setState(() {});
  }

  Future<void> _createTask() async {
    if (_taskNameController.text.isEmpty) return;
    await _databaseHelper.createTask({
      'name': _taskNameController.text,
      'assigned_to': 1, // Replace with actual employee ID
      'status': 'Pending',
    });
    _taskNameController.clear();
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTask,
              child: Text('Create Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]['name']),
                    subtitle: Text('Status: ${_tasks[index]['status']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
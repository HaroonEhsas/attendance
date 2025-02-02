import 'package:flutter/material.dart';
import 'database_helper.dart';

class LeaveManagementScreen extends StatefulWidget {
  @override
  _LeaveManagementScreenState createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _reasonController = TextEditingController();
  List<Map<String, dynamic>> _leaves = [];

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    _leaves = await _databaseHelper.getLeaves();
    setState(() {});
  }

  Future<void> _applyLeave() async {
    if (_reasonController.text.isEmpty) return;
    await _databaseHelper.applyLeave({
      'employee_id': 1, // Replace with actual employee ID
      'start_date': DateTime.now().toString(),
      'end_date': DateTime.now().add(Duration(days: 1)).toString(),
      'reason': _reasonController.text,
      'status': 'Pending',
    });
    _reasonController.clear();
    await _loadLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leave Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(labelText: 'Reason for Leave'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _applyLeave,
              child: Text('Apply Leave'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _leaves.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_leaves[index]['reason']),
                    subtitle: Text(_leaves[index]['status']),
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
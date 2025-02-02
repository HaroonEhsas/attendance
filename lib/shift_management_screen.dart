import 'package:flutter/material.dart';
import 'database_helper.dart';

class ShiftManagementScreen extends StatefulWidget {
  const ShiftManagementScreen({super.key});

  @override
  ShiftManagementScreenState createState() => ShiftManagementScreenState();
}

class ShiftManagementScreenState extends State<ShiftManagementScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _shiftNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  List<Map<String, dynamic>> _shifts = [];

  @override
  void initState() {
    super.initState();
    _loadShifts();
  }

  Future<void> _loadShifts() async {
    _shifts = await _databaseHelper.getShifts();
    setState(() {});
  }

  Future<void> _createShift() async {
    if (_shiftNameController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty) {
      return;
    }
    await _databaseHelper.createShift({
      'name': _shiftNameController.text,
      'start_time': _startTimeController.text,
      'end_time': _endTimeController.text,
    });
    _shiftNameController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    await _loadShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shift Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _shiftNameController,
              decoration: InputDecoration(labelText: 'Shift Name'),
            ),
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
            ),
            TextField(
              controller: _endTimeController,
              decoration: InputDecoration(labelText: 'End Time (HH:MM)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createShift,
              child: Text('Create Shift'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _shifts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_shifts[index]['name']),
                    subtitle: Text(
                        '${_shifts[index]['start_time']} - ${_shifts[index]['end_time']}'),
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
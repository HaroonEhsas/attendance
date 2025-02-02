import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'team_details_screen.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  TeamManagementScreenState createState() => TeamManagementScreenState();
}

class TeamManagementScreenState extends State<TeamManagementScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _teamNameController = TextEditingController();
  List<Map<String, dynamic>> _teams = [];

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    _teams = await _databaseHelper.getTeams();
    setState(() {});
  }

  // Now, handle navigation before the async call
  void _createTeam(BuildContext context) {
    if (_teamNameController.text.isEmpty) return;

    // Navigate to TeamDetailsScreen first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailsScreen(teamName: _teamNameController.text),
      ),
    );

    // Perform the async operation afterwards
    _createTeamInDatabase();
  }

  Future<void> _createTeamInDatabase() async {
    // Creating the team in the database
    await _databaseHelper.createTeam(_teamNameController.text);
    _teamNameController.clear();
    await _loadTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(labelText: 'Team Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createTeam(context), // Use context immediately
              child: Text('Create Team'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _teams.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_teams[index]['name']),
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

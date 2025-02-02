import 'package:flutter/material.dart';

class TeamDetailsScreen extends StatelessWidget {
  final String teamName;

  TeamDetailsScreen({required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Details')),
      body: Center(
        child: Text('Team Name: $teamName'),
      ),
    );
  }
}
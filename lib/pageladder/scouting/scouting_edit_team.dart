import 'package:flutter/material.dart';

class EditTeamDialog extends StatelessWidget {
  const EditTeamDialog({super.key});

  void saveTeam() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Team"),
        actions: [
          TextButton(
            onPressed: saveTeam,
            child: const Text("Save"),
          ),
        ],
      ),
      body: Container(),
    );
  }
}

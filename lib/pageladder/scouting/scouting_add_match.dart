import 'package:flutter/material.dart';

class AddTeamMatch extends StatelessWidget {
  const AddTeamMatch({super.key});

  void saveMatch() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Match"),
        actions: [
          TextButton(
            onPressed: saveMatch,
            child: const Text("Save"),
          ),
        ],
      ),
      body: Container(),
    );
  }
}

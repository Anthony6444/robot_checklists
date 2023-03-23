import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rcs_scouting/main.dart';

class AddTeamMatch extends StatefulWidget {
  const AddTeamMatch({super.key});

  @override
  State<AddTeamMatch> createState() => _AddTeamMatchState();
}

class _AddTeamMatchState extends State<AddTeamMatch> {
  void saveMatch() {}

  TextEditingController matchNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "${appState.currentTeam}",
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: TextField(
                controller: matchNumberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Match Number"),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter,
                  LengthLimitingTextInputFormatter(3)
                ],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

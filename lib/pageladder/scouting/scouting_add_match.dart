import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:rcs_scouting/globals.dart';
import 'package:rcs_scouting/main.dart';

class AddTeamMatch extends StatefulWidget {
  const AddTeamMatch({super.key});

  @override
  State<AddTeamMatch> createState() => _AddTeamMatchState();
}

class _AddTeamMatchState extends State<AddTeamMatch> {
  void saveMatch() {}

  TextEditingController matchNumberController = TextEditingController();
  IndividualTeamMatch match = IndividualTeamMatch(
      teamNumber: 0,
      matchNumber: 0,
      autoBottom: 0,
      autoMiddle: 0,
      autoTop: 0,
      teleBottom: 0,
      teleMiddle: 0,
      teleTop: 0,
      parked: false,
      docked: false,
      cycles: 0,
      failedCycles: 0,
      allianceCooperation: Scale.LOW,
      moveQuickly: Scale.LOW,
      grabItemsWell: Scale.LOW,
      totalPointsRobot: 0,
      totalPointsAlliance: 0,
      win: false,
      winMargin: 0,
      notes: "");

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();
    match.teamNumber = appState.currentTeam;
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
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "${match.teamNumber}",
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
                  style: const TextStyle(fontSize: 30),
                  onChanged: (value) => setState(() {
                    match.matchNumber = int.parse(value);
                  }),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Auto Top (12 points each)"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.autoTop,
                onChanged: (value) {
                  setState(() {
                    match.autoTop = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Auto Middle (X points each)"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.autoMiddle,
                onChanged: (value) {
                  setState(() {
                    match.autoMiddle = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Auto Bottom (X points each)"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.autoBottom,
                onChanged: (value) {
                  setState(() {
                    match.autoBottom = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Teleop Top (X points each)"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.teleTop,
                onChanged: (value) {
                  setState(() {
                    match.teleTop = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Teleop Middle (X points each)"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.teleMiddle,
                onChanged: (value) {
                  setState(() {
                    match.teleMiddle = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Teleop Bottom (X points each)"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.teleBottom,
                onChanged: (value) {
                  setState(() {
                    match.teleBottom = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Docked"),
              ),
              const Spacer(),
              Checkbox(
                value: match.docked,
                onChanged: (value) => setState(() {
                  match.docked = value!;
                }),
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Parked"),
              ),
              const Spacer(),
              Checkbox(
                value: match.parked,
                onChanged: (value) => setState(() {
                  match.parked = value!;
                }),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Cycles"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.cycles,
                onChanged: (value) {
                  setState(() {
                    match.cycles = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: 10,
                acceptsZero: true,
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Falied Cycles"),
              ),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.failedCycles,
                onChanged: (value) {
                  setState(() {
                    match.failedCycles = int.parse(value);
                  });
                },
                minValue: 0,
                maxValue: match.cycles,
                acceptsZero: true,
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Alliance Cooperation Rating"),
              ),
              const Spacer(),
              const Text("1"),
              Radio(
                value: Scale.LOW,
                groupValue: match.allianceCooperation,
                onChanged: (value) => setState(() {
                  match.allianceCooperation = value!;
                }),
              ),
              const Text("2"),
              Radio(
                value: Scale.MID,
                groupValue: match.allianceCooperation,
                onChanged: (value) => setState(() {
                  match.allianceCooperation = value!;
                }),
              ),
              const Text("3"),
              Radio(
                value: Scale.HIGH,
                groupValue: match.allianceCooperation,
                onChanged: (value) => setState(() {
                  match.allianceCooperation = value!;
                }),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Mobility Rating"),
              ),
              const Spacer(),
              const Text("1"),
              Radio(
                value: Scale.LOW,
                groupValue: match.moveQuickly,
                onChanged: (value) => setState(() {
                  match.moveQuickly = value!;
                }),
              ),
              const Text("2"),
              Radio(
                value: Scale.MID,
                groupValue: match.moveQuickly,
                onChanged: (value) => setState(() {
                  match.moveQuickly = value!;
                }),
              ),
              const Text("3"),
              Radio(
                value: Scale.HIGH,
                groupValue: match.moveQuickly,
                onChanged: (value) => setState(() {
                  match.moveQuickly = value!;
                }),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Item Grabbing Ability Rating"),
              ),
              const Spacer(),
              const Text("1"),
              Radio(
                value: Scale.LOW,
                groupValue: match.grabItemsWell,
                onChanged: (value) => setState(() {
                  match.grabItemsWell = value!;
                }),
              ),
              const Text("2"),
              Radio(
                value: Scale.MID,
                groupValue: match.grabItemsWell,
                onChanged: (value) => setState(() {
                  match.grabItemsWell = value!;
                }),
              ),
              const Text("3"),
              Radio(
                value: Scale.HIGH,
                groupValue: match.grabItemsWell,
                onChanged: (value) => setState(() {
                  match.grabItemsWell = value!;
                }),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Text("Total Points (Alliance)"),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.totalPointsAlliance,
                onChanged: (value) {
                  setState(() {
                    match.totalPointsAlliance = int.parse(value);
                  });
                },
                acceptsZero: true,
              )
            ],
          ),
          Row(
            children: [
              const Text("Total Points (Robot)"),
              const Spacer(),
              QuantityInput(
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                value: match.totalPointsRobot,
                onChanged: (value) {
                  setState(() {
                    match.totalPointsRobot = int.parse(value);
                  });
                },
                acceptsZero: true,
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Text("Match Win"),
              const Spacer(),
              Checkbox(
                value: match.win,
                onChanged: (value) {
                  setState(() {
                    match.win = value!;
                  });
                },
              )
            ],
          ),
          Row(
            children: [
              const Text("Win Margin"),
              const Spacer(),
              QuantityInput(
                value: match.winMargin,
                onChanged: (value) {
                  setState(() {
                    match.winMargin = int.parse(value);
                  });
                },
                acceptsZero: true,
              ),
            ],
          ),
          const Divider(),
          TextField(
            autocorrect: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Comments",
            ),
            onChanged: (value) {
              setState(() {
                match.notes = value;
              });
            },
          )
        ]),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot_checklists/globals.dart';
import 'package:robot_checklists/secrets.dart';
import 'package:http/http.dart' as http;

class AddTeamDialog extends StatefulWidget {
  const AddTeamDialog({
    super.key,
  });

  @override
  State<AddTeamDialog> createState() => _AddTeamDialogState();
}

class _AddTeamDialogState extends State<AddTeamDialog> {
  DrivetrainType selectedDrivetrain = DrivetrainType.tank;

  String getDrivetrainType() {
    if (selectedDrivetrain == DrivetrainType.tank) {
      return "tank";
    } else if (selectedDrivetrain == DrivetrainType.mecanum) {
      return "mecanum";
    } else if (selectedDrivetrain == DrivetrainType.swerve) {
      return "swerve";
    } else {
      return "other";
    }
  }

  @override
  void initState() {
    super.initState();
    tbaTeamInfo = getTBATeamInfo(0);
  }

  late Future<TBATeam> tbaTeamInfo;

  Future<TBATeam> getTBATeamInfo(int team) async {
    String apiUrl = "$tbaHome/team/frc$team";
    final response = await http
        .get(Uri.parse(apiUrl), headers: {"X-TBA-Auth-Key": tbaAuthKey});
    final data = json.decode(response.body);
    if (data['Error'] != null) {
      return TBATeam(
          number: 0, longName: "Enter a valid team number", validTeam: false);
    }
    return TBATeam.fromJSON(data);
  }

  TextEditingController teamNumberController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  int selectedLevel = 1;

  Set<AutonomousFunctions> autoSelected = {};
  bool balanceAuto = false;
  bool exitHome = false;
  bool scoreAuto = false;

  Set<ScoringTypes> scoreableTypes = {};
  bool scoreCones = false;
  bool scoreCubes = false;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Expanded(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Team"),
            actions: [
              TextButton(
                  onPressed: () {
                    tbaTeamInfo.then((value) {
                      if (value.validTeam) {
                        tbaTeamInfo.then((team) async {
                          Map<String, dynamic> teamMap = {
                            "team_number":
                                int.parse(teamNumberController.value.text),
                            "team_name": team.shortName ??
                                "Team ${teamNumberController.text}",
                            "drivetrain_type": getDrivetrainType(),
                            "highest_level": selectedLevel,
                            "balance_auto": balanceAuto,
                            "exit_home_auto": exitHome,
                            "balance_teleop": true,
                            "score_auto": scoreAuto,
                            "score_cones": scoreCones,
                            "score_cubes": scoreCubes,
                            "city": team.city,
                            "state": team.stateProv,
                            "country": team.country,
                            "comments": commentsController.text,
                          };
                          String uuid = await getUUID();
                          http.post(
                            Uri.parse("$apiHome/teams/put"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'X-Space-App-Key': detaAuthKey,
                              'X-RCC-Telemetry-Uuid': uuid
                            },
                            body: jsonEncode(teamMap),
                          );
                        });
                        Navigator.pop(context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text("Invalid team"),
                                content: const Text(
                                    "Please enter a valid team number."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Close"))
                                ],
                              );
                            });
                      }
                    });
                  },
                  child: const Text("Save"))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: teamNumberController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4)
                          ],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: "OrionPax", fontSize: 30),
                          autocorrect: false,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Team Number",
                              hintStyle:
                                  TextStyle(fontFamily: "BraveEightyOne")),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                tbaTeamInfo = getTBATeamInfo(int.parse(value));
                              });
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                  future: tbaTeamInfo,
                                  builder: (context, snapshot) {
                                    String message =
                                        "Enter a valid team number";
                                    if (snapshot.hasData) {
                                      message = snapshot.data!.shortName ??
                                          snapshot.data!.longName;
                                      if (snapshot.data!.city != null) {
                                        message +=
                                            ": ${snapshot.data!.city ?? ""}";
                                      }
                                      if (snapshot.data!.stateProv != null) {
                                        message +=
                                            ", ${snapshot.data!.stateProv ?? ""}";
                                      }
                                      if (snapshot.data!.country != null) {
                                        message +=
                                            ", ${snapshot.data!.country ?? ""}";
                                      }
                                    } else if (snapshot.hasError) {
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                          Text(snapshot.error.toString())
                                        ],
                                      );
                                    } else {
                                      return const Text("");
                                    }
                                    return ClipRect(
                                      child: Flexible(
                                        child: Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: !snapshot.data!.validTeam
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onBackground),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SegmentedButton(
                              segments: const [
                                ButtonSegment(
                                    value: DrivetrainType.tank,
                                    label: Text("Tank"),
                                    icon: Icon(Icons.looks_one)),
                                ButtonSegment(
                                    value: DrivetrainType.swerve,
                                    label: Text("Swerve"),
                                    icon: Icon(Icons.looks_two)),
                                ButtonSegment(
                                    value: DrivetrainType.mecanum,
                                    label: Text("Mecanum"),
                                    icon: Icon(Icons.looks_3))
                              ],
                              selected: <DrivetrainType>{selectedDrivetrain},
                              onSelectionChanged:
                                  (Set<DrivetrainType> newSelection) {
                                setState(() {
                                  selectedDrivetrain = newSelection.first;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SegmentedButton(
                              segments: const [
                                ButtonSegment(
                                    value: 1,
                                    label: Text("Level 1"),
                                    icon: Icon(Icons.looks_one)),
                                ButtonSegment(
                                    value: 2,
                                    label: Text("Level 2"),
                                    icon: Icon(Icons.looks_two)),
                                ButtonSegment(
                                    value: 3,
                                    label: Text("Level 3"),
                                    icon: Icon(Icons.looks_3))
                              ],
                              selected: <int>{selectedLevel},
                              onSelectionChanged: (Set<int> newSelection) {
                                setState(() {
                                  selectedLevel = newSelection.first;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SegmentedButton(
                              multiSelectionEnabled: true,
                              emptySelectionAllowed: true,
                              segments: const [
                                ButtonSegment(
                                    value: ScoringTypes.cones,
                                    label: Text("Cones"),
                                    icon: Icon(Icons.looks_one)),
                                ButtonSegment(
                                    value: ScoringTypes.cubes,
                                    label: Text("Cubes"),
                                    icon: Icon(Icons.looks_two))
                              ],
                              selected: scoreableTypes,
                              onSelectionChanged:
                                  (Set<ScoringTypes> newSelection) {
                                setState(() {
                                  scoreableTypes = newSelection;
                                  scoreCones =
                                      newSelection.contains(ScoringTypes.cones);
                                  scoreCubes =
                                      newSelection.contains(ScoringTypes.cubes);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SegmentedButton(
                              emptySelectionAllowed: true,
                              multiSelectionEnabled: true,
                              segments: const [
                                ButtonSegment(
                                    value: AutonomousFunctions.balance,
                                    label: Text("Balance"),
                                    icon: Icon(Icons.looks_one)),
                                ButtonSegment(
                                    value: AutonomousFunctions.exitHome,
                                    label: Text("Exit Home"),
                                    icon: Icon(Icons.looks_two)),
                                ButtonSegment(
                                    value: AutonomousFunctions.score,
                                    label: Text("Score"),
                                    icon: Icon(Icons.looks_3))
                              ],
                              selected: autoSelected,
                              onSelectionChanged:
                                  (Set<AutonomousFunctions> newSelected) {
                                setState(() {
                                  autoSelected = newSelected;
                                  balanceAuto = newSelected
                                      .contains(AutonomousFunctions.balance);
                                  exitHome = newSelected
                                      .contains(AutonomousFunctions.exitHome);
                                  scoreAuto = newSelected
                                      .contains(AutonomousFunctions.score);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: commentsController,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Commments",
                  ),
                  minLines: 2,
                  maxLines: 50,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:robot_checklists/secrets.dart';

import '../globals.dart';

class PageLadderScouting extends StatefulWidget {
  const PageLadderScouting({super.key});

  @override
  State<PageLadderScouting> createState() => _PageLadderScoutingState();
}

class _PageLadderScoutingState extends State<PageLadderScouting> {
  final textController = TextEditingController();
  int currentNumber = 0;

  void updateTeamNumber() {
    setState(() {
      currentNumber = int.parse(textController.text);
      teamData = fetchOneTeamData();
    });
  }

  late Future<TeamData> teamData;
  late Future<List<PartialTeamData>> teamList;
  @override
  void initState() {
    super.initState();
    teamData = fetchOneTeamData();
    teamList = fetchTeamList();
  }

  Future<List<PartialTeamData>> fetchTeamList() async {
    String apiUrl = "$apiHome/teams/get/all";
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'X-Space-App-Key': detaAuthKey,
      'X-RCC-Telemetry-Uuid': await getUUID(),
    });
    final data = json.decode(response.body);
    List<PartialTeamData> teams = [];
    for (var team in data) {
      teams += [PartialTeamData.fromJSON(team)];
    }
    return teams;
  }

  Future<TeamData> fetchOneTeamData() async {
    String apiUrl = "$apiHome/teams/get/$currentNumber";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'X-Space-App-Key': detaAuthKey,
        'X-RCC-Telemetry-Uuid': await getUUID(),
      },
    );
    final data = json.decode(response.body);
    return TeamData.fromJSON(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Column(children: [
        FutureBuilder<TeamData>(
            future: teamData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TeamData data = snapshot.data!;
                if (data.number == currentNumber) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data.name,
                                  style: const TextStyle(
                                      fontFamily: "BraveEightyOne",
                                      fontSize: 30),
                                ),
                              ),
                              // const Spacer(),
                              Text(
                                currentNumber.toString().padLeft(4, '0'),
                                style: const TextStyle(
                                    fontFamily: "OrionPax", fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Expanded(
                                  child: Text(() {
                                    var message = "";
                                    if (data.city != null) {
                                      message += data.city!;
                                    }
                                    if (data.state != null) {
                                      message += ", ${data.state!}";
                                    }
                                    if (data.country != null) {
                                      message += ", ${data.country!}";
                                    }
                                    return message;
                                  }(), style: const TextStyle()),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Text("Scoring Type:"),
                              const Spacer(),
                              ScoreTypeCard(data.scoreCones, data.scoreCubes),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Level:"),
                              const Spacer(),
                              LevelCards(data.highestLevel),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Drivetrain:"),
                              const Spacer(),
                              DrivetrainCards(data.drivetrainType)
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Autonomous:"),
                              const Spacer(),
                              AutonomousCards(
                                data.balanceAuto,
                                data.exitHomeAuto,
                                data.scoreAuto,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Loading..."),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: () {
                        if (snapshot.error
                            .toString()
                            .toLowerCase()
                            .contains("type")) {
                          return [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Text("Select or add a team"),
                              ],
                            )
                          ];
                        } else {
                          return [
                            Text(snapshot.error.toString()),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                ),
                              ],
                            ),
                          ];
                        }
                      }(),
                    ),
                  ),
                );
              }
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Loading..."),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        Expanded(
          child: FutureBuilder<List<PartialTeamData>>(
              future: teamList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Available Teams",
                                style: TextStyle(
                                    fontFamily: "BraveEightyOne", fontSize: 30),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      teamList = fetchTeamList();
                                    });
                                  },
                                  icon: const Icon(Icons.refresh))
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 120,
                                  childAspectRatio: 3 / 2,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          currentNumber =
                                              snapshot.data![index].number;
                                          teamData = fetchOneTeamData();
                                        });
                                      },
                                      child: Text(
                                        snapshot.data![index].number.toString(),
                                        style: const TextStyle(
                                            fontFamily: "OrionPax"),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.error.toString()),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Loading..."),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const AddTeamDialog();
              },
            );
          },
          label: const Text("Add New"),
          icon: const Icon(Icons.add_box_outlined)),
    );
  }
}

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
                            "comments": "blah blah blah",
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
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      style:
                          const TextStyle(fontFamily: "OrionPax", fontSize: 30),
                      autocorrect: false,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Team Number",
                          hintStyle: TextStyle(fontFamily: "BraveEightyOne")),
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
                                String message = "Enter a valid team number";
                                if (snapshot.hasData) {
                                  message = snapshot.data!.shortName ??
                                      snapshot.data!.longName;
                                  if (snapshot.data!.city != null) {
                                    message += ": ${snapshot.data!.city ?? ""}";
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
                          onSelectionChanged: (Set<ScoringTypes> newSelection) {
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelCards extends StatelessWidget {
  const LevelCards(
    this.highestLevel, {
    super.key,
  });

  final int highestLevel;

  @override
  Widget build(BuildContext context) {
    var unselectedColor = Theme.of(context).disabledColor;
    var onUnselectedColor = Theme.of(context).disabledColor;
    var selectedColor = Theme.of(context).colorScheme.tertiaryContainer;
    var onSelectedColor = Theme.of(context).colorScheme.onTertiaryContainer;

    return Row(
      children: [
        Card(
          color: highestLevel > 0 ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Level 1",
              style: TextStyle(
                  color:
                      highestLevel > 0 ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: highestLevel > 1 ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Level 2",
              style: TextStyle(
                  color:
                      highestLevel > 1 ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: highestLevel > 2 ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Level 3",
              style: TextStyle(
                  color:
                      highestLevel > 2 ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
      ],
    );
  }
}

class ScoreTypeCard extends StatelessWidget {
  const ScoreTypeCard(
    this.cones,
    this.cubes, {
    super.key,
  });

  final bool cones;
  final bool cubes;

  @override
  Widget build(BuildContext context) {
    var unselectedColor = Theme.of(context).disabledColor;
    var onUnselectedColor = Theme.of(context).disabledColor;
    var selectedColor = Theme.of(context).colorScheme.tertiaryContainer;
    var onSelectedColor = Theme.of(context).colorScheme.onTertiaryContainer;
    return Row(
      children: [
        Card(
          color: cones ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cones",
              style:
                  TextStyle(color: cones ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: cubes ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cubes",
              style:
                  TextStyle(color: cubes ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
      ],
    );
  }
}

class AutonomousCards extends StatelessWidget {
  const AutonomousCards(
    this.balanceAuto,
    this.exitHomeAuto,
    this.scoreAuto, {
    super.key,
  });

  final bool balanceAuto;
  final bool exitHomeAuto;
  final bool scoreAuto;

  @override
  Widget build(BuildContext context) {
    var unselectedColor = Theme.of(context).disabledColor;
    var onUnselectedColor = Theme.of(context).disabledColor;
    var selectedColor = Theme.of(context).colorScheme.tertiaryContainer;
    var onSelectedColor = Theme.of(context).colorScheme.onTertiaryContainer;
    return Row(
      children: [
        Card(
          color: balanceAuto ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Balance",
              style: TextStyle(
                  color: balanceAuto ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: exitHomeAuto ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Exit Home",
              style: TextStyle(
                  color: exitHomeAuto ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: scoreAuto ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Score",
              style: TextStyle(
                  color: scoreAuto ? onSelectedColor : onUnselectedColor),
            ),
          ),
        ),
      ],
    );
  }
}

class DrivetrainCards extends StatelessWidget {
  const DrivetrainCards(
    this.drivetrainType, {
    super.key,
  });

  final DrivetrainType drivetrainType;

  @override
  Widget build(BuildContext context) {
    var unselectedColor = Theme.of(context).disabledColor;
    var onUnselectedColor = Theme.of(context).disabledColor;
    var selectedColor = Theme.of(context).colorScheme.tertiaryContainer;
    var onSelectedColor = Theme.of(context).colorScheme.onTertiaryContainer;
    return Row(
      children: [
        Card(
          color: drivetrainType == DrivetrainType.tank
              ? selectedColor
              : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tank",
              style: TextStyle(
                  color: drivetrainType == DrivetrainType.tank
                      ? onSelectedColor
                      : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: drivetrainType == DrivetrainType.swerve
              ? selectedColor
              : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Swerve",
              style: TextStyle(
                  color: drivetrainType == DrivetrainType.swerve
                      ? onSelectedColor
                      : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: drivetrainType == DrivetrainType.mecanum
              ? selectedColor
              : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Mecanum",
              style: TextStyle(
                  color: drivetrainType == DrivetrainType.mecanum
                      ? onSelectedColor
                      : onUnselectedColor),
            ),
          ),
        )
      ],
    );
  }
}

class TBATeam {
  final int number;
  final String longName;
  final String? shortName;
  final String? city;
  final String? country;
  final String? stateProv;
  final bool validTeam;
  TBATeam({
    required this.number,
    required this.longName,
    this.shortName,
    this.city,
    this.stateProv,
    this.country,
    this.validTeam = true,
  });
  factory TBATeam.fromJSON(var json) {
    return TBATeam(
      number: json['team_number'],
      longName: json['name'],
      shortName: json['nickname'],
      city: json['city'],
      stateProv: json['state_prov'],
      country: json['country'],
    );
  }
}

enum DrivetrainType { tank, swerve, mecanum, other }

enum AutonomousFunctions { balance, exitHome, score }

enum ScoringTypes { cones, cubes }

class TeamData {
  final int number;
  final String name;
  final DrivetrainType drivetrainType;
  final int highestLevel;
  final bool balanceAuto;
  final bool exitHomeAuto;
  final bool balanceTeleop;
  final bool scoreAuto;
  final bool scoreCones;
  final bool scoreCubes;
  final String? city;
  final String? state;
  final String? country;
  TeamData(
      {required this.number,
      required this.name,
      required this.drivetrainType,
      required this.highestLevel,
      required this.balanceAuto,
      required this.exitHomeAuto,
      required this.balanceTeleop,
      required this.scoreAuto,
      required this.scoreCones,
      required this.scoreCubes,
      this.city,
      this.state,
      this.country});
  factory TeamData.fromJSON(var json) {
    return TeamData(
        number: json['team_number'],
        name: json['team_name'],
        // drivetrainType: json['drivetrain_type'],
        drivetrainType: () {
          switch (json['drivetrain_type']) {
            case 'tank':
              return DrivetrainType.tank;
            case 'swerve':
              return DrivetrainType.swerve;
            case 'mecanum':
              return DrivetrainType.mecanum;
            default:
              return DrivetrainType.other;
          }
        }(),
        highestLevel: json['highest_level'],
        balanceAuto: json['balance_auto'],
        exitHomeAuto: json['exit_home_auto'],
        balanceTeleop: json['balance_teleop'],
        scoreAuto: json["score_auto"],
        scoreCones: json["score_cones"],
        scoreCubes: json["score_cubes"],
        city: json['city'],
        state: json["state"],
        country: json['country']);
  }
}

class PartialTeamData {
  final int number;
  final String name;

  PartialTeamData({
    required this.number,
    required this.name,
  });
  factory PartialTeamData.fromJSON(var json) {
    return PartialTeamData(
      number: json['team_number'],
      name: json['team_name'],
    );
  }
}

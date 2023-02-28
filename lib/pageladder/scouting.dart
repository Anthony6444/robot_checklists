import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderScouting extends StatefulWidget {
  const PageLadderScouting({super.key});

  @override
  State<PageLadderScouting> createState() => _PageLadderScoutingState();
}

class _PageLadderScoutingState extends State<PageLadderScouting> {
  final textController = TextEditingController();
  int currentNumber = 4215;

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
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    List<PartialTeamData> teams = [];
    for (var team in data) {
      teams += [PartialTeamData.fromJSON(team)];
    }
    return teams;
  }

  Future<TeamData> fetchOneTeamData() async {
    String apiUrl = "$apiHome/teams/get/$currentNumber";
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    return TeamData.fromJSON(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<TeamData>(
            future: teamData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TeamData data = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data.name,
                              style: const TextStyle(
                                  fontFamily: "BraveEightyOne", fontSize: 30),
                            ),
                            const Spacer(),
                            Text(
                              currentNumber.toString().padLeft(4, '0'),
                              style: const TextStyle(
                                  fontFamily: "OrionPax", fontSize: 20),
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
              } else if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("Error: ${snapshot.error}"),
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
                              Text(
                                "Available Teams",
                                style: const TextStyle(
                                    fontFamily: "BraveEightyOne", fontSize: 30),
                              ),
                            ],
                          ),
                          Divider(),
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
                      padding: const EdgeInsets.all(8),
                      child: Text("Error: ${snapshot.error}"),
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
        Card(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_box_outlined),
                label: const Text(
                  "Add New",
                  style: TextStyle(fontFamily: "BraveEightyOne", fontSize: 16),
                ),
              )
            ],
          ),
        ))
      ],
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

  final String drivetrainType;

  @override
  Widget build(BuildContext context) {
    var unselectedColor = Theme.of(context).disabledColor;
    var onUnselectedColor = Theme.of(context).disabledColor;
    var selectedColor = Theme.of(context).colorScheme.tertiaryContainer;
    var onSelectedColor = Theme.of(context).colorScheme.onTertiaryContainer;
    return Row(
      children: [
        Card(
          color: drivetrainType == 'tank' ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tank",
              style: TextStyle(
                  color: drivetrainType == 'tank'
                      ? onSelectedColor
                      : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: drivetrainType == 'swerve' ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Swerve",
              style: TextStyle(
                  color: drivetrainType == 'swerve'
                      ? onSelectedColor
                      : onUnselectedColor),
            ),
          ),
        ),
        Card(
          color: drivetrainType == 'mecanum' ? selectedColor : unselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Mecanum",
              style: TextStyle(
                  color: drivetrainType == 'mecanum'
                      ? onSelectedColor
                      : onUnselectedColor),
            ),
          ),
        )
      ],
    );
  }
}

class TeamData {
  final int number;
  final String name;
  final String drivetrainType;
  final int highestLevel;
  final bool balanceAuto;
  final bool exitHomeAuto;
  final bool balanceTeleop;
  final bool scoreAuto;
  final bool scoreCones;
  final bool scoreCubes;
  TeamData({
    required this.number,
    required this.name,
    required this.drivetrainType,
    required this.highestLevel,
    required this.balanceAuto,
    required this.exitHomeAuto,
    required this.balanceTeleop,
    required this.scoreAuto,
    required this.scoreCones,
    required this.scoreCubes,
  });
  factory TeamData.fromJSON(var json) {
    return TeamData(
      number: json['team_number'],
      name: json['team_name'],
      drivetrainType: json['drivetrain_type'],
      highestLevel: json['highest_level'],
      balanceAuto: json['balance_auto'],
      exitHomeAuto: json['exit_home_auto'],
      balanceTeleop: json['balance_teleop'],
      scoreAuto: json["score_auto"],
      scoreCones: json["score_cones"],
      scoreCubes: json["score_cubes"],
    );
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

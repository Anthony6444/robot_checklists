import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:robot_checklists/pageladder/scouting/scouting_add_team.dart';
import 'package:robot_checklists/secrets.dart';

import '../../globals.dart';

class PageLadderScouting extends StatefulWidget {
  const PageLadderScouting({super.key});

  @override
  State<PageLadderScouting> createState() => _PageLadderScoutingState();
}

class _PageLadderScoutingState extends State<PageLadderScouting> {
  int currentNumber = 0;

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
                              ),
                            ],
                          ),
                          const Divider(),
                          () {
                            List<Widget> wList = <Widget>[];
                            if (data.comments != null) {
                              wList.add(
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Comments"),
                                              content: Text(
                                                data.comments ?? "",
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Close"))
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      data.comments ?? "",
                                      maxLines: 4,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                              );
                            }
                            wList.add(const Spacer());
                            wList.add(
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Coming Soon"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Ok"))
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.edit),
                                            label: const Text("Edit")),
                                        TextButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                            label: const Text("Add Match"))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                            return Flex(
                              direction: Axis.horizontal,
                              children: wList,
                            );
                          }(),
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

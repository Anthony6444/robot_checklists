import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderStats extends StatefulWidget {
  const PageLadderStats({super.key});

  @override
  PageLadderStatsState createState() => PageLadderStatsState();
}

class PageLadderStatsState extends State<PageLadderStats> {
  void runOnce(AppState appState) {
    if (appState.statsDataLoaded) return;
    appState.loadStatsData();
    appState.statsDataLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    runOnce(appState);
    return Center(
      child: Column(children: [
        Expanded(
          child: ListView.builder(
              itemCount: appState.statsData.length,
              itemBuilder: (context, i) {
                return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: () {
                          List<Widget> returnables = <Widget>[
                            Row(
                              children: [
                                Text(appState.statsData[i].name.toUpperCase(),
                                    style: const TextStyle(
                                        fontFamily: "BraveEightyOne",
                                        fontSize: 30)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(appState.statsData[i].desc ?? ""),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: appState.statsData[i].imageLocation == null
                                  ? const Placeholder(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text("No image specified"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        appState.statsData[i].imageLocation!,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: (Placeholder(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Text(
                                                "No image named ${appState.statsData[i].imageLocation!}",
                                              ),
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                            ),
                          ];

                          for (String listItem in appState.statsData[i].list) {
                            returnables.add(Row(
                              children: [
                                const BulletPoint(),
                                Text(listItem),
                              ],
                            ));
                          }
                          return returnables;
                        }(),
                      )),
                );
              }),
        )
      ]),
    );
  }
}

class BulletPoint extends StatelessWidget {
  const BulletPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.bodyMedium!.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class StatsField {
  final String name;
  final String? desc;
  final String? imageLocation;
  final List<dynamic> list;
  StatsField({
    required this.name,
    this.desc,
    this.imageLocation,
    required this.list,
  });
  factory StatsField.fromYaml(var yaml) {
    print(yaml);
    return StatsField(
      name: yaml['title'],
      desc: yaml['desc'],
      imageLocation: yaml['image'],
      list: yaml['list'].toList(),
    );
  }
}

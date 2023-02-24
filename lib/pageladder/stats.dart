import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderStats extends StatefulWidget {
  @override
  PageLadderStatsState createState() => PageLadderStatsState();
}

class PageLadderStatsState extends State<PageLadderStats> {
  void runOnce(AppState appState) {
    if (appState.statsDataLoaded) return;
    appState.loadStatsData();
    appState.pitsDataLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    runOnce(appState);
    return Center(
      child: Column(children: [
        Expanded(
          child: Container(
            child: ListView.builder(itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(index.toString()),
                ),
              );
            }),
          ),
        )
      ]),
    );
  }
}

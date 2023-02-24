import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderHome extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: "BraveEightyOne", fontSize: 40);
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Trinity".toUpperCase(),
                  style: style,
                ),
                Image.asset(
                  "assets/logo.png",
                  scale: 0.2,
                ),
                Text(
                  "Robotics".toUpperCase(),
                  style: style,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderPits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Center(
      child: Text("Pits"),
    );
  }
}

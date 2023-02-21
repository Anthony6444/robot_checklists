import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    // TODO: implement build
    return Center(
      child: Text("Network"),
    );
  }
}

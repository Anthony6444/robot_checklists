import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsetsDirectional.all(10),
          child: Text("Fancy Homepage"),
        ),
      ),
    );
  }
}

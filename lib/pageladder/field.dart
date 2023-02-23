import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';
import 'package:vector_math/vector_math.dart';

class PageLadderField extends StatelessWidget {
  const PageLadderField({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Transform.rotate(
      angle: radians(MediaQuery.of(context).size.aspectRatio > 1 ? 90 : 0),
      child: LayoutBuilder(builder: (context, constraints) {
        return Image.asset("assets/field_diagram_cropped.png");
      }),
    );
  }
}

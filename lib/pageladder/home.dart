import 'package:flutter/material.dart';

class PageLadderHome extends StatelessWidget {
  const PageLadderHome({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        const TextStyle(fontFamily: "BraveEightyOne", fontSize: 40);
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
                  "assets/logo_sized.png",
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

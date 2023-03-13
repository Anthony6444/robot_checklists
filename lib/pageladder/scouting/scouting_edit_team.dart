import 'package:flutter/material.dart';

class EditTeamDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return AlertDialog(
      title: const Text("Coming Soon"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );
  }
}

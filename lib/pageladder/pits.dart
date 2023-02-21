import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';

class PageLadderPits extends StatefulWidget {
  const PageLadderPits({super.key});

  @override
  PageLadderPitsState createState() => PageLadderPitsState();
}

class PageLadderPitsState extends State<PageLadderPits> {
  List<ChecklistItem> _items = <ChecklistItem>[
    ChecklistItem(name: "Thing One", checked: false),
    ChecklistItem(name: "two", subtext: "More information", checked: true),
    ChecklistItem(
        name: "Another thing", subtext: "Detail detail detail", checked: false)
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        new Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("Pits Menu")),
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                color: _items[index].checked
                    ? Theme.of(context).disabledColor
                    : null,
                child: ListTile(
                  onTap: () {
                    _items[index].toggleChecked();
                    setState(() {});
                  },
                  leading: CircleAvatar(
                      backgroundColor: _items[index].checked
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      child: _items[index].checked
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            )
                          : Text(
                              _items[index].name[0].toUpperCase(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            )),
                  title: Text(_items[index].name),
                  subtitle: Text(_items[index].subtext ?? ""),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChecklistCard extends StatelessWidget {
  const ChecklistCard({
    super.key,
    required List<ChecklistItem> items,
    required int index,
  })  : _items = items,
        _index = index;

  final List<ChecklistItem> _items;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _items[_index].checked ? Theme.of(context).disabledColor : null,
      child: ListTile(
        onTap: () {
          _items[_index].toggleChecked();
        },
        leading: CircleAvatar(
            backgroundColor: _items[_index].checked
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.tertiaryContainer,
            child: _items[_index].checked
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  )
                : Text(
                    _items[_index].name[0],
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  )),
        title: Text(_items[_index].name),
        subtitle: Text(_items[_index].subtext ?? ""),
      ),
    );
  }
}

class ChecklistItem {
  final String name;
  final String? subtext;
  bool checked;
  ChecklistItem({
    required this.name,
    this.subtext,
    required this.checked,
  });
  void toggleChecked() {
    checked = !checked;
  }
}

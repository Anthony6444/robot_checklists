import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/main.dart';
import 'package:yaml/yaml.dart';

class PageLadderPits extends StatefulWidget {
  const PageLadderPits({super.key});

  @override
  PageLadderPitsState createState() => PageLadderPitsState();
}

class PageLadderPitsState extends State<PageLadderPits> {
  // late List<ChecklistItem> _preflightItems;
  late List<Map<String, dynamic>> pitsData;
  bool allComplete() {
    for (var i in _range(0, pitsData.length)) {
      for (ChecklistItem v in pitsData[i]['list']) {
        if (!v.checked) {
          return false;
        }
      }
    }
    return true;
  }

  List _range(int from, int to) => List.generate(to - from, (i) => i + from);

  void resetList() {
    for (var i in _range(0, pitsData.length)) {
      for (var v in _range(0, pitsData[i]['list'].length)) {
        if (pitsData[i]['list'][v].checked) {
          pitsData[i]['list'][v].checked = !pitsData[i]['list'][v].checked;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    pitsData = appState.pitsData;
    // _preflightItems = appState.preFlightItems;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text("Pits Menu".toUpperCase(),
              style: const TextStyle(fontFamily: "BraveEightyOne")),
        ),
        Expanded(
          child: Container(
            child: allComplete()
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            "Done!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: "BraveEightyOne",
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          resetList();
                          appState.loadYamlData();
                          setState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.restore),
                            Text(" Reset"),
                          ],
                        ),
                      )
                    ],
                  ))
                : ListView.builder(
                    itemCount: pitsData.length,
                    itemBuilder: (BuildContext context, i) {
                      return ExpansionTile(
                          title: Text(pitsData[i]['name']),
                          children: () {
                            List<Card> returnables = [];
                            for (var j
                                in _range(0, pitsData[i]['list'].length)) {
                              returnables.add(
                                Card(
                                  color: pitsData[i]['list'][j].checked
                                      ? Theme.of(context).disabledColor
                                      : null,
                                  child: ListTile(
                                    onTap: () {
                                      pitsData[i]['list'][j].toggleChecked();
                                      setState(() {});
                                    },
                                    leading: CircleAvatar(
                                        backgroundColor:
                                            pitsData[i]['list'][j].checked
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .tertiaryContainer,
                                        child: pitsData[i]['list'][j].checked
                                            ? Icon(
                                                Icons.check,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                              )
                                            : Text(
                                                pitsData[i]['list'][j]
                                                    .name[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer),
                                              )),
                                    title: Text(pitsData[i]['list'][j].name),
                                    subtitle:
                                        Text(pitsData[i]['list'][j].desc ?? ""),
                                  ),
                                ),
                              );
                            }
                            return returnables;
                          }());
                    },
                  ),
          ),
        )
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
        subtitle: Text(_items[_index].desc ?? ""),
      ),
    );
  }
}

class ChecklistItem {
  final String name;
  final String? desc;
  bool checked;
  ChecklistItem({
    required this.name,
    this.desc,
    this.checked = false,
  });
  void toggleChecked() {
    checked = !checked;
  }

  factory ChecklistItem.fromYaml(var stringOrDescriptionPair) {
    if (stringOrDescriptionPair.runtimeType == YamlList) {
      return ChecklistItem(
          name: stringOrDescriptionPair[0], desc: stringOrDescriptionPair[1]);
    } else {
      return ChecklistItem(name: stringOrDescriptionPair);
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/pageladder/drivers.dart';
import 'package:robot_checklists/pageladder/field.dart';
import 'package:robot_checklists/pageladder/home.dart';
import 'package:robot_checklists/pageladder/network.dart';
import 'package:robot_checklists/pageladder/pits.dart';
import 'package:robot_checklists/pageladder/scouting.dart';
import 'package:robot_checklists/pageladder/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

String apiHome = "http://192.168.1.232";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void initTelemetry() async {
    Map<String, String> telemetryMap = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstRun = prefs.getBool("isFirstRun") ?? true;
    print(firstRun);
    String newUUID = const Uuid().v4();
    if (firstRun) {
      prefs.setString("uuid", newUUID);
      prefs.setBool("isFirstRun", false);
    }
    telemetryMap['uuid'] = prefs.getString("uuid") ?? "00001-0000-0000-0000";
    telemetryMap['platform'] = Platform.operatingSystem;
    telemetryMap['version'] = Platform.operatingSystemVersion;
    telemetryMap['locale'] = Platform.localeName;
    print(telemetryMap.toString());
    http.post(
      Uri.parse("$apiHome/telemetry/ping"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(telemetryMap),
    );
  }

  @override
  Widget build(BuildContext context) {
    initTelemetry();
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme ?? const ColorScheme.light(),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? const ColorScheme.dark(),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      );
    });
  }
}

class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> pitsData = [];
  bool pitsDataLoaded = false;
  Future<void> loadPitsData() async {
    List range(int from, int to) => List.generate(to - from, (i) => i + from);
    final yamlString = await rootBundle.loadString("assets/pits.yaml");
    final List<dynamic> parsedYaml = loadYaml(yamlString).toList();
    for (var i in range(0, parsedYaml.length)) {
      pitsData.add({});
      pitsData[i]['name'] = parsedYaml[i]['name'];
      pitsData[i]['desc'] = parsedYaml[i]['desc'];
      pitsData[i]['list'] = [];
      for (var j in parsedYaml[i]['list']) {
        if (j == null) {
          throw AssertionError(
              "List '${pitsData[i]['name']}' should not be empty or have empty items");
        } else {
          pitsData[i]['list'] += [ChecklistItem.fromYaml(j)];
        }
      }
    }
    notifyListeners();
  }

  List<StatsField> statsData = [];
  bool statsDataLoaded = false;
  Future<void> loadStatsData() async {
    final yamlString = await rootBundle.loadString("assets/stats.yaml");
    final List<dynamic> parsedYaml = loadYaml(yamlString).toList();
    for (var i in parsedYaml) {
      statsData.add(StatsField.fromYaml(i));
    }
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const PageLadderHome();
        break;
      case 1:
        page = const PageLadderPits();
        break;
      case 2:
        page = const PageLadderScouting();
        break;
      case 3:
        page = const PageLadderDrivers();
        break;
      case 4:
        page = const PageLadderNetwork();
        break;
      case 5:
        page = const PageLadderStats();
        break;
      case 6:
        page = const PageLadderField();
        break;
      default:
        page = const Placeholder();
    }
    return LayoutBuilder(builder: (context, constraints) {
      TextStyle titleTextStyle = TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontFamily: "BraveEightyOne");
      return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text(
              "Trinity Robotics".toUpperCase(),
              style: titleTextStyle,
            ),
            const Spacer(),
            Text(
              "FRC 4215",
              style: titleTextStyle,
            )
          ],
        )),
        bottomNavigationBar: constraints.maxWidth <= 600
            ? NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings),
                      label: "Pits",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_add),
                      label: "Scouting",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.gamepad),
                      label: "Drivers",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.account_tree),
                      label: "Network",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.add_chart),
                      label: "Stats",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.grid_on),
                      label: "Field",
                    )
                  ])
            : null,
        body: Row(children: [
          SafeArea(
              child: constraints.maxWidth > 600
                  ? NavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      backgroundColor:
                          Theme.of(context).bottomAppBarTheme.color,
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text("Home"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings),
                          label: Text("Pits"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_add),
                          label: Text("Scouting"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.gamepad),
                          label: Text("Drivers"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.account_tree),
                          label: Text("Network"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.add_chart),
                          label: Text("Stats"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.grid_on),
                          label: Text("Field"),
                        ),
                      ],
                    )
                  : Container()),
          Expanded(
            child: SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ),
        ]),
      );
    });
  }
}

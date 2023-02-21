import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/pageladder/drivers.dart';
import 'package:robot_checklists/pageladder/field.dart';
import 'package:robot_checklists/pageladder/home.dart';
import 'package:robot_checklists/pageladder/network.dart';
import 'package:robot_checklists/pageladder/pits.dart';
import 'package:robot_checklists/pageladder/scouting.dart';
import 'package:robot_checklists/pageladder/stats.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme ?? ColorScheme.light(),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? ColorScheme.dark(),
            useMaterial3: true,
          ),
          home: HomePage(),
        ),
      );
    });
  }
}

class AppState extends ChangeNotifier {}

class HomePage extends StatefulWidget {
  HomePage({super.key});

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
        page = PageLadderHome();
        break;
      case 1:
        page = PageLadderPits();
        break;
      case 2:
        page = PageLadderScouting();
        break;
      case 3:
        page = PageLadderDrivers();
        break;
      case 4:
        page = PageLadderNetwork();
        break;
      case 5:
        page = PageLadderStats();
        break;
      case 6:
        page = PageLadderField();
        break;
      default:
        page = const Placeholder();
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
          "Robot Scouting",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
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
                      extended: constraints.maxWidth > 800,
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

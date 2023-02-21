import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_checklists/pageladder/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
        home: HomePage(),
      ),
    );
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
      default:
        page = const Placeholder();
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
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
            ]),
        body: Row(children: [
          SafeArea(
              child: NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
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
          )),
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

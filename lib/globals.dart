library robot_checklists.globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

String apiHome = "https://rcsapi-1-q7026519.deta.app";
String tbaHome = "https://www.thebluealliance.com/api/v3";

Future<String> getUUID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstRun = prefs.getBool("isFirstRun") ?? true;
  String newUUID = const Uuid().v4();
  if (firstRun) {
    prefs.setString("uuid", newUUID);
    prefs.setBool("isFirstRun", false);
  }
  return prefs.getString("uuid") ?? newUUID;
}

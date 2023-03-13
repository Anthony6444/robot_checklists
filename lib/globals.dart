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

class TBATeam {
  final int number;
  final String longName;
  final String? shortName;
  final String? city;
  final String? country;
  final String? stateProv;
  final bool validTeam;
  TBATeam({
    required this.number,
    required this.longName,
    this.shortName,
    this.city,
    this.stateProv,
    this.country,
    this.validTeam = true,
  });
  factory TBATeam.fromJSON(var json) {
    return TBATeam(
      number: json['team_number'],
      longName: json['name'],
      shortName: json['nickname'],
      city: json['city'],
      stateProv: json['state_prov'],
      country: json['country'],
    );
  }
}

enum DrivetrainType { tank, swerve, mecanum, other }

enum AutonomousFunctions { balance, exitHome, score }

enum ScoringTypes { cones, cubes }

class TeamData {
  final int number;
  final String name;
  final DrivetrainType drivetrainType;
  final int highestLevel;
  final bool balanceAuto;
  final bool exitHomeAuto;
  final bool balanceTeleop;
  final bool scoreAuto;
  final bool scoreCones;
  final bool scoreCubes;
  final String? city;
  final String? state;
  final String? country;
  final String? comments;
  TeamData(
      {required this.number,
      required this.name,
      required this.drivetrainType,
      required this.highestLevel,
      required this.balanceAuto,
      required this.exitHomeAuto,
      required this.balanceTeleop,
      required this.scoreAuto,
      required this.scoreCones,
      required this.scoreCubes,
      this.city,
      this.state,
      this.country,
      required this.comments});
  factory TeamData.fromJSON(var json) {
    return TeamData(
        number: json['team_number'],
        name: json['team_name'],
        // drivetrainType: json['drivetrain_type'],
        drivetrainType: () {
          switch (json['drivetrain_type']) {
            case 'tank':
              return DrivetrainType.tank;
            case 'swerve':
              return DrivetrainType.swerve;
            case 'mecanum':
              return DrivetrainType.mecanum;
            default:
              return DrivetrainType.other;
          }
        }(),
        highestLevel: json['highest_level'],
        balanceAuto: json['balance_auto'],
        exitHomeAuto: json['exit_home_auto'],
        balanceTeleop: json['balance_teleop'],
        scoreAuto: json["score_auto"],
        scoreCones: json["score_cones"],
        scoreCubes: json["score_cubes"],
        city: json['city'],
        state: json["state"],
        country: json['country'],
        comments: json['comments']);
  }
}

class PartialTeamData {
  final int number;
  final String name;

  PartialTeamData({
    required this.number,
    required this.name,
  });
  factory PartialTeamData.fromJSON(var json) {
    return PartialTeamData(
      number: json['team_number'],
      name: json['team_name'],
    );
  }
}

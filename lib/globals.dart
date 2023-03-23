library rcs_scouting.globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

String apiHome = "https://rcsapi.anthony6444.com";
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

// ignore: constant_identifier_names
enum Scale { LOW, MID, HIGH }

class IndividualTeamMatch {
  final int teamNumber;
  final int matchNumber;

  // Auto
  final int autoBottom;
  final int autoMiddle;
  final int autoTop;

  // Teleop
  final int teleBottom;
  final int teleMiddle;
  final int teleTop;

  // Charge station
  final bool parked;
  final bool docked;

  // cycles
  final int cycles;
  final int failedCycles;

  // Teamwork
  final Scale allianceCooperation;
  final Scale moveQuickly;
  final Scale grabItemsWell;

  // Match
  final int totalPointsRobot;
  final int totalPointsAlliance;
  final bool win;
  final int winMargin;

  final String notes;
  IndividualTeamMatch({
    required this.teamNumber,
    required this.matchNumber,
    required this.autoBottom,
    required this.autoMiddle,
    required this.autoTop,
    required this.teleBottom,
    required this.teleMiddle,
    required this.teleTop,
    required this.parked,
    required this.docked,
    required this.cycles,
    required this.failedCycles,
    required this.allianceCooperation,
    required this.moveQuickly,
    required this.grabItemsWell,
    required this.totalPointsRobot,
    required this.totalPointsAlliance,
    required this.win,
    required this.winMargin,
    required this.notes,
  });
  factory IndividualTeamMatch.friomJson(json) {
    toEnum(i) {
      if (i == 1) return Scale.LOW;
      if (i == 2) return Scale.MID;
      if (i == 3) return Scale.HIGH;
      return Scale.LOW;
    }

    return IndividualTeamMatch(
        teamNumber: json["team_number"],
        matchNumber: json["match_number"],
        autoBottom: json["auto_bottom"],
        autoMiddle: json["auto_middle"],
        autoTop: json["auto_top"],
        teleBottom: json["tele_bottom"],
        teleMiddle: json["tele_middle"],
        teleTop: json["tele_top"],
        parked: json["parked"],
        docked: json["docked"],
        cycles: json["cycles"],
        failedCycles: json["failed_cycles"],
        allianceCooperation: toEnum(json["alliance_cooperation"]),
        moveQuickly: toEnum(json["move_quickly"]),
        grabItemsWell: toEnum(json["grab_items_well"]),
        totalPointsRobot: json["total_points_robot"],
        totalPointsAlliance: json["total_points_alliance"],
        win: json["win"],
        winMargin: json["win_margin"],
        notes: json["notes"]);
  }
}

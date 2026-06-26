import 'role.dart';

class ScenarioRole {
  final String roleId;
  int count;

  ScenarioRole({required this.roleId, this.count = 1});

  Map<String, dynamic> toJson() => {'roleId': roleId, 'count': count};
  factory ScenarioRole.fromJson(Map<String, dynamic> json) =>
      ScenarioRole(roleId: json['roleId'], count: json['count'] ?? 1);
}

class Scenario {
  final String id;
  String name;
  String description;
  List<ScenarioRole> roles;
  DateTime createdAt;

  Scenario({
    required this.id,
    required this.name,
    this.description = '',
    required this.roles,
    required this.createdAt,
  });

  int get totalPlayers => roles.fold(0, (sum, r) => sum + r.count);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'roles': roles.map((r) => r.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Scenario.fromJson(Map<String, dynamic> json) => Scenario(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        roles: (json['roles'] as List)
            .map((r) => ScenarioRole.fromJson(r))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
      );
}

enum PlayerStatus { alive, eliminated, silenced }

class Player {
  final String id;
  String name;
  Role? role;
  PlayerStatus status;
  bool roleRevealed;
  int voteCount;

  Player({
    required this.id,
    required this.name,
    this.role,
    this.status = PlayerStatus.alive,
    this.roleRevealed = false,
    this.voteCount = 0,
  });
}

class GameSession {
  final String id;
  final Scenario scenario;
  List<Player> players;
  int currentDay;
  bool isNight;
  bool isActive;
  DateTime startedAt;
  List<String> gameLog;

  GameSession({
    required this.id,
    required this.scenario,
    required this.players,
    this.currentDay = 1,
    this.isNight = true,
    this.isActive = true,
    required this.startedAt,
    List<String>? gameLog,
  }) : gameLog = gameLog ?? [];

  List<Player> get alivePlayers =>
      players.where((p) => p.status == PlayerStatus.alive).toList();

  int get aliveMafia => alivePlayers
      .where((p) => p.role?.team == RoleTeam.mafia)
      .length;

  int get aliveCitizens => alivePlayers
      .where((p) => p.role?.team == RoleTeam.citizen)
      .length;
}

import 'package:flutter/material.dart';

enum RoleTeam { mafia, citizen, independent }

enum RoleType { normal, special }

class Role {
  final String id;
  final String name;
  final String description;
  final String ability;
  final RoleTeam team;
  final RoleType type;
  final String emoji;
  int count;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.ability,
    required this.team,
    this.type = RoleType.normal,
    required this.emoji,
    this.count = 1,
  });

  Color get teamColor {
    switch (team) {
      case RoleTeam.mafia:
        return const Color(0xFFCC2222);
      case RoleTeam.citizen:
        return const Color(0xFF2D6A4F);
      case RoleTeam.independent:
        return const Color(0xFFB8860B);
    }
  }

  String get teamName {
    switch (team) {
      case RoleTeam.mafia:
        return 'مافیا';
      case RoleTeam.citizen:
        return 'شهروند';
      case RoleTeam.independent:
        return 'مستقل';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'ability': ability,
        'team': team.index,
        'type': type.index,
        'emoji': emoji,
        'count': count,
      };

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        ability: json['ability'],
        team: RoleTeam.values[json['team']],
        type: RoleType.values[json['type']],
        emoji: json['emoji'],
        count: json['count'] ?? 1,
      );

  Role copyWith({
    String? id,
    String? name,
    String? description,
    String? ability,
    RoleTeam? team,
    RoleType? type,
    String? emoji,
    int? count,
  }) =>
      Role(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        ability: ability ?? this.ability,
        team: team ?? this.team,
        type: type ?? this.type,
        emoji: emoji ?? this.emoji,
        count: count ?? this.count,
      );
}

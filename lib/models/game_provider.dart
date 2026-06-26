import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/role.dart';
import '../models/game_models.dart';
import '../data/default_roles.dart';

class GameProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Role> _roles = [];
  List<Scenario> _scenarios = [];
  GameSession? _currentSession;

  List<Role> get roles => _roles;
  List<Scenario> get scenarios => _scenarios;
  GameSession? get currentSession => _currentSession;

  List<Role> get mafiaRoles =>
      _roles.where((r) => r.team == RoleTeam.mafia).toList();
  List<Role> get citizenRoles =>
      _roles.where((r) => r.team == RoleTeam.citizen).toList();
  List<Role> get independentRoles =>
      _roles.where((r) => r.team == RoleTeam.independent).toList();

  Future<void> init() async {
    await _loadRoles();
    await _loadScenarios();
  }

  // ── نقش‌ها ──────────────────────────────────────────────
  Future<void> _loadRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('roles');
    if (data == null) {
      _roles = DefaultRoles.all;
      await _saveRoles();
    } else {
      final list = jsonDecode(data) as List;
      _roles = list.map((e) => Role.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveRoles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'roles', jsonEncode(_roles.map((r) => r.toJson()).toList()));
  }

  Future<void> addRole(Role role) async {
    _roles.add(role.copyWith(id: _uuid.v4()));
    await _saveRoles();
    notifyListeners();
  }

  Future<void> updateRole(Role role) async {
    final idx = _roles.indexWhere((r) => r.id == role.id);
    if (idx != -1) {
      _roles[idx] = role;
      await _saveRoles();
      notifyListeners();
    }
  }

  Future<void> deleteRole(String id) async {
    _roles.removeWhere((r) => r.id == id);
    await _saveRoles();
    notifyListeners();
  }

  // ── سناریوها ────────────────────────────────────────────
  Future<void> _loadScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('scenarios');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _scenarios = list.map((e) => Scenario.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'scenarios', jsonEncode(_scenarios.map((s) => s.toJson()).toList()));
  }

  Future<void> addScenario(Scenario scenario) async {
    _scenarios.add(scenario);
    await _saveScenarios();
    notifyListeners();
  }

  Future<void> updateScenario(Scenario scenario) async {
    final idx = _scenarios.indexWhere((s) => s.id == scenario.id);
    if (idx != -1) {
      _scenarios[idx] = scenario;
      await _saveScenarios();
      notifyListeners();
    }
  }

  Future<void> deleteScenario(String id) async {
    _scenarios.removeWhere((s) => s.id == id);
    await _saveScenarios();
    notifyListeners();
  }

  Scenario createScenario(String name, String description) {
    return Scenario(
      id: _uuid.v4(),
      name: name,
      description: description,
      roles: [],
      createdAt: DateTime.now(),
    );
  }

  // ── بازی ────────────────────────────────────────────────
  GameSession startGame(Scenario scenario, List<String> playerNames) {
    // توزیع نقش‌ها
    final allRoles = <Role>[];
    for (final sr in scenario.roles) {
      final role = _roles.firstWhere((r) => r.id == sr.roleId,
          orElse: () => _roles.first);
      for (int i = 0; i < sr.count; i++) {
        allRoles.add(role);
      }
    }
    allRoles.shuffle();

    final players = playerNames.asMap().entries.map((e) {
      return Player(
        id: _uuid.v4(),
        name: e.value,
        role: e.key < allRoles.length ? allRoles[e.key] : null,
      );
    }).toList();

    _currentSession = GameSession(
      id: _uuid.v4(),
      scenario: scenario,
      players: players,
      startedAt: DateTime.now(),
    );
    notifyListeners();
    return _currentSession!;
  }

  void eliminatePlayer(String playerId) {
    if (_currentSession == null) return;
    final player =
        _currentSession!.players.firstWhere((p) => p.id == playerId);
    player.status = PlayerStatus.eliminated;
    _currentSession!.gameLog.add(
        '${_currentSession!.isNight ? "شب" : "روز"} ${_currentSession!.currentDay}: ${player.name} حذف شد');
    notifyListeners();
  }

  void silencePlayer(String playerId) {
    if (_currentSession == null) return;
    final player =
        _currentSession!.players.firstWhere((p) => p.id == playerId);
    player.status = PlayerStatus.silenced;
    notifyListeners();
  }

  void nextPhase() {
    if (_currentSession == null) return;
    if (_currentSession!.isNight) {
      _currentSession!.isNight = false;
    } else {
      _currentSession!.isNight = true;
      _currentSession!.currentDay++;
      // ساکت‌شده‌ها رو برگردون
      for (final p in _currentSession!.players) {
        if (p.status == PlayerStatus.silenced) {
          p.status = PlayerStatus.alive;
        }
      }
    }
    notifyListeners();
  }

  void endGame() {
    _currentSession = null;
    notifyListeners();
  }

  String? checkWinCondition() {
    if (_currentSession == null) return null;
    final session = _currentSession!;
    if (session.aliveMafia == 0) return 'شهروندان';
    if (session.aliveMafia >= session.aliveCitizens) return 'مافیا';
    return null;
  }
}

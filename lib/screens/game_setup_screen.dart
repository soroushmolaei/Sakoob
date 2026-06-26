import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/game_provider.dart';
import 'game_screen.dart';

class GameSetupScreen extends StatefulWidget {
  final Scenario scenario;
  const GameSetupScreen({super.key, required this.scenario});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.scenario.totalPlayers,
      (i) => TextEditingController(text: 'بازیکن ${i + 1}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SarkoobTheme.background,
      appBar: AppBar(title: const Text('ورود اسامی بازیکنان')),
      body: Column(
        children: [
          // هدر
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SarkoobTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: SarkoobTheme.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('🎮', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.scenario.name,
                      style: const TextStyle(
                        color: SarkoobTheme.primary,
                        fontFamily: 'Vazirmatn',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${widget.scenario.totalPlayers} بازیکن',
                      style: const TextStyle(
                        color: SarkoobTheme.textSecondary,
                        fontFamily: 'Vazirmatn',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _controllers.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SarkoobTheme.surfaceVariant,
                        border: Border.all(color: SarkoobTheme.border),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: SarkoobTheme.textSecondary,
                            fontFamily: 'Vazirmatn',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controllers[i],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: SarkoobTheme.textPrimary,
                          fontFamily: 'Vazirmatn',
                        ),
                        decoration: InputDecoration(
                          hintText: 'نام بازیکن ${i + 1}',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Text('🎲', style: TextStyle(fontSize: 20)),
                label: const Text('شروع بازی'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    final names = _controllers
        .map((c) => c.text.trim())
        .where((n) => n.isNotEmpty)
        .toList();

    if (names.length != widget.scenario.totalPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً اسم همه بازیکنان را وارد کنید',
              style: TextStyle(fontFamily: 'Vazirmatn')),
          backgroundColor: SarkoobTheme.accent,
        ),
      );
      return;
    }

    final provider = context.read<GameProvider>();
    final session = provider.startGame(widget.scenario, names);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(session: session)),
    );
  }
}

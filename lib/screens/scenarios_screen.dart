import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/game_provider.dart';
import 'scenario_edit_screen.dart';
import 'game_setup_screen.dart';

class ScenariosScreen extends StatelessWidget {
  final bool selectMode;
  const ScenariosScreen({super.key, this.selectMode = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SarkoobTheme.background,
      appBar: AppBar(
        title: Text(selectMode ? 'انتخاب سناریو' : 'سناریوها'),
      ),
      floatingActionButton: selectMode
          ? null
          : FloatingActionButton(
              backgroundColor: SarkoobTheme.primary,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScenarioEditScreen()),
              ),
              child: const Icon(Icons.add, color: Colors.black),
            ),
      body: Consumer<GameProvider>(
        builder: (context, provider, _) {
          if (provider.scenarios.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📜', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  const Text(
                    'هنوز سناریویی ساخته نشده',
                    style: TextStyle(
                      color: SarkoobTheme.textSecondary,
                      fontFamily: 'Vazirmatn',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!selectMode)
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ScenarioEditScreen()),
                      ),
                      child: const Text('ساخت سناریو جدید'),
                    ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.scenarios.length,
            itemBuilder: (context, i) {
              final scenario = provider.scenarios[i];
              return _ScenarioCard(
                scenario: scenario,
                selectMode: selectMode,
              )
                  .animate(delay: Duration(milliseconds: i * 70))
                  .fadeIn()
                  .slideX(begin: 0.1, end: 0);
            },
          );
        },
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final bool selectMode;
  const _ScenarioCard({required this.scenario, required this.selectMode});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<GameProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A26), Color(0xFF12121A)],
        ),
        border: Border.all(color: SarkoobTheme.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: selectMode
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            GameSetupScreen(scenario: scenario)),
                  )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: SarkoobTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('📜', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.name,
                            style: const TextStyle(
                              color: SarkoobTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazirmatn',
                              fontSize: 17,
                            ),
                          ),
                          if (scenario.description.isNotEmpty)
                            Text(
                              scenario.description,
                              style: const TextStyle(
                                color: SarkoobTheme.textSecondary,
                                fontFamily: 'Vazirmatn',
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!selectMode) ...[
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: SarkoobTheme.primary, size: 20),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ScenarioEditScreen(scenario: scenario)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: SarkoobTheme.accentLight, size: 20),
                        onPressed: () =>
                            _confirmDelete(context, provider),
                      ),
                    ],
                    if (selectMode)
                      const Icon(Icons.arrow_back_ios,
                          color: SarkoobTheme.primary, size: 18),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _chip('👥 ${scenario.totalPlayers} بازیکن',
                        SarkoobTheme.primary),
                    _chip('🃏 ${scenario.roles.length} نقش',
                        const Color(0xFF6B4C9A)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontFamily: 'Vazirmatn',
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SarkoobTheme.surfaceVariant,
        title: const Text('حذف سناریو',
            style: TextStyle(
                color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn')),
        content: Text('سناریو "${scenario.name}" حذف شود؟',
            style: const TextStyle(
                color: SarkoobTheme.textSecondary, fontFamily: 'Vazirmatn')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف',
                style: TextStyle(
                    color: SarkoobTheme.textSecondary,
                    fontFamily: 'Vazirmatn')),
          ),
          TextButton(
            onPressed: () {
              provider.deleteScenario(scenario.id);
              Navigator.pop(context);
            },
            child: const Text('حذف',
                style: TextStyle(
                    color: SarkoobTheme.accentLight, fontFamily: 'Vazirmatn')),
          ),
        ],
      ),
    );
  }
}

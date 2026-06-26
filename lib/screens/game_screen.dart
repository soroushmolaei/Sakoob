import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/game_provider.dart';

class GameScreen extends StatefulWidget {
  final GameSession session;
  const GameScreen({super.key, required this.session});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final session = provider.currentSession ?? widget.session;
        final winner = provider.checkWinCondition();

        if (winner != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showWinDialog(winner);
          });
        }

        return Scaffold(
          backgroundColor: SarkoobTheme.background,
          body: Container(
            decoration: const BoxDecoration(gradient: SarkoobTheme.darkGradient),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(session, provider),
                  _buildPhaseBar(session),
                  Expanded(child: _buildPlayersList(session, provider)),
                  _buildBottomBar(session, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(GameSession session, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: SarkoobTheme.textSecondary),
            onPressed: () => _confirmExit(provider),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  session.isNight ? '🌙 شب ${session.currentDay}' : '☀️ روز ${session.currentDay}',
                  style: TextStyle(
                    color: session.isNight ? const Color(0xFF9B8EC4) : SarkoobTheme.primaryLight,
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  session.scenario.name,
                  style: const TextStyle(
                    color: SarkoobTheme.textMuted,
                    fontFamily: 'Vazirmatn',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // لاگ بازی
          IconButton(
            icon: const Icon(Icons.history, color: SarkoobTheme.textSecondary),
            onPressed: () => _showLog(session),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseBar(GameSession session) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: SarkoobTheme.surfaceVariant,
        border: Border.all(color: SarkoobTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('👥', 'زنده', '${session.alivePlayers.length}'),
          _divider(),
          _stat('🔴', 'مافیا', '${session.aliveMafia}'),
          _divider(),
          _stat('🟢', 'شهروند', '${session.aliveCitizens}'),
          _divider(),
          _stat('💀', 'حذف', '${session.players.where((p) => p.status == PlayerStatus.eliminated).length}'),
        ],
      ),
    );
  }

  Widget _stat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: SarkoobTheme.primary,
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(
                color: SarkoobTheme.textMuted,
                fontFamily: 'Vazirmatn',
                fontSize: 11)),
      ],
    );
  }

  Widget _divider() => Container(
      height: 36, width: 1, color: SarkoobTheme.border);

  Widget _buildPlayersList(GameSession session, GameProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: session.players.length,
      itemBuilder: (context, i) {
        final player = session.players[i];
        return _PlayerCard(
          player: player,
          index: i + 1,
          onEliminate: () => provider.eliminatePlayer(player.id),
          onSilence: () => provider.silencePlayer(player.id),
          onReveal: () => _showRole(player),
        ).animate(delay: Duration(milliseconds: i * 40)).fadeIn();
      },
    );
  }

  Widget _buildBottomBar(GameSession session, GameProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: SarkoobTheme.border)),
      ),
      child: ElevatedButton.icon(
        onPressed: () => provider.nextPhase(),
        icon: Text(
          session.isNight ? '☀️' : '🌙',
          style: const TextStyle(fontSize: 20),
        ),
        label: Text(
          session.isNight ? 'پایان شب — شروع روز' : 'پایان روز — شروع شب',
          style: const TextStyle(fontFamily: 'Vazirmatn'),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: session.isNight
              ? const Color(0xFF9B8EC4)
              : SarkoobTheme.primary,
        ),
      ),
    );
  }

  void _showRole(Player player) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SarkoobTheme.surfaceVariant,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(player.role?.emoji ?? '👤',
                style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              player.name,
              style: const TextStyle(
                color: SarkoobTheme.textPrimary,
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: (player.role?.teamColor ?? SarkoobTheme.primary)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                player.role?.name ?? 'نامشخص',
                style: TextStyle(
                  color: player.role?.teamColor ?? SarkoobTheme.primary,
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              player.role?.ability ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SarkoobTheme.textSecondary,
                fontFamily: 'Vazirmatn',
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('بستن',
                  style: TextStyle(
                      color: SarkoobTheme.primary, fontFamily: 'Vazirmatn')),
            ),
          ),
        ],
      ),
    );
  }

  void _showLog(GameSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SarkoobTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SarkoobTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text('تاریخچه بازی',
              style: TextStyle(
                  color: SarkoobTheme.primary,
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const SizedBox(height: 8),
          Expanded(
            child: session.gameLog.isEmpty
                ? const Center(
                    child: Text('هنوز اتفاقی نیفتاده',
                        style: TextStyle(
                            color: SarkoobTheme.textMuted,
                            fontFamily: 'Vazirmatn')))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: session.gameLog.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        session.gameLog[i],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: SarkoobTheme.textSecondary,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showWinDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: SarkoobTheme.surfaceVariant,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text('بازی تمام شد!',
                style: TextStyle(
                    color: SarkoobTheme.textPrimary,
                    fontFamily: 'Vazirmatn',
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '$winner برنده شدند!',
              style: const TextStyle(
                  color: SarkoobTheme.primary,
                  fontFamily: 'Vazirmatn',
                  fontSize: 18),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<GameProvider>().endGame();
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
              child: const Text('بازگشت به منو'),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmExit(GameProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SarkoobTheme.surfaceVariant,
        title: const Text('خروج از بازی',
            style: TextStyle(
                color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn')),
        content: const Text('بازی جاری پایان می‌یابد. مطمئنی؟',
            style: TextStyle(
                color: SarkoobTheme.textSecondary, fontFamily: 'Vazirmatn')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ادامه بازی',
                style: TextStyle(
                    color: SarkoobTheme.primary, fontFamily: 'Vazirmatn')),
          ),
          TextButton(
            onPressed: () {
              provider.endGame();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            child: const Text('خروج',
                style: TextStyle(
                    color: SarkoobTheme.accentLight, fontFamily: 'Vazirmatn')),
          ),
        ],
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  final int index;
  final VoidCallback onEliminate;
  final VoidCallback onSilence;
  final VoidCallback onReveal;

  const _PlayerCard({
    required this.player,
    required this.index,
    required this.onEliminate,
    required this.onSilence,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    final isEliminated = player.status == PlayerStatus.eliminated;
    final isSilenced = player.status == PlayerStatus.silenced;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isEliminated
            ? SarkoobTheme.background
            : SarkoobTheme.cardBg,
        border: Border.all(
          color: isEliminated
              ? SarkoobTheme.border.withOpacity(0.3)
              : isSilenced
                  ? Colors.orange.withOpacity(0.4)
                  : SarkoobTheme.border,
        ),
      ),
      child: Opacity(
        opacity: isEliminated ? 0.4 : 1.0,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SarkoobTheme.surfaceVariant,
                  border: Border.all(color: SarkoobTheme.border),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: SarkoobTheme.textSecondary,
                      fontFamily: 'Vazirmatn',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isEliminated)
                const Positioned.fill(
                  child: Center(
                    child: Text('💀', style: TextStyle(fontSize: 20)),
                  ),
                ),
            ],
          ),
          title: Text(
            player.name,
            style: TextStyle(
              color: isEliminated
                  ? SarkoobTheme.textMuted
                  : SarkoobTheme.textPrimary,
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
              decoration: isEliminated ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: isSilenced
              ? const Text('🤐 ساکت شده',
                  style: TextStyle(
                      color: Colors.orange,
                      fontFamily: 'Vazirmatn',
                      fontSize: 12))
              : null,
          trailing: isEliminated
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // نمایش نقش
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined,
                          color: SarkoobTheme.primary, size: 20),
                      onPressed: onReveal,
                      tooltip: 'نمایش نقش',
                    ),
                    // ساکت کردن
                    IconButton(
                      icon: const Icon(Icons.volume_off_outlined,
                          color: Colors.orange, size: 20),
                      onPressed: onSilence,
                      tooltip: 'ساکت کردن',
                    ),
                    // حذف
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: SarkoobTheme.accentLight, size: 20),
                      onPressed: onEliminate,
                      tooltip: 'حذف از بازی',
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

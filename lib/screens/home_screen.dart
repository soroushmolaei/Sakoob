import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'roles_screen.dart';
import 'scenarios_screen.dart';
import 'game_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SarkoobTheme.darkGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // هدر
              _buildHeader(),
              const SizedBox(height: 60),
              // منو
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _MenuButton(
                        icon: '🎮',
                        title: 'شروع بازی',
                        subtitle: 'شروع یک بازی جدید',
                        color: SarkoobTheme.primary,
                        delay: 0,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScenariosScreen(
                                  selectMode: true)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: '📜',
                        title: 'سناریوها',
                        subtitle: 'مدیریت سناریوهای بازی',
                        color: const Color(0xFF6B4C9A),
                        delay: 100,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScenariosScreen()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: '🃏',
                        title: 'نقش‌ها',
                        subtitle: 'مدیریت نقش‌های بازی',
                        color: SarkoobTheme.accent,
                        delay: 200,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RolesScreen()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MenuButton(
                        icon: '⚙️',
                        title: 'تنظیمات',
                        subtitle: 'تنظیمات برنامه',
                        color: SarkoobTheme.textMuted,
                        delay: 300,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              // فوتر
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'نسخه ۱.۰.۰',
                  style: TextStyle(
                    color: SarkoobTheme.textMuted,
                    fontSize: 12,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: SarkoobTheme.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: SarkoobTheme.primary.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Text('🎭', style: TextStyle(fontSize: 44)),
          ),
        )
            .animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 16),
        const Text(
          'سرکوب',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: SarkoobTheme.primary,
            fontFamily: 'Vazirmatn',
          ),
        ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),
        const Text(
          'گرداننده بازی مافیا',
          style: TextStyle(
            fontSize: 14,
            color: SarkoobTheme.textSecondary,
            fontFamily: 'Vazirmatn',
          ),
        ).animate(delay: 300.ms).fadeIn(),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final int delay;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A26), Color(0xFF12121A)],
            ),
            border: Border.all(color: SarkoobTheme.border),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: color.withOpacity(0.15),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SarkoobTheme.textPrimary,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: SarkoobTheme.textSecondary,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_back_ios, color: color, size: 18),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delay + 400))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }
}

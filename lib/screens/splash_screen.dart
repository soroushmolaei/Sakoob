import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SarkoobTheme.background,
      body: Container(
        decoration: const BoxDecoration(gradient: SarkoobTheme.darkGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // لوگو
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFF2A1A00), Color(0xFF0A0A0F)],
                  ),
                  border: Border.all(color: SarkoobTheme.primary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: SarkoobTheme.primary.withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🎭',
                    style: TextStyle(fontSize: 70),
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 40),

              // عنوان
              const Text(
                'سرکوب',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: SarkoobTheme.primary,
                  fontFamily: 'Vazirmatn',
                  letterSpacing: 4,
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 12),

              const Text(
                'بازی مافیا',
                style: TextStyle(
                  fontSize: 18,
                  color: SarkoobTheme.textSecondary,
                  fontFamily: 'Vazirmatn',
                  letterSpacing: 2,
                ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 80),

              // لودینگ
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  backgroundColor: SarkoobTheme.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      SarkoobTheme.primary),
                ),
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

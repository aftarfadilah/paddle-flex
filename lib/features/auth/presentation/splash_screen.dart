import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Brief branded pause then redirect to feed
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.go('/feed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo with subtle pulse
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (_, double scale, child) => Transform.scale(
                scale: scale,
                child: child,
              ),
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.sports_tennis, color: Colors.black, size: 48),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Strion',
              style: AppFonts.display.copyWith(
                fontSize: 32,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Every session. Every win. Let them know.',
              style: AppFonts.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 48),
            // Elegant progress indicator
            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.surfaceMid,
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(4),
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

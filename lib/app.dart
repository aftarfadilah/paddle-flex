import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/strion_light_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';

final themeProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

class StrionApp extends ConsumerWidget {
  const StrionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Strion',
      theme: LightTheme.theme,
      darkTheme: AppTheme.dark,
      themeMode: themeColors.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

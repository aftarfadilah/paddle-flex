import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.bg,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.primary,
                        child: const Icon(Icons.person, color: Colors.black, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text('Strion User',
                          style: Theme.of(context).textTheme.displayMedium),
                      Text('@user_${userId == "me" ? "me" : userId}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              if (userId == 'me')
                IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatBox(label: 'Sessions', value: '0'),
                      _StatBox(label: 'Win Rate', value: '0%'),
                      _StatBox(label: '🔥 Streak', value: '0'),
                      _StatBox(label: 'Best', value: '0'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bio
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'No bio yet. Update your profile to tell your club who you are.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Achievements placeholder
                  Text('Achievements', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AchievementBadge(icon: Icons.emoji_events, label: 'First Log', locked: false),
                      _AchievementBadge(icon: Icons.local_fire_department, label: 'On Fire', locked: true),
                      _AchievementBadge(icon: Icons.star, label: 'Century', locked: true),
                      _AchievementBadge(icon: Icons.military_tech, label: 'Champion', locked: true),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Recent sessions
                  Text('Recent Sessions', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.sports_tennis, size: 48, color: AppTheme.textSecondary),
                        const SizedBox(height: 8),
                        Text('No sessions yet',
                            style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Log your first session to see it here',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primary, fontFamily: 'JetBrainsMono')),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool locked;
  const _AchievementBadge({required this.icon, required this.label, required this.locked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: locked
                ? AppTheme.surface
                : AppTheme.warning.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: locked ? AppTheme.border : AppTheme.warning.withOpacity(0.5),
            ),
            boxShadow: locked ? null
                : [BoxShadow(color: AppTheme.warning.withOpacity(0.2), blurRadius: 8)],
          ),
          child: Icon(
            locked ? Icons.lock : icon,
            color: locked ? AppTheme.textSecondary : AppTheme.warning,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

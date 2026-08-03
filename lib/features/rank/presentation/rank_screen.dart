import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

final _rankStatsProvider = FutureProvider<_MyStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return _MyStats(
    totalSessions: 47,
    currentStreak: 5,
    longestStreak: 12,
    totalFlexMinutes: 1840,
    winRate: 0.64,
    thisWeek: [
      _DayStat('Mon', false),
      _DayStat('Tue', true),
      _DayStat('Wed', true),
      _DayStat('Thu', false),
      _DayStat('Fri', true),
      _DayStat('Sat', false),
      _DayStat('Sun', false),
    ],
    monthlyVolume: [32, 28, 45, 38, 52, 41, 36, 49, 44, 38, 31, 47],
    exerciseProgress: [
      _ExerciseProgress('Bench Press', 85, 92.5),
      _ExerciseProgress('Squat', 60, 75.0),
      _ExerciseProgress('Deadlift', 100, 140.0),
      _ExerciseProgress('Pull-up', 75, 90.0),
      _ExerciseProgress('Overhead Press', 40, 52.5),
    ],
  );
});

class _MyStats {
  final int totalSessions, currentStreak, longestStreak, totalFlexMinutes;
  final double winRate;
  final List<_DayStat> thisWeek;
  final List<int> monthlyVolume;
  final List<_ExerciseProgress> exerciseProgress;
  _MyStats({
    required this.totalSessions,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalFlexMinutes,
    required this.winRate,
    required this.thisWeek,
    required this.monthlyVolume,
    required this.exerciseProgress,
  });
}

class _DayStat {
  final String day;
  final bool trained;
  _DayStat(this.day, this.trained);
}

class _ExerciseProgress {
  final String name;
  final double last;
  final double best;
  _ExerciseProgress(this.name, this.last, this.best);
}

class RankScreen extends ConsumerWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_rankStatsProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Your Rank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, size: 20),
            onPressed: () {},
            tooltip: 'Calendar view',
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const _ShimmerRank(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StreakBanner(current: stats.currentStreak, longest: stats.longestStreak),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _QuickStatCard(
                          label: 'Sessions', value: '${stats.totalSessions}',
                          icon: Icons.fitness_center, color: AppColors.primary,
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: _QuickStatCard(
                          label: 'Win Rate', value: '${(stats.winRate * 100).toInt()}%',
                          icon: Icons.percent, color: AppColors.accent,
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: _QuickStatCard(
                          label: 'Hours', value: '${(stats.totalFlexMinutes / 60).toStringAsFixed(0)}',
                          icon: Icons.timer_outlined, color: AppColors.warning,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('This Week', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _WeekRow(stats.thisWeek),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Monthly Sessions', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    _VolumeChart(stats.monthlyVolume),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Personal Records', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final ex = stats.exerciseProgress[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: _PRCard(name: ex.name, last: ex.last, best: ex.best),
                  );
                },
                childCount: stats.exerciseProgress.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  final int current, longest;
  const _StreakBanner({required this.current, required this.longest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(color: AppColors.surfaceRaised),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentDark],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 20)],
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$current Day Streak',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.accent)),
                const SizedBox(height: 2),
                Text('Longest: $longest days', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.emoji_events, color: AppColors.gold, size: 28),
              const SizedBox(height: 2),
              Text('#3', style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _QuickStatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.glassCard(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  final List<_DayStat> days;
  const _WeekRow(this.days);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((d) {
          return Column(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: d.trained ? AppColors.primary : AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(10),
                  border: d.trained ? null : Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Icon(
                    d.trained ? Icons.check : Icons.circle,
                    size: d.trained ? 16 : 6,
                    color: d.trained ? Colors.black : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(d.day, style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _VolumeChart extends StatelessWidget {
  final List<int> volumes;
  const _VolumeChart(this.volumes);

  @override
  Widget build(BuildContext context) {
    final max = volumes.reduce((a, b) => a > b ? a : b).toDouble();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: volumes.map((v) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    children: [
                      Text('$v', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9)),
                      const SizedBox(height: 4),
                      FractionallySizedBox(
                        heightFactor: max > 0 ? v / max : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF00A888)],
                              begin: Alignment.bottomCenter, end: Alignment.topCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Jan', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
              const Spacer(),
              Text('Dec', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PRCard extends StatelessWidget {
  final String name;
  final double last, best;
  const _PRCard({required this.name, required this.last, required this.best});

  @override
  Widget build(BuildContext context) {
    final pct = best > 0 ? (last / best).clamp(0.0, 1.0) : 0.0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.glassCard(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: AppColors.surfaceRaised,
                    color: pct >= 0.9 ? AppColors.primary : AppColors.accent,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Last: ${last.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.gold, size: 14),
                  const SizedBox(width: 4),
                  Text('${best.toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.gold)),
                ],
              ),
              const SizedBox(height: 4),
              Text('PR', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerRank extends StatelessWidget {
  const _ShimmerRank();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(6, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: i == 0 ? 100 : 70,
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      )),
    );
  }
}

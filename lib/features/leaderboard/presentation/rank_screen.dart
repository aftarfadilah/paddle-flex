import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/presentation/home_shell.dart';

final _rankStatsProvider = FutureProvider<_MyStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return _mockStats;
});

final _mockStats = _MyStats(
  streak: 5, longestStreak: 12, rank: 3,
  totalSessions: 47, winRate: 64, totalHours: 31,
  weeklyDots: [false, true, true, false, true, false, false],
  monthlySessions: [12, 8, 15, 11, 18, 14, 20, 16, 9, 13, 17, 11],
  prProgress: [
    _PrItem(name: 'Forehand', current: 87, target: 95),
    _PrItem(name: 'Backhand', current: 82, target: 90),
    _PrItem(name: 'Serve',    current: 74, target: 90),
    _PrItem(name: 'Volley',   current: 65, target: 85),
  ],
);

class _MyStats {
  final int streak, longestStreak, rank;
  final int totalSessions, winRate, totalHours;
  final List<bool> weeklyDots;
  final List<int> monthlySessions;
  final List<_PrItem> prProgress;
  _MyStats({
    required this.streak, required this.longestStreak, required this.rank,
    required this.totalSessions, required this.winRate, required this.totalHours,
    required this.weeklyDots, required this.monthlySessions, required this.prProgress,
  });
}

class _PrItem {
  final String name; final int current; final int target;
  _PrItem({required this.name, required this.current, required this.target});
}

class RankScreen extends ConsumerWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_rankStatsProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: statsAsync.when(
        loading: () => const _RankShimmer(),
        error: (e, st) => Center(child: Text('Error: $e', style: AppFonts.body)),
        data: (stats) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Header
              Text('Your Rank', style: AppFonts.display.copyWith(fontSize: 28)),
              const SizedBox(height: 4),
              Text('Personal performance', style: AppFonts.bodySmall),
              const SizedBox(height: 24),
              // Streak + Rank banner
              StaggeredItem(
                index: 0,
                child: _PremiumStreakBanner(
                  streak: stats.streak, longestStreak: stats.longestStreak, rank: stats.rank,
                ),
              ),
              const SizedBox(height: 16),
              // Stats cards
              StaggeredItem(
                index: 1,
                child: _StatsRow(
                  sessions: stats.totalSessions,
                  winRate: stats.winRate,
                  hours: stats.totalHours,
                ),
              ),
              const SizedBox(height: 24),
              // Weekly activity
              StaggeredItem(
                index: 2,
                child: _WeeklyTracker(dots: stats.weeklyDots),
              ),
              const SizedBox(height: 24),
              // Monthly chart
              StaggeredItem(
                index: 3,
                child: _MonthlyChart(data: stats.monthlySessions),
              ),
              const SizedBox(height: 24),
              // PR Progress
              StaggeredItem(
                index: 4,
                child: _PrSection(items: stats.prProgress),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, -10),
        child: PremiumFAB(onTap: () {}),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ── Premium Streak Banner ─────────────────────────────────────────────────────
class _PremiumStreakBanner extends StatefulWidget {
  final int streak, longestStreak, rank;
  const _PremiumStreakBanner({required this.streak, required this.longestStreak, required this.rank});
  @override
  State<_PremiumStreakBanner> createState() => _PremiumStreakBannerState();
}

class _PremiumStreakBannerState extends State<_PremiumStreakBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _width;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _width = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SizeTransition(
        sizeFactor: _width,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.glassCard(elevated: true),
          child: Row(
            children: [
              // Streak
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 26),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedCounter(
                              value: widget.streak,
                              style: AppFonts.display.copyWith(fontSize: 24),
                              suffix: 'd',
                            ),
                            Text(' streak', style: AppFonts.body),
                          ],
                        ),
                        Text('Longest: ${widget.longestStreak} days', style: AppFonts.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 0.75, height: 52, color: AppColors.border),
              const SizedBox(width: 16),
              // Rank
              Column(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Center(
                      child: Text('#${widget.rank}',
                        style: AppFonts.mono.copyWith(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Global', style: AppFonts.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int sessions, winRate, hours;
  const _StatsRow({required this.sessions, required this.winRate, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(
          icon: Icons.sports_tennis, value: sessions, label: 'Sessions',
          gradient: [const Color(0xFF00E5BE), const Color(0xFF00B39A)],
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(
          icon: Icons.percent, value: winRate, label: 'Win Rate',
          suffix: '%',
          gradient: [const Color(0xFFFF6B35), const Color(0xFFE05520)],
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(
          icon: Icons.schedule, value: hours, label: 'Hours',
          gradient: [const Color(0xFFFFBE0B), const Color(0xFFD4AF37)],
        )),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final int value; final String label;
  final List<Color> gradient; final String suffix;
  const _StatCard({required this.icon, required this.value, required this.label,
    required this.gradient, this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard(),
      child: Column(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 12),
          AnimatedCounter(
            value: value,
            style: AppFonts.display.copyWith(fontSize: 22),
            suffix: suffix,
          ),
          const SizedBox(height: 4),
          Text(label, style: AppFonts.bodySmall),
        ],
      ),
    );
  }
}

// ── Weekly Tracker ────────────────────────────────────────────────────────────
class _WeeklyTracker extends StatelessWidget {
  final List<bool> dots;
  const _WeeklyTracker({required this.dots});
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This Week', style: AppFonts.title),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) => Column(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: dots[i]
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.surfaceMid,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dots[i]
                          ? AppColors.accent.withValues(alpha: 0.4)
                          : AppColors.border,
                      width: 0.75,
                    ),
                  ),
                  child: dots[i]
                      ? const Icon(Icons.check_rounded, color: AppColors.accent, size: 18)
                      : null,
                ),
                const SizedBox(height: 6),
                Text(_days[i], style: AppFonts.bodySmall.copyWith(fontSize: 11)),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

// ── Monthly Chart ─────────────────────────────────────────────────────────────
class _MonthlyChart extends StatelessWidget {
  final List<int> data;
  const _MonthlyChart({required this.data});
  static const _months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Sessions', style: AppFonts.title),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (i) {
                final h = maxVal > 0 ? (data[i] / maxVal) * 88.0 : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 600 + i * 80),
                          height: h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.accent.withValues(alpha: 0.8), AppColors.accent],
                              begin: Alignment.bottomCenter, end: Alignment.topCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_months[i], style: AppFonts.bodySmall.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PR Progress ──────────────────────────────────────────────────────────────
class _PrSection extends StatelessWidget {
  final List<_PrItem> items;
  const _PrSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PR Progress', style: AppFonts.title),
              Text('${items.length} goals', style: AppFonts.bodySmall),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name, style: AppFonts.body),
                    Text('${item.current}% / ${item.target}%',
                      style: AppFonts.mono.copyWith(fontSize: 11, color: AppColors.accent)),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMid,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: item.current / 100,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────
class _RankShimmer extends StatelessWidget {
  const _RankShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
      children: [
        ShimmerBox(height: 28, width: 140),
        const SizedBox(height: 8),
        ShimmerBox(height: 14, width: 100),
        const SizedBox(height: 24),
        ShimmerBox(height: 100),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: ShimmerBox(height: 110)),
          const SizedBox(width: 10),
          Expanded(child: ShimmerBox(height: 110)),
          const SizedBox(width: 10),
          Expanded(child: ShimmerBox(height: 110)),
        ]),
        const SizedBox(height: 24),
        ShimmerBox(height: 130),
        const SizedBox(height: 24),
        ShimmerBox(height: 130),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/presentation/home_shell.dart';

final _leaderboardProvider = FutureProvider<_LeaderboardData>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return _mockLeaderboard;
});

final _mockLeaderboard = _LeaderboardData(
  overall: _buildList(0),
  exercises: [
    _Entry(name: 'Forehand', icon: Icons.sports_tennis, best: 96, sessions: 34),
    _Entry(name: 'Backhand', icon: Icons.sports_tennis, best: 91, sessions: 29),
    _Entry(name: 'Serve',    icon: Icons.sports_tennis, best: 88, sessions: 41),
    _Entry(name: 'Volley',   icon: Icons.sports_tennis, best: 85, sessions: 22),
    _Entry(name: 'Footwork', icon: Icons.directions_run, best: 82, sessions: 18),
  ],
  clubs: _buildList(1),
);

List<_PlayerEntry> _buildList(int seed) => [
  _PlayerEntry(rank: 1,  name: 'Rafa Nadal Jr',    club: 'Jakarta Padel Club',    score: 92, sessions: 41, gradient: [const Color(0xFFD4AF37), const Color(0xFFB8960C)]),
  _PlayerEntry(rank: 2,  name: 'Ivana Wawrinka',   club: 'Bandung Breakers',     score: 88, sessions: 36, gradient: [const Color(0xFFC0C0C0), const Color(0xFFA0A0A0)]),
  _PlayerEntry(rank: 3,  name: 'Budi Djiwandono',  club: 'Surabaya Smashers',     score: 81, sessions: 29, gradient: [const Color(0xFFCD7F32), const Color(0xFFA0522D)]),
  _PlayerEntry(rank: 4,  name: 'Siti Aminah',       club: 'Jakarta Padel Club',   score: 78, sessions: 26, gradient: [const Color(0xFF6366F1), const Color(0xFF4F46E5)]),
  _PlayerEntry(rank: 5,  name: 'Andi Wijaya',        club: 'Bandung Breakers',     score: 74, sessions: 22, gradient: [const Color(0xFF14B8A6), const Color(0xFF0D9488)]),
  _PlayerEntry(rank: 6,  name: 'Dewi Lestari',      club: 'Surabaya Smashers',    score: 71, sessions: 19, gradient: [const Color(0xFFF59E0B), const Color(0xFFD97706)]),
  _PlayerEntry(rank: 7,  name: 'Reza Pratama',      club: 'Jakarta Padel Club',   score: 68, sessions: 16, gradient: [const Color(0xFFEC4899), const Color(0xFFDB2777)]),
  _PlayerEntry(rank: 8,  name: 'Nia Rahayu',        club: '',                    score: 65, sessions: 14, gradient: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]),
];

class _LeaderboardData {
  final List<_PlayerEntry> overall;
  final List<_Entry> exercises;
  final List<_PlayerEntry> clubs;
  _LeaderboardData({required this.overall, required this.exercises, required this.clubs});
}

class _PlayerEntry {
  final int rank; final String name; final String club;
  final int score; final int sessions; final List<Color> gradient;
  _PlayerEntry({required this.rank, required this.name, required this.club,
    required this.score, required this.sessions, required this.gradient});
}

class _Entry { final String name; final IconData icon; final int best; final int sessions;
  _Entry({required this.name, required this.icon, required this.best, required this.sessions}); }

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lbAsync = ref.watch(_leaderboardProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: lbAsync.when(
        loading: () => const _BoardShimmer(),
        error: (e, st) => Center(child: Text('Error: \$e', style: Theme.of(context).textTheme.bodyMedium)),
        data: (data) => NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Leaderboard', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text('Top athletes this season', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 24),
                    _PremiumPodium(top3: data.overall.take(3).toList()),
                    const SizedBox(height: 24),
                    _PremiumTabBar(tabCtrl: _tabCtrl),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabCtrl,
            children: [
              _PlayerList(entries: data.overall),
              _ExerciseList(entries: data.exercises),
              _PlayerList(entries: data.clubs),
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

class _PremiumPodium extends StatefulWidget {
  final List<_PlayerEntry> top3;
  const _PremiumPodium({required this.top3});
  @override
  State<_PremiumPodium> createState() => _PremiumPodiumState();
}

class _PremiumPodiumState extends State<_PremiumPodium>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _slide = Tween<double>(begin: 0.15, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (widget.top3.length < 3) return const SizedBox.shrink();
    final first = widget.top3[0];
    final second = widget.top3[1];
    final third = widget.top3[2];

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // #2
            _PodiumPlace(entry: second, height: 100),
            const SizedBox(width: 8),
            // #1
            _PodiumPlace(entry: first, height: 128),
            const SizedBox(width: 8),
            // #3
            _PodiumPlace(entry: third, height: 80),
          ],
        ),
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final _PlayerEntry entry;
  final double height;
  const _PodiumPlace({required this.entry, required this.height});

  Color _medalColor(BuildContext context) => switch (entry.rank) {
    1 => const Color(0xFFD4AF37),
    2 => const Color(0xFFC0C0C0),
    _ => const Color(0xFFCD7F32),
  };

  IconData get _medalIcon => switch (entry.rank) {
    1 => Icons.emoji_events,
    2 => Icons.emoji_events_outlined,
    _ => Icons.emoji_events_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final medalColor = _medalColor(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Medal ring
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: entry.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            boxShadow: [BoxShadow(color: medalColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.surface),
            child: Center(
              child: Text(entry.name[0],
                style: TextStyle(
                  color: entry.gradient[0],
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold, fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(entry.name.split(' ').first, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12)),
        Text('\${entry.score}%', style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: medalColor, fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        // Podium block
        Container(
          width: 88,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [medalColor.withValues(alpha: 0.2), medalColor.withValues(alpha: 0.05)],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: medalColor.withValues(alpha: 0.25), width: 0.75),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_medalIcon, color: medalColor, size: 28),
              const SizedBox(height: 4),
              Text('#\${entry.rank}', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: medalColor, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PremiumTabBar extends StatelessWidget {
  final TabController tabCtrl;
  const _PremiumTabBar({required this.tabCtrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.75),
      ),
      child: TabBar(
        controller: tabCtrl,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Overall'),
          Tab(text: 'Exercises'),
          Tab(text: 'Clubs'),
        ],
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final List<_PlayerEntry> entries;
  const _PlayerList({required this.entries});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (ctx, i) => StaggeredItem(
        index: i,
        child: _PlayerRow(entry: entries[i]),
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final _PlayerEntry entry;
  const _PlayerRow({required this.entry});

  Color _rankColor(BuildContext context) => switch (entry.rank) {
    1 => const Color(0xFFD4AF37),
    2 => const Color(0xFFC0C0C0),
    3 => const Color(0xFFCD7F32),
    _ => Theme.of(context).colorScheme.onSurfaceVariant,
  };

  @override
  Widget build(BuildContext context) {
    final rankColor = _rankColor(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: AppTheme.glassCard(),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('#\${entry.rank}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12, color: rankColor, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: entry.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.surface),
              child: Center(child: Text(entry.name[0],
                style: TextStyle(color: entry.gradient[0], fontWeight: FontWeight.bold, fontSize: 15))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: Theme.of(context).textTheme.titleMedium),
                if (entry.club.isNotEmpty)
                  Text(entry.club, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\${entry.score}%', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: entry.rank <= 3 ? rankColor : Theme.of(context).colorScheme.onSurface, fontSize: 14)),
              Text('\${entry.sessions}s', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final List<_Entry> entries;
  const _ExerciseList({required this.entries});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (ctx, i) => StaggeredItem(
        index: i,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.glassCard(),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                ),
                child: Icon(entries[i].icon, color: Theme.of(context).colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entries[i].name, style: Theme.of(context).textTheme.titleMedium),
                    Text('\${entries[i].sessions} sessions', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text('\${entries[i].best}%', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardShimmer extends StatelessWidget {
  const _BoardShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
      children: [
        ShimmerBox(height: 28, width: 160),
        const SizedBox(height: 8),
        ShimmerBox(height: 14, width: 120),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ShimmerBox(height: 100, width: 88),
          const SizedBox(width: 8),
          ShimmerBox(height: 128, width: 88),
          const SizedBox(width: 8),
          ShimmerBox(height: 80, width: 88),
        ]),
        const SizedBox(height: 24),
        ...List.generate(6, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ShimmerBox(height: 68),
        )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

final _leaderboardProvider = FutureProvider<_LeaderboardData>((ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return _LeaderboardData(
    top3: [
      _Player('Rafa Nadal Jr', 'Jakarta Padel Club', 47, 92.0, 92.0),
      _Player('Ivana Wawrinka', 'Surabaya Smashers', 38, 87.5, 87.5),
      _Player('Budi Djiwandono', 'Bali Padel', 31, 81.0, 81.0),
    ],
    rest: [
      _Player('Siti Aminah', 'Jakarta Padel Club', 29, 78.3, 78.3),
      _Player('Andi Wijaya', 'Bandung Breakers', 25, 74.1, 74.1),
      _Player('Dewi Lestari', 'Surabaya Smashers', 22, 71.8, 71.8),
      _Player('Reza Pratama', 'Jakarta Padel Club', 19, 68.5, 68.5),
      _Player('Nia Rahayu', 'Bali Padel', 16, 65.2, 65.2),
    ],
    exerciseLeaderboards: _exerciseLeaderboards,
  );
});

final _exerciseLeaderboards = [
  _ExerciseBoard('Bench Press', [
    _ExerciseEntry('Rafa Nadal Jr', 92.5),
    _ExerciseEntry('Ivana Wawrinka', 87.5),
    _ExerciseEntry('Budi Djiwandono', 82.0),
    _ExerciseEntry('Siti Aminah', 77.5),
    _ExerciseEntry('Andi Wijaya', 75.0),
  ]),
  _ExerciseBoard('Squat', [
    _ExerciseEntry('Budi Djiwandono', 140.0),
    _ExerciseEntry('Reza Pratama', 135.0),
    _ExerciseEntry('Andi Wijaya', 120.0),
    _ExerciseEntry('Rafa Nadal Jr', 115.0),
    _ExerciseEntry('Dewi Lestari', 100.0),
  ]),
  _ExerciseBoard('Deadlift', [
    _ExerciseEntry('Budi Djiwandono', 180.0),
    _ExerciseEntry('Reza Pratama', 170.0),
    _ExerciseEntry('Andi Wijaya', 160.0),
    _ExerciseEntry('Rafa Nadal Jr', 155.0),
    _ExerciseEntry('Ivana Wawrinka', 150.0),
  ]),
  _ExerciseBoard('Pull-up', [
    _ExerciseEntry('Siti Aminah', 90.0),
    _ExerciseEntry('Nia Rahayu', 85.0),
    _ExerciseEntry('Dewi Lestari', 80.0),
    _ExerciseEntry('Reza Pratama', 75.0),
    _ExerciseEntry('Budi Djiwandono', 70.0),
  ]),
  _ExerciseBoard('Overhead Press', [
    _ExerciseEntry('Ivana Wawrinka', 52.5),
    _ExerciseEntry('Rafa Nadal Jr', 50.0),
    _ExerciseEntry('Siti Aminah', 47.5),
    _ExerciseEntry('Andi Wijaya', 45.0),
    _ExerciseEntry('Nia Rahayu', 42.5),
  ]),
];

class _LeaderboardData {
  final List<_Player> top3;
  final List<_Player> rest;
  final List<_ExerciseBoard> exerciseLeaderboards;
  _LeaderboardData({required this.top3, required this.rest, required this.exerciseLeaderboards});
}

class _Player {
  final String name;
  final String gym;
  final int sessions;
  final double winRate;
  final double flex;
  _Player(this.name, this.gym, this.sessions, this.winRate, this.flex);
}

class _ExerciseBoard {
  final String name;
  final List<_ExerciseEntry> entries;
  _ExerciseBoard(this.name, this.entries);
}

class _ExerciseEntry {
  final String name;
  final double weight;
  _ExerciseEntry(this.name, this.weight);
}

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lbAsync = ref.watch(_leaderboardProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Board'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list, size: 22), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Overall'),
            Tab(text: 'Exercises'),
            Tab(text: 'Clubs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          lbAsync.when(
            loading: () => const _ShimmerBoard(),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (data) => _OverallBoard(top3: data.top3, rest: data.rest),
          ),
          lbAsync.when(
            loading: () => const _ShimmerBoard(),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (data) => _ExerciseBoards(exercises: data.exerciseLeaderboards),
          ),
          const _ClubsBoard(),
        ],
      ),
    );
  }
}

class _OverallBoard extends StatelessWidget {
  final List<_Player> top3;
  final List<_Player> rest;
  const _OverallBoard({required this.top3, required this.rest});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Podium
        SliverToBoxAdapter(
          child: _PodiumRow(top3: top3),
        ),
        // Rest of list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final p = rest[i];
              return _PlayerTile(
                rank: 4 + i,
                name: p.name,
                gym: p.gym,
                sessions: p.sessions,
                winRate: p.winRate,
                flex: p.flex,
                isHighlighted: false,
              );
            },
            childCount: rest.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _PodiumRow extends StatelessWidget {
  final List<_Player> top3;
  const _PodiumRow({required this.top3});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(
            child: _PodiumCard(
              rank: 2,
              player: top3[1],
              height: 100,
              color: AppColors.silver,
            ),
          ),
          const SizedBox(width: 8),
          // 1st place
          Expanded(
            child: _PodiumCard(
              rank: 1,
              player: top3[0],
              height: 130,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 8),
          // 3rd place
          Expanded(
            child: _PodiumCard(
              rank: 3,
              player: top3[2],
              height: 80,
              color: AppColors.bronze,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final int rank;
  final _Player player;
  final double height;
  final Color color;
  const _PodiumCard({
    required this.rank, required this.player,
    required this.height, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              player.name[0],
              style: TextStyle(
                color: rank == 1 ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold, fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(player.name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text('${player.winRate.toStringAsFixed(0)}%', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
        const SizedBox(height: 8),
        // Podium block
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.15)],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: color, size: 24),
              const SizedBox(height: 4),
              Text('#$rank', style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final int rank;
  final String name;
  final String gym;
  final int sessions;
  final double winRate;
  final double flex;
  final bool isHighlighted;
  const _PlayerTile({
    required this.rank, required this.name, required this.gym,
    required this.sessions, required this.winRate, required this.flex,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.glassCard(
        color: isHighlighted ? AppColors.surfaceRaised : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#$rank',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceRaised,
            ),
            child: Center(
              child: Text(name[0], style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold,
              )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Text(gym, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${winRate.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary),
              ),
              Text('$sessions sessions', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExerciseBoards extends StatelessWidget {
  final List<_ExerciseBoard> exercises;
  const _ExerciseBoards({required this.exercises});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, i) {
        final board = exercises[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: AppTheme.glassCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    const Icon(Icons.fitness_center, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(board.name, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...board.entries.asMap().entries.map((entry) {
                final idx = entry.key;
                final e = entry.value;
                return _ExerciseRow(rank: idx + 1, entry: e, isTop3: idx < 3);
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final int rank;
  final _ExerciseEntry entry;
  final bool isTop3;
  const _ExerciseRow({required this.rank, required this.entry, required this.isTop3});

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    if (rank == 1) rankColor = AppColors.gold;
    else if (rank == 2) rankColor = AppColors.silver;
    else if (rank == 3) rankColor = AppColors.bronze;
    else rankColor = AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
          Text(entry.name, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            '${entry.weight.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isTop3 ? rankColor : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubsBoard extends StatelessWidget {
  const _ClubsBoard();

  @override
  Widget build(BuildContext context) {
    final clubs = [
      ('Jakarta Padel Club', 3, 89.2),
      ('Surabaya Smashers', 2, 84.1),
      ('Bali Padel', 2, 78.4),
      ('Bandung Breakers', 1, 74.1),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubs.length,
      itemBuilder: (context, i) {
        final club = clubs[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.glassCard(),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.groups, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club.$1, style: Theme.of(context).textTheme.titleMedium),
                    Text('${club.$2} players', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${club.$3.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                  ),
                  Text('avg flex', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBoard extends StatelessWidget {
  const _ShimmerBoard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(height: 130, decoration: BoxDecoration(color: AppColors.surfaceRaised, borderRadius: BorderRadius.circular(16))),
        const SizedBox(height: 16),
        ...List.generate(5, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(height: 72, decoration: BoxDecoration(color: AppColors.surfaceRaised, borderRadius: BorderRadius.circular(16))),
        )),
      ],
    );
  }
}

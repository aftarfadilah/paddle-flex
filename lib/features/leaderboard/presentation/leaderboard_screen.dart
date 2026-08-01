import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

final _mockLeaderboard = [
  ('1', 'Rafa Nadal Jr', 'Jakarta Padel Club', 47, 92.0),
  ('2', 'Ivana Wawrinka', 'Surabaya Smashers', 38, 87.5),
  ('3', 'Budi Djiwandono', 'Bali Padel', 31, 81.0),
  ('4', 'Siti Aminah', 'Jakarta Padel Club', 29, 78.3),
  ('5', 'Andi Wijaya', 'Bandung Breakers', 25, 74.1),
  ('6', 'Dewi Lestari', 'Surabaya Smashers', 22, 71.8),
  ('7', 'Reza Pratama', 'Jakarta Padel Club', 19, 68.5),
  ('8', 'Nia Rahayu', 'Bali Padel', 16, 65.2),
];

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'Wins'),
            Tab(text: 'Win Rate'),
            Tab(text: 'Sessions'),
            Tab(text: 'Streak'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LeaderboardList(data: _mockLeaderboard, sortIndex: 2),
          _LeaderboardList(data: _mockLeaderboard, sortIndex: 3),
          _LeaderboardList(data: _mockLeaderboard, sortIndex: 2),
          _LeaderboardList(data: _mockLeaderboard, sortIndex: 2),
        ],
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<(String, String, String, int, double)> data;
  final int sortIndex;
  const _LeaderboardList({required this.data, required this.sortIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, i) {
        final entry = data[i];
        final rank = i + 1;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: _RankMedal(rank: rank),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primary.withOpacity(0.2),
                  child: Text(entry.$1,
                      style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.$2, style: Theme.of(context).textTheme.titleLarge),
                      Text(entry.$3,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.$5.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.primary),
                    ),
                    Text('${entry.$4} sessions',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RankMedal extends StatelessWidget {
  final int rank;
  const _RankMedal({required this.rank});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData? icon;
    switch (rank) {
      case 1: color = const Color(0xFFFFD700); icon = Icons.emoji_events; break;
      case 2: color = const Color(0xFFC0C0C0); icon = Icons.emoji_events; break;
      case 3: color = const Color(0xFFCD7F32); icon = Icons.emoji_events; break;
      default: color = AppTheme.textSecondary; icon = null;
    }
    if (icon == null) {
      return Text('#$rank',
          style: TextStyle(
              fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary));
    }
    return Icon(icon, color: color, size: 24);
  }
}

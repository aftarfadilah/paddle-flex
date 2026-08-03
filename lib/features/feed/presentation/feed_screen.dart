import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/feed_post_model.dart';
import '../../log_session/data/session_model.dart';
import '../../home/presentation/home_shell.dart';

final feedProvider = FutureProvider<List<FeedPost>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 700));
  return _mockPosts;
});

final _mockPosts = List.generate(8, (i) {
  final durations = [45, 60, 75, 90, 55, 120, 80, 65];
  final flexes    = [94, 87, 72, 63, 81, 55, 78, 91];
  final results   = [SessionResult.win, SessionResult.loss, SessionResult.practice];
  final scores    = ['6-4 3-6 7-5', '4-6 6-3 5-7', ''];
  final created   = DateTime.now().subtract(Duration(hours: i * 2 + (i > 4 ? 12 : 0)));
  return FeedPost(
    id: 'post_$i', userId: 'user_$i', sessionId: 'session_$i',
    createdAt: created, flexFactor: flexes[i], exerciseCount: 3 + (i % 4),
    session: Session(
      id: 'session_$i', userId: 'user_$i', date: created,
      result: results[i % 3], score: scores[i % 3],
      durationMinutes: durations[i],
      likeCount: (i * 7) % 23, commentCount: (i * 3) % 11, createdAt: created,
    ),
  );
});

final _names = [
  'Rafa Nadal Jr', 'Ivana Wawrinka', 'Budi Djiwandono',
  'Siti Aminah', 'Andi Wijaya', 'Dewi Lestari',
  'Reza Pratama', 'Nia Rahayu',
];

// ── Accent palette per user for premium feel ────────────────────────────────
final _avatarGradients = [
  [const Color(0xFF00E5BE), const Color(0xFF00B39A)],
  [const Color(0xFFD4AF37), const Color(0xFFB8960C)],
  [const Color(0xFFFF6B35), const Color(0xFFE05520)],
  [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
  [const Color(0xFFEC4899), const Color(0xFFDB2777)],
  [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
  [const Color(0xFFF59E0B), const Color(0xFFD97706)],
  [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
];

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: feedAsync.when(
        loading: () => const _LuxuryShimmer(),
        error: (e, st) => Center(child: Text('Error: $e', style: AppFonts.body)),
        data: (posts) => posts.isEmpty
            ? _EmptyFeed()
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Premium header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Activity', style: AppFonts.display.copyWith(fontSize: 28)),
                              const SizedBox(height: 2),
                              Text('Recent matches', style: AppFonts.bodySmall),
                            ],
                          ),
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.notifications_outlined,
                                color: AppColors.textSecondary, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // FAB spacer
                  SliverToBoxAdapter(child: const SizedBox(height: 8)),
                  // Post cards
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => StaggeredItem(
                          index: i,
                          child: _LuxuryPostCard(
                            post: posts[i],
                            name: _names[i % _names.length],
                            avatarGradient: _avatarGradients[i % _avatarGradients.length],
                          ),
                        ),
                        childCount: posts.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: PremiumFAB(
        onTap: () => context.go('/log'),
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.sports_tennis, size: 36, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 24),
          Text('No sessions yet', style: AppFonts.headline),
          const SizedBox(height: 8),
          Text('Log your first match to see it here',
              style: AppFonts.bodySmall),
        ],
      ),
    );
  }
}

// ── Luxury Post Card ──────────────────────────────────────────────────────────
class _LuxuryPostCard extends StatefulWidget {
  final FeedPost post;
  final String name;
  final List<Color> avatarGradient;

  const _LuxuryPostCard({
    required this.post, required this.name, required this.avatarGradient,
  });

  @override
  State<_LuxuryPostCard> createState() => _LuxuryPostCardState();
}

class _LuxuryPostCardState extends State<_LuxuryPostCard>
    with SingleTickerProviderStateMixin {
  late bool _liked;
  late int _likeCount;
  late AnimationController _heartCtrl;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.session?.likeCount ?? 0;
    _liked = false;
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() { _heartCtrl.dispose(); super.dispose(); }

  void _handleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
    if (_liked) _heartCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final session  = widget.post.session;
    final result   = session?.result ?? SessionResult.practice;
    final flexColor = widget.post.flexFactor >= 80
        ? AppColors.accent
        : widget.post.flexFactor >= 50
            ? const Color(0xFFFFBE0B)
            : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.glassCard(elevated: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 0),
            child: Row(
              children: [
                // Avatar with gradient ring
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.avatarGradient,
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface),
                    child: Center(
                      child: Text(widget.name[0],
                        style: TextStyle(
                          color: widget.avatarGradient[0],
                          fontWeight: FontWeight.bold, fontSize: 18,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: AppFonts.title),
                      const SizedBox(height: 2),
                      Text(_timeAgo(widget.post.createdAt), style: AppFonts.bodySmall),
                    ],
                  ),
                ),
                _LuxuryResultBadge(result: result),
              ],
            ),
          ),

          // Score (if available)
          if (session?.score.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(session!.score,
                style: AppFonts.mono.copyWith(fontSize: 20, letterSpacing: 2.5, height: 1.2),
              ),
            ),

          // Stats row — premium chips
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              children: [
                _LuxuryChip(
                  icon: Icons.timer_outlined, label: '${session?.durationMinutes ?? 0} min',
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                _LuxuryChip(
                  icon: Icons.local_fire_department,
                  label: 'Flex ${widget.post.flexFactor}',
                  color: flexColor,
                ),
                const SizedBox(width: 8),
                _LuxuryChip(
                  icon: Icons.fitness_center,
                  label: '${widget.post.exerciseCount} sets',
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(height: 0.5, color: AppColors.border),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
            child: Row(
              children: [
                // Like
                GestureDetector(
                  onTap: _handleLike,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        ScaleTransition(
                          scale: _heartScale,
                          child: Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            size: 22,
                            color: _liked ? Colors.red : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text('$_likeCount',
                          style: AppFonts.mono.copyWith(fontSize: 13,
                            color: _liked ? Colors.red : AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Comment
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 7),
                      Text('${session?.commentCount ?? 0}',
                        style: AppFonts.mono.copyWith(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _LuxuryResultBadge extends StatelessWidget {
  final SessionResult result;
  const _LuxuryResultBadge({required this.result});

  Color get _color => switch (result) {
    SessionResult.win => AppColors.accent,
    SessionResult.loss => AppColors.error,
    SessionResult.practice => AppColors.textTertiary,
  };

  String get _label => switch (result) {
    SessionResult.win => 'WIN',
    SessionResult.loss => 'LOSS',
    SessionResult.practice => 'PRACTICE',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.2), width: 0.75),
      ),
      child: Text(_label,
        style: TextStyle(
          color: _color,
          fontFamily: 'Space Grotesk',
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _LuxuryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _LuxuryChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,
              fontFamily: 'Space Grotesk')),
        ],
      ),
    );
  }
}

// ── Luxury shimmer ───────────────────────────────────────────────────────────
class _LuxuryShimmer extends StatelessWidget {
  const _LuxuryShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
      children: [
        ...List.generate(5, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glassCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const ShimmerBox(height: 48, width: 48),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ShimmerBox(height: 14, width: 120),
                    const SizedBox(height: 8),
                    ShimmerBox(height: 12, width: 70),
                  ])),
                ]),
                const SizedBox(height: 16),
                ShimmerBox(height: 20, width: 160),
                const SizedBox(height: 12),
                Row(children: [
                  ShimmerBox(height: 30, width: 80),
                  const SizedBox(width: 8),
                  ShimmerBox(height: 30, width: 80),
                  const SizedBox(width: 8),
                  ShimmerBox(height: 30, width: 70),
                ]),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

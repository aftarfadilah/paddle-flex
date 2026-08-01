import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/feed_post_model.dart';

final feedProvider = FutureProvider<List<FeedPost>>((ref) async {
  // TODO: real Firestore query
  return _mockPosts;
});

final _mockPosts = List.generate(10, (i) => FeedPost(
  id: 'post_$i',
  userId: 'user_$i',
  sessionId: 'session_$i',
  createdAt: DateTime.now().subtract(Duration(hours: i * 2)),
  flexFactor: (i % 3 == 0) ? 92 : 50 + (i * 4),
));

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text('PaddleFlex', style: Theme.of(context).textTheme.displayMedium),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: feedAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (posts) => posts.isEmpty
            ? Center(child: Text('No posts yet. Be the first to log a session!',
                style: TextStyle(color: AppTheme.textSecondary)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, i) => _FeedPostCard(post: posts[i]),
              ),
      ),
    );
  }
}

class _FeedPostCard extends StatefulWidget {
  final FeedPost post;
  const _FeedPostCard({required this.post});

  @override
  State<_FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<_FeedPostCard> {
  bool _liked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.session?.likeCount ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.post.session;
    final flexColor = widget.post.flexFactor >= 80
        ? AppTheme.accent
        : widget.post.flexFactor >= 50
            ? AppTheme.primary
            : AppTheme.textSecondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: AppTheme.primary.withOpacity(0.2),
                    child: Icon(Icons.person, color: AppTheme.primary)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Player ${widget.post.userId.split('_').last}',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(_timeAgo(widget.post.createdAt),
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                _ResultBadge(result: session?.result.name ?? 'practice'),
              ],
            ),
            const SizedBox(height: 12),
            // Score
            if (session?.score.isNotEmpty == true) ...[
              Text(session!.score,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: 'JetBrainsMono', letterSpacing: 2)),
              const SizedBox(height: 8),
            ],
            // Stats row
            Row(
              children: [
                _StatChip(icon: Icons.timer_outlined, label: '${session?.durationMinutes ?? 0} min'),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.local_fire_department,
                  label: 'Flex ${widget.post.flexFactor}',
                  color: flexColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            // Actions
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    _liked = !_liked;
                    _likeCount += _liked ? 1 : -1;
                  }),
                  child: Row(
                    children: [
                      Icon(_liked ? Icons.favorite : Icons.favorite_border,
                          color: _liked ? Colors.red : AppTheme.textSecondary, size: 20),
                      const SizedBox(width: 4),
                      Text('$_likeCount', style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: AppTheme.textSecondary, size: 20),
                    const SizedBox(width: 4),
                    Text('0', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  onPressed: () {},
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ],
        ),
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

class _ResultBadge extends StatelessWidget {
  final String result;
  const _ResultBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (result) {
      case 'win': color = AppTheme.primary; break;
      case 'loss': color = AppTheme.error; break;
      default: color = AppTheme.textSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(result.toUpperCase(),
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _StatChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

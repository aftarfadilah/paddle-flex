
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/strion_light_theme.dart';
import '../../../core/theme/theme_provider.dart';

// ── Convenience color getters that respond to current theme ──────────────────
Color _bg(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.bg : LightTheme.bg;
Color _surface(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.surface : LightTheme.surface;
Color _surfaceMid(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceMid : LightTheme.surfaceMid;
Color _accent(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.accent : LightTheme.accent;
Color _textPrimary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.textPrimary : LightTheme.textPrimary;
Color _textSecondary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.textSecondary : LightTheme.textSecondary;
Color _border(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.border : LightTheme.border;
Color _gold(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.gold : LightTheme.gold;
Color _warning(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.warning : LightTheme.warning;

// ── Mock data ────────────────────────────────────────────────────────────────
const _mockUser = {
  'name': 'Aftar Fadilah',
  'username': '@aftarfdh',
  'sessions': 47,
  'winRate': 68,
  'streak': 12,
  'best': 23,
  'bio': 'Game dev in progress. Every session counts. 🌙',
};

// ── Main Profile Screen ──────────────────────────────────────────────────────
class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late AnimationController _statsCtrl;
  late AnimationController _badgeCtrl;
  late AnimationController _listCtrl;

  // Staggered list items
  final _listItems = <Widget>[];

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.18), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _statsCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _badgeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _listCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _statsCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _badgeCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _listCtrl.forward();
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _statsCtrl.dispose();
    _badgeCtrl.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  void _showAvatarPicker(BuildContext context) {
    final surface = _surface(context);
    final border = _border(context);
    final textPrimary = _textPrimary(context);
    final accent = _accent(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(
                color: border, borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text('Change Avatar', style: AppFonts.title(textPrimary)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (i) {
                  final colors = [
                    AppColors.accent, const Color(0xFFFF6B6B),
                    const Color(0xFFFFBE0B), const Color(0xFF00B39A),
                    const Color(0xFF6C63FF), const Color(0xFFFF6B9D),
                  ];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: surface, shape: BoxShape.circle,
                        border: Border.all(color: border),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: colors[i % colors.length], shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 24),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: _bg(context),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(milliseconds: 800)),
        color: _accent(context),
        backgroundColor: _surface(context),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ── Hero App Bar ─────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: _bg(context),
              elevation: 0,
              leading: FadeTransition(
                opacity: _headerFade,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: _textPrimary(context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                FadeTransition(
                  opacity: _headerFade,
                  child: IconButton(
                    icon: Icon(
                      themeColors.isDark ? Icons.light_mode : Icons.dark_mode,
                      color: _textPrimary(context),
                    ),
                    onPressed: () => themeColors.toggleTheme(),
                  ),
                ),
                if (widget.userId == 'me')
                  FadeTransition(
                    opacity: _headerFade,
                    child: IconButton(
                      icon: Icon(Icons.settings_outlined, color: _textPrimary(context)),
                      onPressed: () {},
                    ),
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: _HeroHeader(
                      userName: _mockUser['name'] as String,
                      userHandle: _mockUser['username'] as String,
                      onAvatarTap: () => _showAvatarPicker(context),
                    ),
                  ),
                ),
              ),
            ),

            // ── Stats Row ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _statsCtrl,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: _StatsRow(statsCtrl: _statsCtrl),
                  ),
                ),
              ),
            ),

            // ── Content List (staggered) ───────────────────────────────
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _listCtrl,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // About card
                        _ContentCard(index: 0, listCtrl: _listCtrl, child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.person_outline, color: _accent(context), size: 18),
                              const SizedBox(width: 6),
                              Text('About', style: AppFonts.title(_textPrimary(context))),
                            ]),
                            const SizedBox(height: 10),
                            Text(_mockUser['bio'] as String,
                                style: AppFonts.body(_textSecondary(context))),
                          ],
                        )),

                        const SizedBox(height: 16),

                        // Achievements
                        _ContentCard(
                          index: 1, listCtrl: _listCtrl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text('Achievements', style: AppFonts.headline(_textPrimary(context))),
                                const Spacer(),
                                Text('2/4', style: AppFonts.mono(_textSecondary(context))),
                              ]),
                              const SizedBox(height: 14),
                              _AchievementRow(badgeCtrl: _badgeCtrl),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Recent Sessions
                        _ContentCard(
                          index: 2, listCtrl: _listCtrl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text('Recent Sessions', style: AppFonts.headline(_textPrimary(context))),
                                const Spacer(),
                                if (widget.userId == 'me')
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.add, color: _accent(context), size: 16),
                                    label: Text('Log', style: AppFonts.body(_accent(context))),
                                  ),
                              ]),
                              const SizedBox(height: 12),
                              _RecentSessionsList(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Quick actions
                        if (widget.userId == 'me')
                          _ContentCard(
                            index: 3, listCtrl: _listCtrl,
                            child: Row(children: [
                              Expanded(child: _QuickActionBtn(
                                icon: Icons.edit_outlined,
                                label: 'Edit Profile',
                                onTap: () {},
                              )),
                              const SizedBox(width: 12),
                              Expanded(child: _QuickActionBtn(
                                icon: Icons.share_outlined,
                                label: 'Share Profile',
                                onTap: () {},
                              )),
                            ]),
                          ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero Header ──────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final String userName, userHandle;
  final VoidCallback onAvatarTap;
  const _HeroHeader({
    required this.userName, required this.userHandle, required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accent(context);
    final bgColor = _bg(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
              : [LightTheme.surfaceMid, LightTheme.bg],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            // Avatar with pulse glow
            GestureDetector(
              onTap: onAvatarTap,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.9, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (_, double scale, child) => Transform.scale(
                  scale: scale,
                  child: child,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [accent, accent.withValues(alpha: 0.7)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.4),
                        blurRadius: 28, offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: bgColor,
                      child: Icon(Icons.person, color: accent, size: 46),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(userName, style: AppFonts.display(_textPrimary(context)).copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(userHandle, style: AppFonts.bodySmall(_textSecondary(context))),
          ],
        ),
      ),
    );
  }
}

// ── Animated Stats Row ───────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final AnimationController statsCtrl;
  const _StatsRow({required this.statsCtrl});

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Sessions', 47, ''),
      ('Win Rate', 68, '%'),
      ('🔥 Streak', 12, ''),
      ('Best', 23, ''),
    ];

    return Row(
      children: stats.asMap().entries.map((entry) {
        final i = entry.key;
        final (label, value, suffix) = entry.value;
        return Expanded(
          child: _StatItem(
            label: label, value: value, suffix: suffix,
            delay: i * 0.12, ctrl: statsCtrl,
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, suffix;
  final int value;
  final double delay;
  final AnimationController ctrl;
  const _StatItem({
    required this.label, required this.suffix, required this.value,
    required this.delay, required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accent(context);
    final surface = _surface(context);
    final border = _border(context);
    final textPrimary = _textPrimary(context);
    final textSecondary = _textSecondary(context);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final raw = (ctrl.value - delay) / (1 - delay * statsRowLen(ctrl, delay));
        final progress = raw.clamp(0.0, 1.0);
        final eased = Curves.easeOutCubic.transform(progress);

        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - eased)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value.toDouble()),
                    duration: Duration(milliseconds: 900 + 80 * statsRowLen(ctrl, delay).toInt()),
                    curve: Curves.easeOutCubic,
                    builder: (_, double v, __) => Text(
                      '${v.round()}$suffix',
                      style: AppFonts.mono(accent).copyWith(
                        fontSize: 17, fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(label, style: AppFonts.bodySmall(textSecondary), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static double statsRowLen(AnimationController ctrl, double delay) {
    return (ctrl.value - delay).clamp(0.0, 1.0);
  }
}

// ── Staggered Content Card ──────────────────────────────────────────────────
class _ContentCard extends StatelessWidget {
  final Widget child;
  final int index;
  final AnimationController listCtrl;
  const _ContentCard({
    required this.child, required this.index,
    required this.listCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final surface = _surface(context);
    final border = _border(context);

    final delay = index * 0.08;

    return AnimatedBuilder(
      animation: listCtrl,
      builder: (_, __) {
        final raw = ((listCtrl.value - delay) / (1.0 - delay * 5)).clamp(0.0, 1.0);
        final eased = Curves.easeOutCubic.transform(raw);

        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - eased)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

// ── Achievement Row ──────────────────────────────────────────────────────────
class _Achievement {
  final IconData icon;
  final String label;
  final bool unlocked;
  final Color color;
  const _Achievement({
    required this.icon, required this.label,
    required this.unlocked, required this.color,
  });
}

class _AchievementRow extends StatelessWidget {
  final AnimationController badgeCtrl;
  const _AchievementRow({required this.badgeCtrl});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _Achievement(icon: Icons.emoji_events, label: 'First Log', unlocked: true, color: _gold(context)),
      _Achievement(icon: Icons.local_fire_department, label: 'On Fire', unlocked: true, color: Colors.orange),
      _Achievement(icon: Icons.star, label: 'Century', unlocked: false, color: _accent(context)),
      _Achievement(icon: Icons.military_tech, label: 'Champion', unlocked: false, color: _gold(context)),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: achievements.asMap().entries.map((entry) {
        final i = entry.key;
        final a = entry.value;
        final delay = i * 0.15;

        return AnimatedBuilder(
          animation: badgeCtrl,
          builder: (_, __) {
            final raw = ((badgeCtrl.value - delay) / (1.0 - delay * 4)).clamp(0.0, 1.0);
            final eased = Curves.elasticOut.transform(raw).clamp(0.0, 1.0);

            final surface = _surface(context);
            final border = _border(context);
            final textSecondary = _textSecondary(context);

            return Opacity(
              opacity: raw.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.7 + (0.3 * eased),
                child: Column(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: a.unlocked
                            ? a.color.withValues(alpha: 0.15)
                            : surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: a.unlocked
                              ? a.color.withValues(alpha: 0.4)
                              : border,
                          width: 1.25,
                        ),
                        boxShadow: a.unlocked
                            ? [BoxShadow(color: a.color.withValues(alpha: 0.25), blurRadius: 14)]
                            : null,
                      ),
                      child: Icon(
                        a.unlocked ? a.icon : Icons.lock,
                        color: a.unlocked ? a.color : textSecondary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(a.label, style: AppFonts.bodySmall(textSecondary)),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

// ── Recent Sessions ─────────────────────────────────────────────────────────
class _RecentSessionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessions = [
      {'date': 'Today', 'result': 'WIN', 'score': '21-14', 'color': _accent(context)},
      {'date': 'Yesterday', 'result': 'LOSS', 'score': '18-21', 'color': Colors.red.shade400},
      {'date': 'Jul 30', 'result': 'WIN', 'score': '21-12', 'color': _accent(context)},
    ];

    final surface = _surface(context);
    final border = _border(context);
    final textSecondary = _textSecondary(context);
    final textPrimary = _textPrimary(context);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: sessions.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final isLast = i == sessions.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (s['color'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      s['result'] as String,
                      style: AppFonts.mono(s['color'] as Color).copyWith(fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s['date'] as String,
                      style: AppFonts.body(textPrimary),
                    ),
                  ),
                  Text(s['score'] as String, style: AppFonts.mono(textSecondary)),
                ]),
              ),
              if (!isLast)
                Divider(height: 1, color: border, indent: 14, endIndent: 14),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Quick Action Button ─────────────────────────────────────────────────────
class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final surface = _surface(context);
    final border = _border(context);
    final accent = _accent(context);
    final textPrimary = _textPrimary(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accent, size: 18),
            const SizedBox(width: 6),
            Text(label, style: AppFonts.body(textPrimary)),
          ],
        ),
      ),
    );
  }
}

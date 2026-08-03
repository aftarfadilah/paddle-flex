import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class HomeShell extends StatefulWidget {
  final Widget child;
  final String location;
  const HomeShell({super.key, required this.child, required this.location});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with TickerProviderStateMixin {
  late final AnimationController _fabCtrl;
  late final Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _fabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _fabScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _fabCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() { _fabCtrl.dispose(); super.dispose(); }

  int _currentIndex(String loc) {
    if (loc.startsWith('/feed'))    return 0;
    if (loc.startsWith('/board'))   return 1;
    if (loc.startsWith('/log'))     return 2;
    if (loc.startsWith('/rank'))   return 3;
    if (loc.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(int index) {
    final routes = ['/feed', '/board', '/log', '/rank', '/profile/u1'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(widget.location);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: widget.child,
      extendBody: true,
      bottomNavigationBar: _PremiumNavBar(
        currentIndex: idx,
        onTap: _onTap,
        fabScale: _fabScale,
        fabCtrl: _fabCtrl,
      ),
    );
  }
}

// ── Premium Glass Nav Bar ────────────────────────────────────────────────────
class _PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final Animation<double> fabScale;
  final AnimationController fabCtrl;

  const _PremiumNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.fabScale,
    required this.fabCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.82),
        border: const Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Feed',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.leaderboard_rounded,
                label: 'Board',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              // FAB spacer
              const SizedBox(width: 52),
              _NavItem(
                icon: Icons.emoji_events_rounded,
                label: 'Rank',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.isActive) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, c) => Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? AppColors.accent.withValues(alpha: _fade.value * 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: widget.isActive
                        ? AppColors.accent
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedBuilder(
              animation: _fade,
              builder: (_, c) => Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 10,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  color: Color.lerp(
                    AppColors.textSecondary,
                    AppColors.accent,
                    _fade.value,
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

// ── Premium FAB ───────────────────────────────────────────────────────────────
class PremiumFAB extends StatelessWidget {
  final VoidCallback onTap;
  const PremiumFAB({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.2),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}

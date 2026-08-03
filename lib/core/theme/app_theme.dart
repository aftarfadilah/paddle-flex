import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ── Luxury App Colors ──────────────────────────────────────────────────────────
/// A restrained, premium palette: deep blacks, warm off-whites,
/// a single neon-teal accent, and a champagne-gold for victories.
class AppColors {
  // Backgrounds
  static const bg           = Color(0xFF08080C);  // near-black with blue tint
  static const surface      = Color(0xFF0F0F16);  // card surface
  static const surfaceMid   = Color(0xFF16161F);  // elevated card
  static const surfaceHigh  = Color(0xFF1E1E2A);  // modal / sheet

  // Accent — single neon teal for all interactive highlights
  static const accent       = Color(0xFF00E5BE);
  static const accentDim    = Color(0xFF00B39A);
  static const accentGhost  = Color(0xFF00E5BE);  // ghost text only

  // Victory gold — for wins, podiums, achievements
  static const gold         = Color(0xFFD4AF37);
  static const goldLight    = Color(0xFFE8C547);
  static const goldGhost    = Color(0xFFD4AF37);

  // Text
  static const textPrimary   = Color(0xFFF5F5F7);
  static const textSecondary = Color(0xFF8A8A9A);
  static const textTertiary  = Color(0xFF4A4A5A);
  static const textDisabled  = Color(0xFF2A2A35);

  // Borders
  static const border        = Color(0xFF1E1E2A);
  static const borderLight   = Color(0xFF2A2A38);

  // Semantic
  static const error         = Color(0xFFFF4757);
  static const success       = Color(0xFF00E5BE);  // same as accent
  static const warning       = Color(0xFFFFBE0B);

  // Gradients
  static const accentGradient = LinearGradient(
    colors: [Color(0xFF00E5BE), Color(0xFF00B39A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const goldGradient = LinearGradient(
    colors: [Color(0xFFE8C547), Color(0xFFD4AF37)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E1E2A), Color(0xFF13131C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ── Typography ────────────────────────────────────────────────────────────────
class AppFonts {
  static const _displayFamily = 'Space Grotesk';
  static const _bodyFamily    = 'Inter';
  static const _monoFamily   = 'JetBrains Mono';

  static const display = const TextStyle(
    fontFamily: 'Space Grotesk',
    fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );
  static const headline = const TextStyle(
    fontFamily: 'Space Grotesk',
    fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );
  static const title = const TextStyle(
    fontFamily: 'Space Grotesk',
    fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const body = const TextStyle(
    fontFamily: _bodyFamily,
    fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const bodySmall = const TextStyle(
    fontFamily: _bodyFamily,
    fontFamilyFallback: ['sans-serif'],
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const mono = const TextStyle(
    fontFamily: _monoFamily,
    fontFamilyFallback: ['monospace'],
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}

// ── Theme Data ────────────────────────────────────────────────────────────────
class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.gold,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge:  AppFonts.display.copyWith(fontSize: 32),
      displayMedium: AppFonts.display.copyWith(fontSize: 26),
      displaySmall:  AppFonts.headline.copyWith(fontSize: 20),
      headlineMedium: AppFonts.headline.copyWith(fontSize: 18),
      titleLarge:    AppFonts.title.copyWith(fontSize: 16),
      titleMedium:   AppFonts.title.copyWith(fontSize: 14),
      bodyLarge:     AppFonts.body.copyWith(fontSize: 16),
      bodyMedium:    AppFonts.body.copyWith(fontSize: 14),
      bodySmall:    AppFonts.bodySmall.copyWith(fontSize: 12),
      labelLarge:   AppFonts.mono.copyWith(fontSize: 14),
      labelMedium:  AppFonts.mono.copyWith(fontSize: 12),
      labelSmall:   AppFonts.mono.copyWith(fontSize: 10, letterSpacing: 1),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Space Grotesk',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border, width: 0.75),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppFonts.title.copyWith(fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 0.75,
      space: 1,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.accent,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.accent,
      dividerColor: Colors.transparent,
      labelStyle: AppFonts.title.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppFonts.title.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.accent, width: 2.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
      ),
    ),
  );

  // ── Backward-compat color redirects ──────────────────────────────────────
  static const Color bg              = AppColors.bg;
  static const Color surface          = AppColors.surface;
  static const Color surfaceRaised    = AppColors.surfaceMid;
  static const Color surfaceHover     = AppColors.surfaceHigh;
  static const Color primary         = AppColors.accent;
  static const Color primaryDark     = AppColors.accentDim;
  static const Color accent          = AppColors.accent;
  static const Color accentDark      = AppColors.accentDim;
  static const Color warning         = AppColors.warning;
  static const Color textPrimary     = AppColors.textPrimary;
  static const Color textSecondary   = AppColors.textSecondary;
  static const Color textTertiary    = AppColors.textTertiary;
  static const Color border          = AppColors.border;
  static const Color error           = AppColors.error;
  static const Color success         = AppColors.success;
  static const Color gold            = AppColors.gold;
  static const Color silver          = Color(0xFFB8B8C8);
  static const Color bronze          = Color(0xFFCD7F32);

  // ── Premium Decorations ────────────────────────────────────────────────────

  /// Subtle glass surface — used for cards and nav
  static BoxDecoration glassCard({
    Color? color,
    double radius = 20,
    double borderOpacity = 0.06,
    bool elevated = false,
  }) =>
    BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: AppColors.accent.withValues(alpha: borderOpacity),
        width: 0.75,
      ),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );

  /// Glowing accent border for active/selected states
  static BoxDecoration accentGlow({double radius = 12}) => BoxDecoration(
    color: AppColors.accent.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: AppColors.accent.withValues(alpha: 0.3),
      width: 1,
    ),
  );

  /// Premium shimmer gradient for loading skeletons
  static List<BoxShadow> shimmer({Color? base}) => [
    BoxShadow(
      color: (base ?? AppColors.surface).withValues(alpha: 0.4),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

// ── Custom Page Route — Luxury Slide + Fade ───────────────────────────────────
class LuxuryPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  LuxuryPageRoute({required this.page})
    : super(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );
}

// ── Spring Curve ──────────────────────────────────────────────────────────────
class SpringCurve extends Curve {
  final double damping;
  final double stiffness;
  const SpringCurve({
    this.damping = 0.75,
    this.stiffness = 200,
  });
  @override
  double transformInternal(double t) {
    final omega = stiffness.clamp(1, 500) / 100;
    return 1 - (1 + damping * t * omega).clamp(0, 1) *
           _exp(-omega * t * 10);
  }
  double _exp(double x) {
    x = x.clamp(-20, 20);
    return (x > 0) ? (1 + x + x*x/2) : 1 / (1 - x + x*x/2);
  }
}

// ── Luxury Bounce Scale ──────────────────────────────────────────────────────
class LuxuryScale extends StatefulWidget {
  final Widget child;
  final bool active;
  final VoidCallback? onTap;
  const LuxuryScale({
    super.key,
    required this.child,
    this.active = false,
    this.onTap,
  });

  @override
  State<LuxuryScale> createState() => _LuxuryScaleState();
}

class _LuxuryScaleState extends State<LuxuryScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:  (_) => _ctrl.forward(),
      onTapUp:    (_) { _ctrl.reverse(); widget.onTap?.call(); },
      onTapCancel:() => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, c) => Transform.scale(scale: _scale.value, child: c),
        child: widget.child,
      ),
    );
  }
}

// ── Staggered List Item ──────────────────────────────────────────────────────
class StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay * widget.index, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ── Animated Counter ──────────────────────────────────────────────────────────
class AnimatedCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String suffix;
  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1400),
    this.suffix = '',
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _anim = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
      );
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, c) => Text(
        '${_anim.value.round()}${widget.suffix}',
        style: widget.style,
      ),
    );
  }
}

// ── Shimmer Skeleton ──────────────────────────────────────────────────────────
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 12,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, c) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surfaceMid.withValues(alpha: 0.6),
              AppColors.surface,
            ],
            stops: [
              0,
              _ctrl.value,
              1,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}

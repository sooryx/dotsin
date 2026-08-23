import 'package:flutter/material.dart';

/// Holographic base plate with a slow shimmer so the organ appears to hover.
class HoloPedestal extends StatefulWidget {
  const HoloPedestal({
    super.key,
    this.asset = 'assets/images/heroes/pedestal_cut.png',
  });

  final String asset;

  @override
  State<HoloPedestal> createState() => _HoloPedestalState();
}

class _HoloPedestalState extends State<HoloPedestal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_c.value);
          return Opacity(
            opacity: 0.88 + 0.12 * t,
            child: Transform.scale(scale: 0.995 + 0.005 * t, child: child),
          );
        },
        child: Image.asset(
          widget.asset,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Organ / body artwork with an entrance rise and a slow ambient float.
class HeroArt extends StatefulWidget {
  const HeroArt({
    super.key,
    required this.asset,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final BoxFit fit;

  @override
  State<HeroArt> createState() => _HeroArtState();
}

class _HeroArtState extends State<HeroArt> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  )..forward();

  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void didUpdateWidget(HeroArt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) _enter.forward(from: 0);
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([_enter, _float]),
        builder: (context, child) {
          final e = Curves.easeOutCubic.transform(_enter.value);
          final f = Curves.easeInOut.transform(_float.value);
          return Opacity(
            opacity: e,
            child: Transform.translate(
              offset: Offset(0, (1 - e) * 14 - f * 3),
              child: Transform.scale(scale: 0.96 + 0.04 * e, child: child),
            ),
          );
        },
        child: Image.asset(
          widget.asset,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

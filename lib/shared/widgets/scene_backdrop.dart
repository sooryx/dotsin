import 'package:flutter/material.dart';

/// Per-screen ambient palette from Figma Part A frames.
///
/// - [green] — Phenotype hub, Heart, Blood Metrics
/// - [amber] — Mentzer / metric details, Lungs & amber organs
/// - [red] — Intestine / critical organ frames
enum SceneTone { green, amber, red }

extension SceneToneX on SceneTone {
  static SceneTone fromName(String? name) => switch (name) {
        'amber' => SceneTone.amber,
        'red' => SceneTone.red,
        _ => SceneTone.green,
      };
}

class _Ambience {
  const _Ambience({
    required this.soft,
    required this.softDeep,
    required this.hero,
    required this.cornerHot,
    required this.cornerMid,
  });

  final Color soft;
  final Color softDeep;
  final Color hero;
  final Color cornerHot;
  final Color cornerMid;

  static const green = _Ambience(
    soft: Color(0xFF0A2E12),
    softDeep: Color(0xFF041A09),
    hero: Color(0xFF0E3D16),
    cornerHot: Color(0xFF71FF3E),
    cornerMid: Color(0xFF1FCB4F),
  );

  static const amber = _Ambience(
    soft: Color(0xFF3A2808),
    softDeep: Color(0xFF1A1205),
    hero: Color(0xFF5A3A0C),
    cornerHot: Color(0xFFFFC14D),
    cornerMid: Color(0xFFEE9A29),
  );

  static const red = _Ambience(
    soft: Color(0xFF2A080C),
    softDeep: Color(0xFF140406),
    hero: Color(0xFF4A1018),
    cornerHot: Color(0xFFFF5A3D),
    cornerMid: Color(0xFFEE2929),
  );

  static _Ambience of(SceneTone tone) => switch (tone) {
        SceneTone.green => green,
        SceneTone.amber => amber,
        SceneTone.red => red,
      };
}

/// Soft multi-layer scene lighting (painted, not a stretched raster).
///
/// Layers match Figma frame fills:
/// 1. near-black base
/// 2. large soft upper wash
/// 3. mid hero bloom behind body/organ art
/// 4. elongated bottom-left edge glow
class SceneBackdrop extends StatelessWidget {
  const SceneBackdrop({
    super.key,
    this.tone = SceneTone.green,
    this.heroCenter = const Offset(0.5, 0.22),
  });

  final SceneTone tone;

  /// Fractional centre of the mid-frame bloom (0–1 in frame space).
  final Offset heroCenter;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _SceneLightingPainter(
          tone: tone,
          heroCenter: heroCenter,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SceneLightingPainter extends CustomPainter {
  const _SceneLightingPainter({
    required this.tone,
    required this.heroCenter,
  });

  final SceneTone tone;
  final Offset heroCenter;

  @override
  void paint(Canvas canvas, Size size) {
    final a = _Ambience.of(tone);
    final full = Offset.zero & size;
    canvas.drawRect(full, Paint()..color = const Color(0xFF000000));

    // Soft field wash — wide, low-contrast.
    _ellipseGlow(
      canvas,
      center: Offset(size.width * 0.42, size.height * 0.08),
      radiusX: size.width * 1.15,
      radiusY: size.height * 0.42,
      colors: [
        a.soft.withValues(alpha: 0.55),
        a.softDeep.withValues(alpha: 0.28),
        const Color(0x00000000),
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    // Muted top veil so the upper half never reads pure black.
    canvas.drawRect(
      full,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            a.softDeep.withValues(alpha: 0.45),
            a.softDeep.withValues(alpha: 0.12),
            const Color(0x00000000),
          ],
          stops: const [0.0, 0.22, 0.55],
        ).createShader(full),
    );

    // Hero bloom behind body / organ art.
    final heroR = size.width * 0.95;
    _ellipseGlow(
      canvas,
      center: Offset(size.width * heroCenter.dx, size.height * heroCenter.dy),
      radiusX: heroR,
      radiusY: heroR,
      colors: [
        a.hero.withValues(alpha: 0.50),
        a.hero.withValues(alpha: 0.18),
        const Color(0x00000000),
      ],
      stops: const [0.0, 0.4, 1.0],
    );

    // Bottom-left glowing ribbon — elliptical, outside the corner.
    _ellipseGlow(
      canvas,
      center: Offset(size.width * -0.08, size.height * 1.02),
      radiusX: size.width * 0.95,
      radiusY: size.width * 0.55,
      colors: [
        a.cornerHot.withValues(alpha: 0.42),
        a.cornerMid.withValues(alpha: 0.22),
        a.cornerMid.withValues(alpha: 0.06),
        const Color(0x00000000),
      ],
      stops: const [0.0, 0.28, 0.55, 1.0],
    );

    // Hotter core so the edge reads as a light source.
    _ellipseGlow(
      canvas,
      center: Offset(size.width * 0.02, size.height * 0.995),
      radiusX: size.width * 0.42,
      radiusY: size.width * 0.14,
      colors: [
        a.cornerHot.withValues(alpha: 0.55),
        a.cornerHot.withValues(alpha: 0.12),
        const Color(0x00000000),
      ],
      stops: const [0.0, 0.4, 1.0],
    );
  }

  void _ellipseGlow(
    Canvas canvas, {
    required Offset center,
    required double radiusX,
    required double radiusY,
    required List<Color> colors,
    required List<double> stops,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, radiusY / radiusX);
    canvas.drawCircle(
      Offset.zero,
      radiusX,
      Paint()
        ..shader = RadialGradient(
          colors: colors,
          stops: stops,
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radiusX)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SceneLightingPainter old) =>
      old.tone != tone || old.heroCenter != heroCenter;
}

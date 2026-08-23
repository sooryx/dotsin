import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One coherent palette per dial. Roles:
/// - [ring] — outer glow + thick track
/// - [progressStart]/[progressEnd] — filled value arc
/// - [dashOuter]/[dashInner] — decorative HUD rings (must harmonize with [ring])
/// - [accent] — highlighted scale label ("40") + related accents
class GaugePalette {
  const GaugePalette({
    required this.ring,
    required this.progressStart,
    required this.progressEnd,
    required this.dashOuter,
    required this.dashInner,
    required this.accent,
  });

  final Color ring;
  final Color progressStart;
  final Color progressEnd;
  final Color dashOuter;
  final Color dashInner;
  final Color accent;

  /// Immune dial (Figma hub): red track + warm fill, coral HUD (no cyan).
  static const immune = GaugePalette(
    ring: Color(0xFFB0203A),
    progressStart: Color(0xFFFF7A18),
    progressEnd: Color(0xFFFF2D0F),
    dashOuter: Color(0xFFFF8A7A),
    dashInner: Color(0xFFFF5C4D),
    accent: Color(0xFFFF8A65),
  );

  /// Heart / healthy organ: green track + lime fill, mint dashes.
  static const green = GaugePalette(
    ring: Color(0xFF1FCB4F),
    progressStart: Color(0xFF4BFF0A),
    progressEnd: Color(0xFFB6F52A),
    dashOuter: Color(0xFF7DFFB0),
    dashInner: Color(0xFF3DFF9A),
    accent: Color(0xFF08FC49),
  );

  /// Lungs / caution: amber track + warm fill, soft gold dashes.
  static const amber = GaugePalette(
    ring: Color(0xFFEE9A29),
    progressStart: Color(0xFFFFC14D),
    progressEnd: Color(0xFFFF7A18),
    dashOuter: Color(0xFFFFD27A),
    dashInner: Color(0xFFFFB84D),
    accent: Color(0xFFFFDB5A),
  );

  /// Critical: red track + hot fill, soft coral dashes (no cyan clash).
  static const red = GaugePalette(
    ring: Color(0xFFEE2929),
    progressStart: Color(0xFFFF6A3D),
    progressEnd: Color(0xFFFF1F0A),
    dashOuter: Color(0xFFFF8A7A),
    dashInner: Color(0xFFFF5C4D),
    accent: Color(0xFFFF8A65),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GaugePalette &&
          ring == other.ring &&
          progressStart == other.progressStart &&
          progressEnd == other.progressEnd &&
          dashOuter == other.dashOuter &&
          dashInner == other.dashInner &&
          accent == other.accent;

  @override
  int get hashCode => Object.hash(ring, progressStart, progressEnd, dashOuter, dashInner, accent);
}

/// Radial health gauge — Figma dial frame is **236.79 × 235.76**.
///
/// Colour roles come from [GaugePalette] so immune / heart / lung dials stay
/// coherent (no cyan HUD dashes fighting a green or amber ring).
class HealthGaugePainter extends CustomPainter {
  HealthGaugePainter({
    required this.value,
    required this.progress,
    required this.palette,
  });

  final double value;
  final double progress;
  final GaugePalette palette;

  /// Matches the Swift/Figma export: `width: 236.79, height: 235.76`.
  static const designWidth = 236.79;
  static const designHeight = 235.76;

  /// Optical centre of the dial inside that frame.
  static const _center = Offset(118.4, 113.5);
  static const _startDeg = 118.0;
  static const _sweepDeg = 304.0;

  // Radii fitted so the outer ring sits just inside the 236.79 frame.
  static const _outerR = 112.0;
  static const _dashOuterR = 101.0;
  static const _dashInnerR = 91.0;
  static const _bandR = 82.0;
  static const _progressInnerR = 75.0;
  static const _progressOuterR = 88.0;
  static const _innerDiscR = 71.0;
  /// Tip sits in the progress band; base stays outside the centre %.
  static const _needleInnerR = 48.0;
  static const _needleR = 90.0;

  double get _valueAngle =>
      (_startDeg + _sweepDeg * (value / 100).clamp(0.0, 1.0) * progress) * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / designWidth;
    final sy = size.height / designHeight;
    canvas.save();
    canvas.scale(sx, sy);

    _outerGlow(canvas);
    _baseDisc(canvas);
    _dashedRings(canvas);
    _hudColorOverlay(canvas);
    _ringBand(canvas);
    _progressDashes(canvas);
    _innerDisc(canvas);
    _needle(canvas);
    _topMarker(canvas);
    _scaleLabels(canvas);

    canvas.restore();
  }

  /// Soft themed wash over the progress dashed HUD only (not the full circle).
  void _hudColorOverlay(Canvas canvas) {
    final start = _startDeg * math.pi / 180;
    final sweep = (_valueAngle - start).clamp(0.0, _sweepDeg * math.pi / 180);
    if (sweep <= 0) return;

    final midR = (_progressInnerR + _progressOuterR) / 2;
    final bandRect = Rect.fromCircle(center: _center, radius: midR);
    final strokeW = (_progressOuterR - _progressInnerR) + 22;

    // Soft blurred glow under/over the progress dashes.
    canvas.drawArc(
      bandRect,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW + 10
        ..strokeCap = StrokeCap.round
        ..color = palette.ring.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Brighter glass fill along the same arc as the progress dashes.
    canvas.drawArc(
      bandRect,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt
        ..shader = SweepGradient(
          startAngle: start,
          endAngle: start + sweep,
          colors: [
            palette.progressStart.withValues(alpha: 0.28),
            palette.ring.withValues(alpha: 0.20),
            palette.progressEnd.withValues(alpha: 0.16),
          ],
          stops: const [0.0, 0.55, 1.0],
          transform: GradientRotation(start),
        ).createShader(bandRect)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  void _outerGlow(Canvas canvas) {
    canvas.drawCircle(
      _center,
      _outerR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = palette.ring.withValues(alpha: 0.75)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.5),
    );
    canvas.drawCircle(
      _center,
      _outerR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = palette.ring.withValues(alpha: 0.9),
    );
  }

  void _baseDisc(Canvas canvas) {
    canvas.drawCircle(
      _center,
      _outerR - 1.5,
      Paint()..color = const Color(0xFF161720),
    );
  }

  /// Decorative HUD rings — tinted from the palette so they never clash with
  /// the themed outer ring.
  void _dashedRings(Canvas canvas) {
    _dashedCircle(
      canvas,
      radius: _dashOuterR,
      strokeWidth: 2.2,
      color: palette.dashOuter.withValues(alpha: 0.85),
      dashLength: 5.5,
      gapLength: 4,
    );
    _dashedCircle(
      canvas,
      radius: _dashInnerR,
      strokeWidth: 4.0,
      color: palette.dashInner.withValues(alpha: 0.75),
      dashLength: 7,
      gapLength: 4.5,
    );
  }

  void _dashedCircle(
    Canvas canvas, {
    required double radius,
    required double strokeWidth,
    required Color color,
    required double dashLength,
    required double gapLength,
  }) {
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor().clamp(1, 1000);
    final anglePerDash = 2 * math.pi / dashCount;
    final dashAngleFraction = dashLength / (dashLength + gapLength);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = color;
    final rect = Rect.fromCircle(center: _center, radius: radius);
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(
        rect,
        i * anglePerDash,
        anglePerDash * dashAngleFraction,
        false,
        paint,
      );
    }
  }

  /// Muted track behind the value arc — darker than progress so fill stays clear.
  void _ringBand(Canvas canvas) {
    final rect = Rect.fromCircle(center: _center, radius: _bandR);
    canvas.drawArc(
      rect,
      _startDeg * math.pi / 180,
      _sweepDeg * math.pi / 180,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..shader = SweepGradient(
          startAngle: _startDeg * math.pi / 180,
          endAngle: (_startDeg + _sweepDeg) * math.pi / 180,
          colors: [
            palette.ring.withValues(alpha: 0.55),
            palette.ring.withValues(alpha: 0.22),
            palette.ring.withValues(alpha: 0.12),
            palette.ring.withValues(alpha: 0.35),
          ],
          stops: const [0.0, 0.35, 0.65, 1.0],
          transform: GradientRotation(_startDeg * math.pi / 180),
        ).createShader(rect),
    );
  }

  void _progressDashes(Canvas canvas) {
    final endAngle = _valueAngle;
    const step = 3.2;
    for (var deg = _startDeg; deg <= endAngle * 180 / math.pi; deg += step) {
      final a = deg * math.pi / 180;
      final t = ((deg - _startDeg) / _sweepDeg).clamp(0.0, 1.0);
      final color = Color.lerp(palette.progressStart, palette.progressEnd, t)!;
      canvas.drawLine(
        _polar(a, _progressInnerR),
        _polar(a, _progressOuterR),
        Paint()
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.1),
      );
    }
  }

  void _innerDisc(Canvas canvas) {
    canvas.drawCircle(
      _center,
      _innerDiscR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.4),
          colors: [
            const Color(0xFF1A1A1F),
            const Color(0xFF0A0A0C),
            Colors.black,
          ],
        ).createShader(Rect.fromCircle(center: _center, radius: _innerDiscR)),
    );
    canvas.drawCircle(
      _center,
      _innerDiscR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withValues(alpha: 0.06),
    );
  }

  void _needle(Canvas canvas) {
    final a = _valueAngle;
    final direction = Offset(math.cos(a), math.sin(a));
    final perpendicular = Offset(-direction.dy, direction.dx);

    // Squarish taper: flat base → flat tip (sharp corners, no round hub).
    const baseHalfW = 2.8;
    const tipHalfW = 0.7;
    final base = _polar(a, _needleInnerR);
    final tip = _polar(a, _needleR);

    final path = Path()
      ..moveTo(
        base.dx + perpendicular.dx * baseHalfW,
        base.dy + perpendicular.dy * baseHalfW,
      )
      ..lineTo(
        tip.dx + perpendicular.dx * tipHalfW,
        tip.dy + perpendicular.dy * tipHalfW,
      )
      ..lineTo(
        tip.dx - perpendicular.dx * tipHalfW,
        tip.dy - perpendicular.dy * tipHalfW,
      )
      ..lineTo(
        base.dx - perpendicular.dx * baseHalfW,
        base.dy - perpendicular.dy * baseHalfW,
      )
      ..close();

    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  void _topMarker(Canvas canvas) {
    // Tip of the dial, just above the "40" label.
    const c = Offset(118.4, 14.5);
    final path = Path()
      ..moveTo(c.dx, c.dy + 5.0)
      ..lineTo(c.dx - 4.8, c.dy - 5.0)
      ..lineTo(c.dx + 4.8, c.dy - 5.0)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [palette.accent, palette.dashOuter],
        ).createShader(path.getBounds()),
    );
  }

  void _scaleLabels(Canvas canvas) {
    // Local to the 236.79×235.76 frame (Figma absolute − dial origin).
    final labels = <({String text, Offset at, double rotation, double size, Color color})>[
      (text: '40', at: const Offset(118.4, 28.5), rotation: 0, size: 8.9, color: palette.accent),
      (text: '20', at: const Offset(28.8, 108.0), rotation: 0, size: 8.4, color: Colors.white),
      (text: '60', at: const Offset(206.2, 108.0), rotation: 0, size: 8.4, color: Colors.white),
      (text: '0', at: const Offset(68.6, 206.4), rotation: math.pi / 6, size: 8.4, color: Colors.white),
      (text: '80', at: const Offset(169.5, 207.8), rotation: -math.pi / 6, size: 8.4, color: Colors.white),
    ];

    for (final label in labels) {
      final tp = TextPainter(
        text: TextSpan(
          text: label.text,
          style: TextStyle(
            color: label.color,
            fontSize: label.size,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(label.at.dx, label.at.dy);
      canvas.rotate(label.rotation);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  Offset _polar(double angle, double radius) => Offset(
        _center.dx + math.cos(angle) * radius,
        _center.dy + math.sin(angle) * radius,
      );

  @override
  bool shouldRepaint(covariant HealthGaugePainter old) =>
      old.value != value || old.progress != progress || old.palette != palette;
}

/// Six-band semicircular gauge used on the metric details screen (node 3:6100).
class RangeGaugePainter extends CustomPainter {
  RangeGaugePainter({
    required this.needlePercent,
    required this.progress,
    required this.bands,
  });

  final double needlePercent;
  final double progress;
  final List<Color> bands;

  static const _labels = ['VERY LOW', 'LOW', 'MODERATE', 'OPTIMAL', 'HIGH', 'VERY HIGH'];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.86);
    final radius = size.width * 0.40;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = math.pi;
    const total = math.pi;
    final seg = total / bands.length;

    for (var i = 0; i < bands.length; i++) {
      canvas.drawArc(
        rect,
        start + seg * i + 0.012,
        seg * 0.965 * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.34
          ..color = bands[i],
      );
    }

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < _labels.length; i++) {
      final a = start + seg * (i + 0.5);
      final pos = Offset(
        center.dx + math.cos(a) * radius,
        center.dy + math.sin(a) * radius,
      );
      tp.text = TextSpan(
        text: _labels[i],
        style: const TextStyle(
          color: Color(0xCC101010),
          fontSize: 6.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      );
      tp.layout();
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(a + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    final needleAngle = start + total * needlePercent.clamp(0.0, 1.0) * progress;
    final tip = Offset(
      center.dx + math.cos(needleAngle) * (radius * 0.92),
      center.dy + math.sin(needleAngle) * (radius * 0.92),
    );
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = const Color(0xFF4A4A4A)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 9, Paint()..color = Colors.white);
    canvas.drawCircle(center, 4.5, Paint()..color = const Color(0xFF2B2B2B));
  }

  @override
  bool shouldRepaint(covariant RangeGaugePainter old) =>
      old.needlePercent != needlePercent || old.progress != progress;
}

/// Radial score ring for the "Hyperprolactinemia Score" card (node 3:6486).
class ScoreArcPainter extends CustomPainter {
  ScoreArcPainter({required this.percent, required this.progress});

  final double percent;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.42;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF1B2A4A),
    );

    canvas.drawArc(
      rect,
      math.pi,
      math.pi * (percent / 100).clamp(0.0, 1.0) * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          colors: [Color(0xFF2CD9FF), Color(0xFF4B7BFF)],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant ScoreArcPainter old) =>
      old.percent != percent || old.progress != progress;
}

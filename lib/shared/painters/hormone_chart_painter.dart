import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/health_models.dart';

/// Hormone-level spline for the chart card (node 3:6399).
///
/// Draws the Catmull-Rom smoothed curve with the design's green→amber→red
/// horizontal gradient, glow pass and cyan vertex dots. Values are in the
/// design's own axis space (x: 0–120, y: 50–100).
class HormoneChartPainter extends CustomPainter {
  HormoneChartPainter({
    required this.points,
    required this.progress,
  });

  final List<ChartPoint> points;
  final double progress;

  static const _minX = 0.0;
  static const _maxX = 120.0;
  static const _minY = 50.0;
  static const _maxY = 100.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    Offset map(ChartPoint p) => Offset(
          (p.x - _minX) / (_maxX - _minX) * size.width,
          size.height - (p.y - _minY) / (_maxY - _minY) * size.height,
        );

    final pts = points.map(map).toList();
    final path = _spline(pts);
    final metrics = path.computeMetrics().toList();
    final total = metrics.fold<double>(0, (sum, m) => sum + m.length);
    final visible = _extract(path, total * progress.clamp(0.0, 1.0));

    final shader = const LinearGradient(
      colors: [
        Color(0xFF4BFF0A),
        Color(0xFFB6F52A),
        Color(0xFFF0A020),
        Color(0xFFFF3B1F),
      ],
      stops: [0.0, 0.34, 0.66, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(
      visible,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round
        ..shader = shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawPath(
      visible,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = shader,
    );

    final shown = (pts.length * progress).ceil().clamp(0, pts.length);
    for (var i = 0; i < shown; i++) {
      if (!points[i].dot) continue;
      canvas.drawCircle(
        pts[i],
        2.5,
        Paint()
          ..color = const Color(0xFF73FCFD)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawCircle(pts[i], 2.5, Paint()..color = const Color(0xFF73FCFD));
    }
  }

  Path _spline(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final p0 = i == 0 ? pts[i] : pts[i - 1];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i + 2 < pts.length ? pts[i + 2] : p2;
      final c1 = Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
      final c2 = Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  Path _extract(Path source, double length) {
    final out = Path();
    var remaining = length;
    for (final metric in source.computeMetrics()) {
      if (remaining <= 0) break;
      final take = math.min(remaining, metric.length);
      out.addPath(metric.extractPath(0, take), Offset.zero);
      remaining -= take;
    }
    return out;
  }

  @override
  bool shouldRepaint(covariant HormoneChartPainter old) =>
      old.progress != progress || old.points != points;
}

/// Faint plot grid behind the curve.
class ChartGridPainter extends CustomPainter {
  const ChartGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 0.6;
    for (var i = 0; i <= 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (var i = 0; i <= 6; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ChartGridPainter oldDelegate) => false;
}

/// White dashed reference line (node 3:6426).
class DashedLinePainter extends CustomPainter {
  const DashedLinePainter({this.dash = 4, this.gap = 4, this.color = Colors.white});

  final double dash;
  final double gap;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 0.8;
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(Offset(x, 0), Offset(math.min(x + dash, size.width), 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}

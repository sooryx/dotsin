import 'package:flutter/material.dart';

import '../../core/app_text.dart';
import '../painters/gauge_painter.dart';

enum GaugeTheme { immune, green, amber, red }

GaugeTheme gaugeThemeFromName(String name) => switch (name) {
      'amber' => GaugeTheme.amber,
      'red' => GaugeTheme.red,
      _ => GaugeTheme.green,
    };

/// Animated radial dial.
///
/// Figma frame (Swift export):
/// ```
/// width  236.79
/// height 235.76
/// centerX = parent.centerX - 0.61
/// top    = 598   (organ frames) / 1270 (hub immune)
/// ```
class HealthGauge extends StatefulWidget {
  const HealthGauge({
    super.key,
    required this.value,
    this.theme = GaugeTheme.immune,
    this.width = designWidth,
    this.height = designHeight,
  });

  /// Exact Figma dial bounds from the iOS layout export.
  static const designWidth = 236.79;
  static const designHeight = 235.76;

  /// Horizontal inset on a 402-wide canvas so `centerX = 201 - 0.61`.
  static double leftOnCanvas({double canvasWidth = 402}) =>
      (canvasWidth - designWidth) / 2 - 0.61;

  final double value;
  final GaugeTheme theme;
  final double width;
  final double height;

  @override
  State<HealthGauge> createState() => _HealthGaugeState();
}

class _HealthGaugeState extends State<HealthGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  GaugePalette get _palette => switch (widget.theme) {
        GaugeTheme.immune => GaugePalette.immune,
        GaugeTheme.green => GaugePalette.green,
        GaugeTheme.amber => GaugePalette.amber,
        GaugeTheme.red => GaugePalette.red,
      };

  @override
  Widget build(BuildContext context) {
    final palette = _palette;
    // Percentage is authored as 40pt on the 236.79 Figma frame.
    final textScale = widget.width / HealthGauge.designWidth;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
            painter: HealthGaugePainter(
              value: widget.value,
              progress: t,
              palette: palette,
            ),
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -4.8 * textScale),
                child: Text(
                  '${(widget.value * t).round()}%',
                  style: T.inter(40 * textScale, weight: FontWeight.w700),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

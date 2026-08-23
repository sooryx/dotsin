import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../core/figma_frame.dart';
import '../../../data/models/health_models.dart';
import '../../../shared/painters/hormone_chart_painter.dart';

/// Hormone chart card — Figma node 3:6396 (366 x 290.292 at frame 15,737).
/// All child offsets below are that frame's coordinates minus (15, 737).
class HormoneChartCard extends StatefulWidget {
  const HormoneChartCard({
    super.key,
    required this.points,
    required this.title,
    required this.axisLabel,
  });

  final List<ChartPoint> points;
  final String title;
  final String axisLabel;

  static const width = 366.0;
  static const height = 290.292;

  @override
  State<HormoneChartCard> createState() => _HormoneChartCardState();
}

class _HormoneChartCardState extends State<HormoneChartCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _draw = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void didUpdateWidget(HormoneChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points) _draw.forward(from: 0);
  }

  @override
  void dispose() {
    _draw.dispose();
    super.dispose();
  }

  static const _plot = Rect.fromLTWH(56.3, 46.52, 298.299, 183.248);
  static const _yLabels = ['100', '90', '80', '70', '60', '50'];
  static const _xLabels = <(String, double)>[
    ('0', 55.43),
    ('20', 109.83),
    ('40', 155.9),
    ('60', 205.4),
    ('80', 250.9),
    ('100', 288.03),
    ('120', 331.03),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: HormoneChartCard.width,
      height: HormoneChartCard.height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.478),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.293, sigmaY: 8.293),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.478),
                    border: Border.all(color: AppColors.chartBorderGreen, width: 0.448),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x1A171717), Color(0x1A3B3B3B)],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // vertical axis caption
          At(
            left: -63.3,
            top: 119.07,
            width: 161.4,
            height: 16,
            child: Transform.rotate(
              angle: -1.5707963,
              child: Center(
                child: Text(
                  widget.axisLabel,
                  style: T.orbitron(14.454, weight: FontWeight.w800, height: 19.08),
                ),
              ),
            ),
          ),

          At(
            left: 40,
            top: 10,
            width: 300,
            height: 20,
            child: Center(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: T.orbitron(10.623, weight: FontWeight.w800, height: 14.02),
                maxLines: 1,
              ),
            ),
          ),

          for (var i = 0; i < _yLabels.length; i++)
            At(
              left: 26,
              top: 54.49 + i * 22.906,
              width: 22,
              height: 10,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(_yLabels[i], style: T.inter(8.198)),
              ),
            ),

          // top / bottom zone glows
          At(
            left: 55.99,
            top: 42,
            width: 299,
            height: 10,
            child: _GlowBar(
              colors: const [Color(0xFF4BFF0A), Color(0xFF44FF00)],
            ),
          ),
          At(
            left: 55.99,
            top: 222,
            width: 294,
            height: 10,
            child: _GlowBar(
              colors: const [Color(0xFFCB1E1E), Color(0xFFFF0000)],
            ),
          ),

          At(
            left: _plot.left,
            top: _plot.top,
            width: _plot.width,
            height: _plot.height,
            child: const CustomPaint(painter: ChartGridPainter()),
          ),

          At(
            left: 41.99,
            top: 141.01,
            width: 308,
            height: 1,
            child: const CustomPaint(painter: DashedLinePainter()),
          ),

          At(
            left: _plot.left,
            top: _plot.top,
            width: _plot.width,
            height: _plot.height,
            child: AnimatedBuilder(
              animation: _draw,
              builder: (context, child) => CustomPaint(
                painter: HormoneChartPainter(
                  points: widget.points,
                  progress: Curves.easeOutCubic.transform(_draw.value),
                ),
              ),
            ),
          ),

          for (final label in _xLabels)
            At(
              left: label.$2,
              top: 233.7,
              width: 20,
              height: 10,
              child: Text(label.$1, style: T.inter(8.198)),
            ),

          const At(left: 285.99, top: 60.01, width: 69, height: 36, child: _PhaseLegend()),
        ],
      ),
    );
  }
}

class _GlowBar extends StatelessWidget {
  const _GlowBar({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
        ),
      ),
    );
  }
}

/// "Pending Actions" phase legend (node 3:6450).
class _PhaseLegend extends StatelessWidget {
  const _PhaseLegend();

  static const _rows = <(String, Color)>[
    ('Warm Up Phase', Color(0xFF4BFF0A)),
    ('Peak Activity', Color(0xFFF0A020)),
    ('Recovery Phase', Color(0xFF73FCFD)),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.066),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.93, sigmaY: 5.93),
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 4, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.066),
            border: Border.all(color: Colors.white, width: 0.185),
            gradient: const LinearGradient(
              colors: [Color(0x0FFFFFFF), Color(0x08FFFFFF)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final row in _rows)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 3.2,
                      height: 3.2,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: row.$2),
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        row.$1,
                        style: T.inter(4.0, weight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

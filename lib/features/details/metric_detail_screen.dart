import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/figma_frame.dart';
import '../../data/models/health_models.dart';
import '../../data/repositories/health_repository.dart';
import '../../shared/painters/gauge_painter.dart';
import '../../shared/widgets/figma_chrome.dart';
import '../../shared/widgets/scene_backdrop.dart';
import 'cubit/metric_detail_cubit.dart';

/// Metric details — Figma frame 3:6086 ("Mentzer" / LDL ranges), 402 x 1010.
class MetricDetailScreen extends StatelessWidget {
  const MetricDetailScreen({super.key, required this.metricId});

  final String metricId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MetricDetailCubit(context.read<HealthRepository>())..load(metricId),
      child: const _MetricDetailView(),
    );
  }
}

class _MetricDetailView extends StatelessWidget {
  const _MetricDetailView();

  static Color _hex(String value) =>
      Color(int.parse('FF${value.replaceFirst('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocBuilder<MetricDetailCubit, MetricDetailState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
            );
          }
          final metric = state.metric;
          if (metric == null) {
            return Center(child: Text(state.error ?? 'Metric not found', style: T.exo(14)));
          }

          final impactsTop = 595.0;
          final aboutTop = impactsTop + metric.impacts.length * 85 + 30;

          return FigmaFrame(
            designHeight: aboutTop + 220,
            children: [
              const Positioned.fill(
                child: SceneBackdrop(
                  tone: SceneTone.amber,
                  heroCenter: Offset(0.5, 0.12),
                ),
              ),
              At(
                left: 34,
                top: 68,
                width: 334,
                height: 36,
                child: FigmaHeader(
                  title: metric.title,
                  titleStyle: T.orbitron(22, weight: FontWeight.w500, spacing: -0.5),
                  onBack: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),
              ),

              At(
                left: 17,
                top: 128,
                width: 250,
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(metric.value, style: T.orbitron(30, weight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        metric.unit,
                        style: T.exo(13, weight: FontWeight.w500, color: AppColors.bodyGray),
                      ),
                    ),
                  ],
                ),
              ),
              At(
                left: 17,
                top: 168,
                width: 200,
                height: 18,
                child: Text(
                  metric.statusLabel,
                  style: T.exo(13, color: AppColors.tileSub),
                ),
              ),

              At(
                left: 68,
                top: 175,
                width: 267,
                height: 150,
                child: _RangeGauge(
                  needlePercent: metric.needlePercent,
                  bands: [for (final band in metric.ranges) _hex(band.colorHex)],
                ),
              ),

              At(
                left: 148,
                top: 315,
                width: 110,
                height: 26,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.riskWarnBorder),
                    color: const Color(0x1AEE9A29),
                  ),
                  child: Text(
                    metric.badgeLabel,
                    style: T.exo(13, weight: FontWeight.w700, color: AppColors.riskWarnValue),
                  ),
                ),
              ),

              At(
                left: 17,
                top: 366,
                width: 200,
                height: 30,
                child: Text('RANGES', style: T.orbitron(22, weight: FontWeight.w700)),
              ),
              for (var i = 0; i < metric.ranges.length; i++)
                At(
                  left: i.isEven ? 22 : 209,
                  top: 410 + (i ~/ 2) * 50,
                  width: 175,
                  height: 44,
                  child: _RangeRow(band: metric.ranges[i], color: _hex(metric.ranges[i].colorHex)),
                ),

              At(
                left: 17,
                top: 565,
                width: 360,
                height: 20,
                child: Text(
                  metric.impactsLabel,
                  style: T.exo(11.5, color: AppColors.tileSub),
                ),
              ),
              for (var i = 0; i < metric.impacts.length; i++)
                At(
                  left: 12,
                  top: impactsTop + i * 85,
                  width: 378,
                  child: _ImpactCard(
                    impact: metric.impacts[i],
                    expanded: state.expandedIndex == i,
                    onTap: () => context.read<MetricDetailCubit>().toggleImpact(i),
                  ),
                ),

              At(
                left: 17,
                top: aboutTop,
                width: 360,
                height: 24,
                child: Text(
                  metric.aboutTitle,
                  style: T.openSans(15, weight: FontWeight.w700),
                ),
              ),
              At(
                left: 17,
                top: aboutTop + 30,
                width: 360,
                child: Text(
                  metric.about,
                  style: T.openSans(13, color: AppColors.bodyGray, height: 20),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RangeGauge extends StatefulWidget {
  const _RangeGauge({required this.needlePercent, required this.bands});

  final double needlePercent;
  final List<Color> bands;

  @override
  State<_RangeGauge> createState() => _RangeGaugeState();
}

class _RangeGaugeState extends State<_RangeGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => CustomPaint(
        painter: RangeGaugePainter(
          needlePercent: widget.needlePercent,
          progress: Curves.easeOutCubic.transform(_c.value),
          bands: widget.bands,
        ),
      ),
    );
  }
}

class _RangeRow extends StatelessWidget {
  const _RangeRow({required this.band, required this.color});

  final RangeBand band;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                band.range,
                style: T.exo(13, weight: FontWeight.w600),
                maxLines: 1,
              ),
              Text(
                band.label.toUpperCase(),
                style: T.exo(9, weight: FontWeight.w500, color: AppColors.tileSub, spacing: 0.4),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.impact,
    required this.expanded,
    required this.onTap,
  });

  final ImpactParam impact;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: expanded ? AppColors.riskWarnBorder.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0x14EE9A29),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.riskWarnBorder.withValues(alpha: 0.7)),
              ),
              child: Center(
                child: SvgPicture.asset('assets/images/vec/seal_orange.svg', width: 18, height: 18),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(impact.title, style: T.exo(13, weight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topLeft,
                    child: Text(
                      impact.description,
                      maxLines: expanded ? 4 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: T.exo(10.5, color: AppColors.tileSub, height: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              child: const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

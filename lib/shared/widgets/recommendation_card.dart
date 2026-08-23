import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../data/models/health_models.dart';
import 'figma_chrome.dart';

/// Recommendation + strengths/weakness panel (Figma node 3:6544 / 3:54595).
/// 380 wide with neon-cyan edge, drop glow and a 3-across 97px chip grid.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.title,
    required this.intro,
    required this.bullets,
    required this.strengths,
    required this.weaknesses,
    this.numbered = false,
    this.titleWeight = FontWeight.w700,
    this.glowAsset,
    this.linesAsset,
  });

  final String title;
  final String intro;
  final List<String> bullets;
  final List<MetricChip> strengths;
  final List<MetricChip> weaknesses;
  final bool numbered;
  final FontWeight titleWeight;

  /// Kept for call-site compatibility; glow is painted, not loaded from SVG.
  final String? glowAsset;
  final String? linesAsset;

  static const width = 380.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -40,
            top: -20,
            right: -40,
            height: 180,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyanGlow.withValues(alpha: 0.28),
                      AppColors.cyanGlow.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: width,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
            decoration: BoxDecoration(
              color: const Color(0xE6000000),
              borderRadius: BorderRadius.circular(12.308),
              border: Border.all(color: AppColors.cyanBorder, width: 0.821),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x593EC5FF),
                  blurRadius: 19.692,
                  spreadRadius: -5.744,
                  offset: Offset(0, 3.282),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 352,
                  child: Text(
                    title,
                    style: T.exo(22, weight: titleWeight, height: 26),
                  ),
                ),
                const SizedBox(height: 8),
                if (intro.isNotEmpty)
                  SizedBox(
                    width: 311,
                    child: Text(intro, style: T.redRose(11, height: 22)),
                  ),
                const SizedBox(height: 2),
                for (var i = 0; i < bullets.length; i++)
                  SizedBox(
                    width: 330,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.5),
                      child: Text(
                        numbered ? '${i + 1}. ${bullets[i]}' : '•  ${bullets[i]}',
                        style: T.redRose(11, height: 22),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                Text('Strengths :', style: T.exo(22, weight: FontWeight.w700, height: 26)),
                const SizedBox(height: 16),
                _ChipGrid(items: strengths, positive: true),
                const SizedBox(height: 28),
                Text('Weakness :', style: T.exo(22, weight: FontWeight.w700, height: 26)),
                const SizedBox(height: 16),
                _ChipGrid(items: weaknesses, positive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipGrid extends StatelessWidget {
  const _ChipGrid({required this.items, required this.positive});

  final List<MetricChip> items;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 10,
      children: [
        for (final item in items)
          ScoreChip(value: item.value, label: item.label, positive: positive),
      ],
    );
  }
}

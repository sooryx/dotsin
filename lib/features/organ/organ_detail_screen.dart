import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/figma_frame.dart';
import '../../data/repositories/health_repository.dart';
import '../../shared/widgets/figma_chrome.dart';
import '../../shared/widgets/health_gauge.dart';
import '../../shared/widgets/hero_art.dart';
import '../../shared/widgets/recommendation_card.dart';
import '../../shared/widgets/scene_backdrop.dart';
import 'cubit/organ_cubit.dart';

/// Organ detail — Figma frame 3:54338 (Heart) and its Lungs variant, 402 x 1950.
class OrganDetailScreen extends StatelessWidget {
  const OrganDetailScreen({super.key, required this.organId});

  final String organId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrganCubit(context.read<HealthRepository>())..load(organId),
      child: const _OrganDetailView(),
    );
  }
}

class _OrganDetailView extends StatelessWidget {
  const _OrganDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocBuilder<OrganCubit, OrganState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.neonGreen, strokeWidth: 2),
            );
          }
          final organ = state.organ;
          if (organ == null) {
            return Center(child: Text(state.error ?? 'Organ not found', style: T.exo(14)));
          }

          final riskListHeight = organ.riskMetrics.length * 80.0;
          final contentBottom = 1524 + riskListHeight + 48;

          return FigmaFrame(
            designHeight: contentBottom.clamp(2100.0, 3200.0),
            children: [
              Positioned.fill(
                child: SceneBackdrop(
                  tone: SceneToneX.fromName(organ.gaugeTheme),
                  heroCenter: const Offset(0.5, 0.16),
                ),
              ),
              At(
                left: 34,
                top: 68,
                width: 334,
                height: 36,
                child: FigmaHeader(
                  title: 'Phenotype',
                  titleStyle: T.exo(24, weight: FontWeight.w500, height: 25.565, spacing: -0.5681),
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
                left: 80,
                top: 113,
                width: 242,
                height: 26,
                child: Center(
                  child: Text(
                    organ.overviewTitle,
                    style: T.orbitron(17.043, height: 25.565, spacing: -0.5681),
                    maxLines: 1,
                  ),
                ),
              ),

              const At(
                left: 9.5,
                top: 266,
                width: 385.3,
                height: 302,
                child: HoloPedestal(),
              ),
              At(
                left: 61,
                top: 163,
                width: 267,
                height: 267,
                child: HeroArt(asset: organ.heroAsset),
              ),

              const At(left: 196, top: 232, child: ConditionMarker(color: AppColors.markerGreen)),
              const At(left: 150, top: 300, child: ConditionMarker(color: AppColors.markerRed)),

              if (organ.callouts.isNotEmpty)
                At(
                  left: 49,
                  top: 209,
                  child: CalloutChip(
                    text: organ.callouts.first.text,
                    borderColor: AppColors.chipGreenText,
                    width: 127,
                    textWidth: 102,
                  ),
                ),
              if (organ.callouts.length > 1)
                At(
                  left: 245,
                  top: 151,
                  child: CalloutChip(
                    text: organ.callouts[1].text,
                    borderColor: AppColors.neonGreen,
                    width: 129,
                    textWidth: 99,
                    fontSize: 12,
                    blur: 5,
                    linkLabel: organ.callouts[1].linkLabel,
                    onLink: () => context.push('/details/${organ.riskMetrics.first.id}'),
                  ),
                ),
              if (organ.callouts.length > 2)
                At(
                  left: 49,
                  top: 355,
                  child: CalloutChip(
                    text: organ.callouts[2].text,
                    borderColor: AppColors.calloutRed,
                    width: 127,
                    textWidth: 102,
                  ),
                ),

              At(
                left: 115,
                top: 549,
                width: 180,
                height: 32,
                child: Center(
                  child: Text(organ.gaugeTitle, style: T.orbitron(20, height: 32), maxLines: 1),
                ),
              ),
              // Figma dial: 236.79×235.76, centerX -0.61, top 598
              At(
                left: HealthGauge.leftOnCanvas(),
                top: 598,
                width: HealthGauge.designWidth,
                height: HealthGauge.designHeight,
                child: HealthGauge(
                  value: organ.score,
                  theme: gaugeThemeFromName(organ.gaugeTheme),
                ),
              ),

              At(
                left: 11,
                top: 869,
                width: RecommendationCard.width,
                child: RecommendationCard(
                  title: organ.recommendationTitle,
                  intro: organ.recommendationIntro,
                  bullets: organ.recommendations,
                  strengths: organ.strengths,
                  weaknesses: organ.weaknesses,
                  numbered: true,
                  titleWeight: FontWeight.w400,
                ),
              ),

              At(
                left: 11,
                top: 1480,
                width: 381,
                height: 26,
                child: Center(
                  child: Text(
                    organ.riskSectionTitle,
                    textAlign: TextAlign.center,
                    style: T.orbitron(16, height: 25.565),
                  ),
                ),
              ),
              for (var i = 0; i < organ.riskMetrics.length; i++)
                At(
                  left: 11,
                  top: 1524 + i * 80,
                  width: 381,
                  height: 68,
                  child: RiskTile(
                    name: organ.riskMetrics[i].name,
                    range: organ.riskMetrics[i].range,
                    value: organ.riskMetrics[i].value,
                    status: organ.riskMetrics[i].status,
                    onTap: () => context.push('/details/${organ.riskMetrics[i].id}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

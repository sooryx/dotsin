import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/figma_frame.dart';
import '../../data/models/health_models.dart';
import '../../shared/widgets/figma_chrome.dart';
import '../../shared/widgets/health_gauge.dart';
import '../../shared/widgets/hero_art.dart';
import '../../shared/widgets/recommendation_card.dart';
import '../../shared/widgets/scene_backdrop.dart';
import '../drawer/organ_metrics_drawer.dart';
import 'cubit/phenotype_cubit.dart';
import 'widgets/genotype_panel.dart';
import 'widgets/hormone_chart_card.dart';
import 'widgets/score_card.dart';

/// Phenotype hub — Figma frame 3:6275 (402 x 2074). Every offset below is a raw
/// design coordinate from that frame.
class PhenotypeHubScreen extends StatefulWidget {
  const PhenotypeHubScreen({super.key});

  @override
  State<PhenotypeHubScreen> createState() => _PhenotypeHubScreenState();
}

class _PhenotypeHubScreenState extends State<PhenotypeHubScreen> {
  final _scroll = ScrollController();

  static const _frameHeight = 2250.0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToDesignY(double designY) {
    if (!_scroll.hasClients) return;
    final scale = MediaQuery.sizeOf(context).width / FigmaFrame.designWidth;
    final target = (designY * scale).clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocConsumer<PhenotypeCubit, PhenotypeState>(
        listenWhen: (previous, current) => previous.focus != current.focus,
        listener: (context, state) {
          if (state.focus == HubFocus.hormone) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToDesignY(620));
          } else if (state.focus == HubFocus.blood) {
            context.push('/blood');
            context.read<PhenotypeCubit>().clearFocus();
          }
        },
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.neonGreen, strokeWidth: 2),
            );
          }
          final data = state.data;
          if (data == null) {
            return Center(
              child: Text(state.error ?? 'Unable to load health data', style: T.exo(14)),
            );
          }

          return Stack(
            children: [
              FigmaFrame(
                controller: _scroll,
                designHeight: state.hubTab == HubTab.phenotype ? _frameHeight : 1180,
                children: state.hubTab == HubTab.phenotype
                    ? _phenotypeLayers(context, data, state)
                    : _genotypeLayers(context, data, state),
              ),
              if (state.drawerOpen)
                OrganMetricsDrawerOverlay(
                  organs: data.organs,
                  selectedId: state.selectedOrganId,
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _sharedChrome(BuildContext context, PhenotypeState state) {
    final cubit = context.read<PhenotypeCubit>();
    return [
      const Positioned.fill(
        child: SceneBackdrop(heroCenter: Offset(0.5, 0.19)),
      ),
      At(
        left: 34,
        top: 68,
        width: 334,
        height: 36,
        child: FigmaHeader(
          title: 'Phenotype',
          titleStyle: T.exo(24, weight: FontWeight.w500, height: 25.565, spacing: -0.5681),
          onBack: () => cubit.setHubTab(HubTab.genotype),
          onAvatarTap: cubit.toggleDrawer,
        ),
      ),
      At(
        left: 41,
        top: 121,
        width: 316,
        height: 47,
        child: GenotypeToggle(
          phenotypeSelected: state.hubTab == HubTab.phenotype,
          onChanged: (phenotype) =>
              cubit.setHubTab(phenotype ? HubTab.phenotype : HubTab.genotype),
        ),
      ),
    ];
  }

  List<Widget> _genotypeLayers(
    BuildContext context,
    PhenotypeData data,
    PhenotypeState state,
  ) {
    return [
      ..._sharedChrome(context, state),
      At(left: 11, top: 188, width: 380, height: 960, child: GenotypePanel(data: data)),
    ];
  }

  List<Widget> _phenotypeLayers(
    BuildContext context,
    PhenotypeData data,
    PhenotypeState state,
  ) {
    final cubit = context.read<PhenotypeCubit>();
    final serotonin = state.hormoneTab == HormoneTab.serotonin;
    final points = serotonin ? data.serotoninPoints : data.dopaminePoints;
    final chartTitle = serotonin ? data.chartTitleSerotonin : data.chartTitleDopamine;

    return [
      ..._sharedChrome(context, state),

      At(
        left: 94,
        top: 188,
        width: 260,
        height: 26,
        child: Text(
          data.overviewTitle,
          style: T.exo(18, weight: FontWeight.w500, height: 25.565, spacing: -0.5681),
        ),
      ),

      // --- body overview: holographic pedestal, silhouette, markers, callouts
      const At(
        left: 9.5,
        top: 402.4,
        width: 385.3,
        height: 302,
        child: HoloPedestal(),
      ),
      const At(
        left: 84,
        top: 221,
        width: 234,
        height: 345,
        child: HeroArt(asset: 'assets/images/heroes/body_cut.png'),
      ),

      const At(left: 214, top: 266.7, child: ConditionMarker(color: AppColors.markerGreen)),
      const At(left: 160, top: 284.14, child: ConditionMarker(color: AppColors.markerRed)),
      const At(left: 160, top: 419.4, child: ConditionMarker(color: AppColors.markerRed)),

      At(
        left: 242,
        top: 226,
        child: CalloutChip(
          text: data.callouts[0].text,
          borderColor: AppColors.neonGreen,
          width: 129,
          textWidth: 99,
          fontSize: 12,
          blur: 5,
          linkLabel: data.callouts[0].linkLabel,
          onLink: () => context.push('/details/mentzer'),
        ),
      ),
      At(
        left: 70,
        top: 284,
        child: CalloutChip(
          text: data.callouts[1].text,
          borderColor: AppColors.calloutRed,
          textWidth: 82,
        ),
      ),
      At(
        left: 70,
        top: 430,
        child: CalloutChip(
          text: data.callouts[2].text,
          borderColor: AppColors.calloutRed,
          textWidth: 82,
        ),
      ),

      // --- hormone chart
      At(
        left: 72,
        top: 664,
        width: 254,
        height: 52,
        child: HormoneToggle(
          serotoninSelected: serotonin,
          onChanged: (value) => cubit.setHormoneTab(
            value ? HormoneTab.serotonin : HormoneTab.dopamine,
          ),
        ),
      ),
      At(
        left: 15,
        top: 737,
        width: HormoneChartCard.width,
        height: HormoneChartCard.height,
        child: HormoneChartCard(
          points: points,
          title: chartTitle,
          axisLabel: data.chartAxisLabel,
        ),
      ),

      // --- condition score + about copy
      At(
        left: 19,
        top: 1052,
        width: 148.385,
        height: 96,
        child: IgnorePointer(
          child: Image.asset(
            'assets/images/ui/dna.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ),
      At(
        left: 15,
        top: 1041,
        width: HyperprolactinemiaScoreCard.width,
        height: HyperprolactinemiaScoreCard.height,
        child: HyperprolactinemiaScoreCard(
          title: data.scoreCardTitle,
          subtitle: data.scoreCardSubtitle,
          value: data.scoreValue,
          basis: data.scoreBasis,
        ),
      ),
      At(
        left: 178,
        top: 1041,
        width: 213,
        height: 160,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: data.aboutTitle,
                style: T.openSans(16, weight: FontWeight.w600, height: 22.4, spacing: -0.13),
              ),
              const TextSpan(text: '\n\n'),
              TextSpan(
                text: data.aboutBody,
                style: T.openSans(13, color: AppColors.bodyGray, height: 18.2, spacing: -0.13),
              ),
            ],
          ),
        ),
      ),

      // --- immune strength dial
      // Figma: heading y=1217; dial 236.79×235.76 at y=1270, centerX -0.61
      At(
        left: HealthGauge.leftOnCanvas(),
        top: 1270,
        width: HealthGauge.designWidth,
        height: HealthGauge.designHeight,
        child: HealthGauge(value: data.immuneScore),
      ),
      At(
        left: 62,
        top: 1217,
        width: 300,
        height: 40,
        child: Text(
          data.immuneHeading,
          style: T.orbitron(20, weight: FontWeight.w700, height: 32),
        ),
      ),

      // --- recommendations + strengths / weakness
      At(
        left: 11,
        top: 1562,
        width: RecommendationCard.width,
        child: RecommendationCard(
          title: data.immuneRecommendationTitle,
          intro: data.immuneIntro,
          bullets: data.immuneBullets,
          strengths: data.strengths,
          weaknesses: data.weaknesses,
        ),
      ),
    ];
  }
}

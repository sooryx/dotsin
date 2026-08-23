import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/figma_frame.dart';
import '../../shared/widgets/figma_chrome.dart';
import '../../shared/widgets/scene_backdrop.dart';
import '../phenotype/cubit/phenotype_cubit.dart';

/// Blood Metrics list reached from the Organ Metrics sheet. Reuses the risk-tile
/// component and header geometry from the organ frames.
class BloodMetricsScreen extends StatelessWidget {
  const BloodMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocBuilder<PhenotypeCubit, PhenotypeState>(
        builder: (context, state) {
          final metrics = state.data?.bloodMetrics ?? const [];

          return FigmaFrame(
            designHeight: (200 + metrics.length * 80 + 60).toDouble(),
            children: [
              const Positioned.fill(
                child: SceneBackdrop(heroCenter: Offset(0.5, 0.12)),
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
                left: 11,
                top: 124,
                width: 381,
                height: 26,
                child: Center(
                  child: Text('Blood Metrics', style: T.orbitron(20, weight: FontWeight.w600)),
                ),
              ),
              for (var i = 0; i < metrics.length; i++)
                At(
                  left: 11,
                  top: 176 + i * 80,
                  width: 381,
                  height: 68,
                  child: RiskTile(
                    name: metrics[i].name,
                    range: metrics[i].range,
                    value: metrics[i].value,
                    status: metrics[i].status,
                    onTap: () => context.push('/details/${metrics[i].id}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../data/models/health_models.dart';
import '../../../shared/widgets/figma_chrome.dart';

/// Genomic counterpart to the phenotype hub. Reuses the hub's card, chip and
/// typography tokens so the two tabs read as one system.
class GenotypePanel extends StatelessWidget {
  const GenotypePanel({super.key, required this.data});

  final PhenotypeData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genomic Health Overview',
          style: T.exo(18, weight: FontWeight.w500, height: 25.565, spacing: -0.5681),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.308),
            border: Border.all(color: AppColors.cyanBorder, width: 0.821),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Colors.black],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3D3EC5FF),
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
                height: 120,
                child: Center(
                  child: Image.asset(
                    'assets/images/ui/dna.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Marker Panel',
                style: T.exo(22, weight: FontWeight.w700, height: 26),
              ),
              const SizedBox(height: 8),
              Text(
                'Genotype markers are stable across the reporting window. Phenotype expression is tracked separately on the Phenotype tab.',
                style: T.redRose(11, height: 22),
              ),
              const SizedBox(height: 18),
              Text('Protective variants :', style: T.exo(18, weight: FontWeight.w700)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 10,
                children: [
                  for (final chip in data.strengths)
                    ScoreChip(value: chip.value, label: chip.label, positive: true),
                ],
              ),
              const SizedBox(height: 20),
              Text('Risk variants :', style: T.exo(18, weight: FontWeight.w700)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 10,
                children: [
                  for (final chip in data.weaknesses)
                    ScoreChip(value: chip.value, label: chip.label, positive: false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

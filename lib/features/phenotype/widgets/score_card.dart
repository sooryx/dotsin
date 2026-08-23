import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import '../../../core/figma_frame.dart';

/// "Hyperprolactinemia Score" card — Figma node 3:6482 (155.553 x 152.886).
class HyperprolactinemiaScoreCard extends StatelessWidget {
  const HyperprolactinemiaScoreCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.basis,
  });

  final String title;
  final String subtitle;
  final double value;
  final String basis;

  static const width = 155.553;
  static const height = 152.886;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.889),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.889),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x73060B28), Color(0x5C0A0E23)],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              At(
                left: 13.42,
                top: 24.04,
                width: 289.597,
                height: 289.597,
                child: SvgPicture.asset(
                  'assets/images/vec/progress_ring.svg',
                  fit: BoxFit.fill,
                ),
              ),
              At(
                left: 12,
                top: 11.56,
                width: 130,
                height: 12,
                child: Text(
                  title,
                  style: T.orbitron(8, height: 11.2),
                  maxLines: 1,
                ),
              ),
              At(
                left: 12,
                top: 24.44,
                width: 130,
                height: 10,
                child: Text(subtitle, style: T.exo(6.222, color: AppColors.gray400)),
              ),
              At(
                left: 12.89,
                top: 99.55,
                width: 130.22,
                height: 36.444,
                child: _ValuePlate(value: value, basis: basis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValuePlate extends StatelessWidget {
  const _ValuePlate({required this.value, required this.basis});

  final double value;
  final String basis;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.889),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.889),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xBD060B28), Color(0xB50A0E23)],
            ),
          ),
          child: Stack(
            children: [
              At(
                left: 11.11,
                top: 7.56,
                width: 20,
                height: 8,
                child: Text('0%', style: T.exo(5.333, color: AppColors.gray400)),
              ),
              At(
                left: 100,
                top: 7.56,
                width: 26,
                height: 8,
                child: Text('100%', style: T.exo(5.333, color: AppColors.gray400)),
              ),
              At(
                left: 35,
                top: 4,
                width: 60,
                height: 24,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value),
                    duration: const Duration(milliseconds: 1100),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, child) =>
                        Text('${v.round()}%', style: T.orbitron(20)),
                  ),
                ),
              ),
              At(
                left: 30,
                top: 26.22,
                width: 80,
                height: 10,
                child: Center(
                  child: Text(basis, style: T.exo(5.333, color: AppColors.gray400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

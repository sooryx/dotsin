import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/figma_frame.dart';

/// iOS status bar mock from the design (frame node 2:8, height 54.235).
class FigmaStatusBar extends StatelessWidget {
  const FigmaStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: FigmaFrame.designWidth,
      height: 54.235,
      child: Stack(
        children: [
          At(
            left: 145.2,
            top: 12.7,
            width: 112.2,
            height: 28.8,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 11.2),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(34.618),
              ),
              child: Image.asset(
                'assets/images/ui/island_cam.png',
                width: 10.3,
                height: 10.3,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          At(
            left: 21.92,
            top: 13.85,
            width: 62.313,
            height: 24.233,
            child: Center(
              child: Text('9:41', style: T.inter(17.309, weight: FontWeight.w800)),
            ),
          ),
          At(
            left: FigmaFrame.designWidth - 33.44 - 80.385,
            top: 22.31,
            width: 80.385,
            height: 13.463,
            child: SvgPicture.asset('assets/images/vec/status_right.svg', fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}

/// Back arrow + centered screen title + avatar (frame nodes 3:6277 / 3:54436).
class FigmaHeader extends StatelessWidget {
  const FigmaHeader({
    super.key,
    required this.title,
    required this.titleStyle,
    this.onBack,
    this.onAvatarTap,
  });

  final String title;
  final TextStyle titleStyle;
  final VoidCallback? onBack;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 334,
      height: 36,
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset('assets/images/vec/arrow_left.svg'),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(title, style: titleStyle, maxLines: 1),
            ),
          ),
          GestureDetector(
            onTap: onAvatarTap,
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              'assets/images/ui/avatar.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person_outline, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Genotype / Phenotype capsule (node 3:6601).
class GenotypeToggle extends StatelessWidget {
  const GenotypeToggle({
    super.key,
    required this.phenotypeSelected,
    required this.onChanged,
    this.height = 47,
    this.fontSize = 16,
    this.knobTop = 7,
    this.useOrbitron = false,
  });

  final bool phenotypeSelected;
  final ValueChanged<bool> onChanged;
  final double height;
  final double fontSize;
  final double knobTop;
  final bool useOrbitron;

  TextStyle get _style => useOrbitron
      ? T.orbitron(fontSize, height: 25.565, spacing: 1)
      : T.exo(fontSize, height: 25.565, spacing: 1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 316,
      height: height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            left: phenotypeSelected ? 173 : 6,
            top: knobTop,
            width: 137,
            height: 33,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.toggleTrack,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(false),
                    behavior: HitTestBehavior.opaque,
                    child: Center(child: Text('Genotype', style: _style)),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(true),
                    behavior: HitTestBehavior.opaque,
                    child: Center(child: Text('Phenotype', style: _style)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dopamine / Serotonin selector (node 3:6494) — 254x52 outlined capsule with a
/// gradient knob on the active side.
class HormoneToggle extends StatelessWidget {
  const HormoneToggle({
    super.key,
    required this.serotoninSelected,
    required this.onChanged,
  });

  final bool serotoninSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 254,
      height: 52,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.pillBorderGreen, width: 0.5),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1A171717), Color(0x1A3B3B3B)],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            left: serotoninSelected ? 122 : 12,
            top: 8,
            width: 120,
            height: 36.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [AppColors.pillGreenTop, AppColors.pillGreenBottom],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x591FCB4F),
                    blurRadius: 4.028,
                    offset: Offset(0, 3.223),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(false),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'Dopamine',
                        style: T.exo(
                          12,
                          weight: FontWeight.w700,
                          color: serotoninSelected ? AppColors.grayLabel : const Color(0xFFF1F1F1),
                          spacing: 0.8057,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(true),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'Serotonin',
                        style: T.exo(
                          12,
                          weight: FontWeight.w700,
                          color: serotoninSelected ? const Color(0xFFF1F1F1) : AppColors.grayLabel,
                          spacing: 0.8057,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulsing body marker (nodes 3:6376 / 3:6383) — three concentric circles.
class ConditionMarker extends StatefulWidget {
  const ConditionMarker({super.key, required this.color});

  final Color color;

  @override
  State<ConditionMarker> createState() => _ConditionMarkerState();
}

class _ConditionMarkerState extends State<ConditionMarker> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_c.value);
        return SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 24 + 16 * t,
                height: 24 + 16 * t,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.10 * (1 - t)),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.20),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Glass callout chip. Green variant carries the "View in Details" link.
class CalloutChip extends StatelessWidget {
  const CalloutChip({
    super.key,
    required this.text,
    required this.borderColor,
    this.width = 103,
    this.textWidth,
    this.fontSize = 10,
    this.linkLabel,
    this.onLink,
    this.blur = 2.5,
  });

  final String text;
  final Color borderColor;
  final double width;
  final double? textWidth;
  final double fontSize;
  final String? linkLabel;
  final VoidCallback? onLink;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          padding: EdgeInsets.fromLTRB(10, 4, 15, linkLabel == null ? 7 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: textWidth,
                child: Text(text, style: T.grotesk(fontSize)),
              ),
              if (linkLabel != null) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onLink,
                  child: Text(
                    linkLabel!,
                    style: T.mono(8, color: AppColors.linkGreen),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Strength / weakness chip (nodes 3:6558 & 3:6579) — 97 wide, radius 10.
class ScoreChip extends StatelessWidget {
  const ScoreChip({
    super.key,
    required this.value,
    required this.label,
    required this.positive,
  });

  final String value;
  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 97,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: positive ? AppColors.chipGreenBg : AppColors.chipRedBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: positive ? AppColors.chipGreenBorder : AppColors.chipRedBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: T.exo(
              13,
              weight: FontWeight.w700,
              color: positive ? AppColors.chipGreenText : AppColors.chipRedText,
              height: 18.2,
              spacing: -0.13,
            ),
          ),
          Text(
            label,
            style: T.mono(8.5, spacing: -0.1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Risk-assessment row (node 3:54514) — 381x68 gradient card, status coloured.
class RiskTile extends StatelessWidget {
  const RiskTile({
    super.key,
    required this.name,
    required this.range,
    required this.value,
    required this.status,
    this.onTap,
  });

  final String name;
  final String range;
  final String value;
  final String status;
  final VoidCallback? onTap;

  Color get _border => switch (status) {
        'good' => AppColors.riskGoodBorder,
        'bad' => AppColors.riskBadBorder,
        _ => AppColors.riskWarnBorder,
      };

  Color get _valueColor => switch (status) {
        'good' => AppColors.riskGoodValue,
        'bad' => AppColors.riskBadValue,
        _ => AppColors.riskWarnValue,
      };

  List<Color> get _gradient => switch (status) {
        'good' => const [AppColors.riskGoodFrom, AppColors.riskGoodMid, Color(0x78101010)],
        'bad' => const [AppColors.riskBadFrom, Color(0x8A000000)],
        _ => const [AppColors.riskWarnFrom, Color(0x82000000)],
      };

  String get _seal => switch (status) {
        'good' => 'assets/images/vec/seal_green.svg',
        'bad' => 'assets/images/vec/seal_red.svg',
        _ => 'assets/images/vec/seal_orange.svg',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border, width: 0.5),
          gradient: LinearGradient(colors: _gradient),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0x0AFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x1AFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(_seal, width: 24, height: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: T.openSans(
                        14,
                        weight: FontWeight.w700,
                        color: AppColors.tileTitle,
                        height: 18,
                        spacing: -0.14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      range,
                      style: T.openSans(
                        13,
                        color: AppColors.tileSub,
                        height: 18,
                        spacing: -0.14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: T.orbitron(
                    28,
                    weight: FontWeight.w700,
                    color: _valueColor,
                    height: 36,
                    spacing: -0.32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

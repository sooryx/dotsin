import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/figma_frame.dart';
import '../../data/models/health_models.dart';
import '../phenotype/cubit/phenotype_cubit.dart';

/// Organ Metrics sheet — Figma frame 3:53943. The panel is a 213 x 769 rounded
/// slab pinned at design (195, 121); child offsets are panel-local.
class OrganMetricsDrawerOverlay extends StatelessWidget {
  const OrganMetricsDrawerOverlay({
    super.key,
    required this.organs,
    required this.selectedId,
  });

  final List<OrganSummary> organs;
  final String selectedId;

  /// Row baselines lifted straight from the design (label top, icon box).
  static const _rows = <({double labelTop, double iconTop, double iconLeft, double iconSize})>[
    (labelTop: 140, iconTop: 124, iconLeft: 29, iconSize: 61),
    (labelTop: 224, iconTop: 210, iconLeft: 37, iconSize: 44),
    (labelTop: 293.06, iconTop: 281, iconLeft: 37, iconSize: 39),
    (labelTop: 362.71, iconTop: 350, iconLeft: 35, iconSize: 44),
    (labelTop: 432, iconTop: 420, iconLeft: 35, iconSize: 44),
    (labelTop: 498, iconTop: 486, iconLeft: 35, iconSize: 44),
    (labelTop: 563, iconTop: 552, iconLeft: 33, iconSize: 46),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PhenotypeCubit>();
    final width = MediaQuery.sizeOf(context).width;
    final scale = width / FigmaFrame.designWidth;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: cubit.closeDrawer,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 220),
              builder: (context, t, child) => ColoredBox(color: Colors.black.withValues(alpha: 0.5 * t)),
            ),
          ),
        ),
        Positioned(
          left: 195 * scale,
          top: 121 * scale,
          width: 213 * scale,
          height: 769 * scale,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: 0),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => FractionalTranslation(
              translation: Offset(t, 0),
              child: child,
            ),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 213,
                height: 769,
                child: _Panel(
                  organs: organs,
                  selectedId: selectedId,
                  rows: _rows,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.organs,
    required this.selectedId,
    required this.rows,
  });

  final List<OrganSummary> organs;
  final String selectedId;
  final List<({double labelTop, double iconTop, double iconLeft, double iconSize})> rows;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PhenotypeCubit>();
    final count = organs.length < rows.length ? organs.length : rows.length;
    final selectedIndex = organs.indexWhere((organ) => organ.id == selectedId);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.drawerPanel,
          borderRadius: BorderRadius.circular(30.822),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3D000000),
              blurRadius: 72.431,
              offset: Offset(10.347, 11.497),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            if (selectedIndex >= 0 && selectedIndex < count)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: 8,
                top: rows[selectedIndex].labelTop - 34,
                width: 197,
                height: 78,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                ),
              ),

            At(
              left: 11,
              top: 43,
              width: 160,
              height: 26,
              child: Text('Organ Metrics', style: T.orbitron(20, weight: FontWeight.w600)),
            ),
            At(
              left: 168,
              top: 43,
              width: 25,
              height: 25,
              child: GestureDetector(
                onTap: cubit.closeDrawer,
                behavior: HitTestBehavior.opaque,
                child: const Icon(Icons.keyboard_arrow_up_rounded, size: 22, color: Colors.white),
              ),
            ),

            for (var i = 0; i < count; i++) ...[
              At(
                left: rows[i].iconLeft,
                top: rows[i].iconTop,
                width: rows[i].iconSize,
                height: rows[i].iconSize,
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(rows[i].iconSize * 0.195),
                    child: Image.asset(
                      organs[i].iconAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              At(
                left: 89,
                top: rows[i].labelTop,
                width: 110,
                height: 24,
                child: GestureDetector(
                  onTap: () {
                    cubit.selectOrgan(organs[i].id);
                    context.push('/organ/${organs[i].id}');
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      organs[i].name,
                      style: T.poppins(organs[i].id == selectedId ? 20 : 14),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],

            At(
              left: 6,
              top: 623,
              width: 202,
              height: 55,
              child: _DrawerAction(label: 'Blood Metrics', onTap: cubit.focusBlood),
            ),
            At(
              left: 3,
              top: 690,
              width: 202,
              height: 55,
              child: _DrawerAction(label: 'Hormone', onTap: cubit.focusHormone),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerAction extends StatelessWidget {
  const _DrawerAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.drawerButton,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.only(left: 19),
        alignment: Alignment.centerLeft,
        child: Text(label, style: T.orbitron(20, weight: FontWeight.w600)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// All Figma frames on the source page are 402px wide. Screens are authored in
/// those raw design units and this widget maps them onto any device width, so
/// spacing/typography stay proportional instead of drifting per screen size.
class FigmaFrame extends StatelessWidget {
  const FigmaFrame({
    super.key,
    required this.designHeight,
    required this.children,
    this.controller,
    this.scrollable = true,
  });

  static const designWidth = 402.0;

  final double designHeight;
  final List<Widget> children;
  final ScrollController? controller;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = width / designWidth;

    final canvas = SizedBox(
      width: width,
      height: designHeight * scale,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: designWidth,
          height: designHeight,
          // Allow bottom cards to paint past their measured bounds; scroll
          // extent is still driven by designHeight.
          child: Stack(clipBehavior: Clip.none, children: children),
        ),
      ),
    );

    if (!scrollable) return canvas;

    return ScrollConfiguration(
      behavior: const _NoGlowBehavior(),
      child: SingleChildScrollView(
        controller: controller,
        physics: const ClampingScrollPhysics(),
        child: canvas,
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}

/// Positions a design-space box using Figma's left/top/width/height values.
class At extends StatelessWidget {
  const At({
    super.key,
    required this.left,
    required this.top,
    this.width,
    this.height,
    required this.child,
  });

  final double left;
  final double top;
  final double? width;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: child,
    );
  }
}

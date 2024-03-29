import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Colors,
        Container,
        EdgeInsets,
        Key,
        StatelessWidget,
        Widget;
import 'package:shimmer/shimmer.dart' show Shimmer;

class Skeleton extends StatelessWidget {
  const Skeleton({
    required this.width,
    required this.height,
    Key? key,
    this.margin = const EdgeInsets.all(0),
  })  : child = null,
        super(key: key);

  const Skeleton.custom({required this.child, Key? key})
      : width = null,
        height = null,
        margin = null,
        super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.of(context).shimmerBase,
      highlightColor: AppTheme.of(context).shimmerHighlight,
      child: child != null
          ? child!
          : Container(
              width: width,
              height: height,
              margin: margin,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
    );
  }
}

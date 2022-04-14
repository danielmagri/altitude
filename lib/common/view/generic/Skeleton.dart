import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, BuildContext, Colors, Container, EdgeInsets, Key, StatelessWidget, Widget, required;
import 'package:shimmer/shimmer.dart' show Shimmer;

class Skeleton extends StatelessWidget {
  const Skeleton({Key key, @required this.width, @required this.height, this.margin = const EdgeInsets.all(0)})
      : child = null,
        super(key: key);

  Skeleton.custom({Key key, @required this.child})
      : width = null,
        height = null,
        margin = null,
        super(key: key);

  final Widget child;
  final double width;
  final double height;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.of(context).shimmerBase,
      highlightColor: AppTheme.of(context).shimmerHighlight,
      child: child != null
          ? child
          : Container(
              width: width,
              height: height,
              margin: margin,
              decoration: BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(15)),
            ),
    );
  }
}

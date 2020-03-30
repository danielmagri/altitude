import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  Skeleton({Key key, @required this.width, @required this.height, this.margin = const EdgeInsets.all(0)})
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
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
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

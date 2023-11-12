import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform-aware activity indicator
class PoolerLoader extends StatelessWidget {
  const PoolerLoader({
    super.key,
    this.materialStrokeWidth = 1.5,
    this.height,
  });

  final double? height;
  final double materialStrokeWidth;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: height ?? 20,
        width: height ?? 20,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: CircularProgressIndicator(strokeWidth: materialStrokeWidth),
          ),
        ),
      );
    }

    return const CupertinoActivityIndicator();
  }
}

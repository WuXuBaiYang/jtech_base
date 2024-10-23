import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jtech_base/tool/loading.dart';
import 'view.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2024/10/11 13:52
*/
class LoadingOverlay extends StatelessWidget {
  // 进度流
  final Stream<double>? progressStream;

  // 样式
  final LoadingOverlayStyle? style;

  const LoadingOverlay({
    super.key,
    this.style,
    this.progressStream,
  });

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LoadingThemeData.of(context).style;
    final boxDecoration = BoxDecoration(
      borderRadius: style.borderRadius,
      color: style.backgroundColor ?? Theme.of(context).cardColor,
    );
    return Container(
      decoration: boxDecoration,
      alignment: Alignment.center,
      constraints: style.constraints,
      child: _buildLoading(context, style),
    );
  }

  // 构建进度加载视图
  Widget _buildLoading(BuildContext context, LoadingOverlayStyle style) {
    if (progressStream == null) {
      return LoadingView(
        size: style.loadingSize,
        index: style.loadingIndex,
        color: style.loadingColor,
      );
    }
    return StreamBuilder<double>(
      stream: progressStream,
      builder: (_, snap) {
        final progress = snap.data ?? 0;
        return SizedBox.fromSize(
          size: Size.square(style.loadingSize),
          child: CircularProgressIndicator(
            value: progress,
            color: style.loadingColor,
          ),
        );
      },
    );
  }
}

/*
* 加载组件装饰器
* @author wuxubaiyang
* @Time 2024/10/17 9:52
*/
class LoadingOverlayStyle {
  // 加载颜色
  final Color? loadingColor;

  // 加载大小
  final double loadingSize;

  // 加载索引
  final int loadingIndex;

  // 背景颜色
  final Color? backgroundColor;

  // 约束
  final BoxConstraints constraints;

  // 圆角
  final BorderRadius borderRadius;

  const LoadingOverlayStyle({
    this.loadingColor,
    this.backgroundColor,
    this.loadingSize = 48,
    this.loadingIndex = -1,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.constraints = const BoxConstraints.tightFor(width: 80, height: 80),
  });

  LoadingOverlayStyle copyWith({
    Color? loadingColor,
    Color? backgroundColor,
    double? loadingSize,
    int? loadingIndex,
    BorderRadius? borderRadius,
    BoxConstraints? constraints,
  }) {
    return LoadingOverlayStyle(
      loadingColor: loadingColor ?? this.loadingColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      loadingSize: loadingSize ?? this.loadingSize,
      loadingIndex: loadingIndex ?? this.loadingIndex,
      borderRadius: borderRadius ?? this.borderRadius,
      constraints: constraints ?? this.constraints,
    );
  }

  static LoadingOverlayStyle lerp(
      LoadingOverlayStyle? a, LoadingOverlayStyle? b, double t) {
    if (a == null && b == null) return LoadingOverlayStyle();
    return LoadingOverlayStyle(
      loadingColor: Color.lerp(a?.loadingColor, b?.loadingColor, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      loadingSize: lerpDouble(a?.loadingSize, b?.loadingSize, t) ?? 48,
      loadingIndex: t < 0.5 ? a?.loadingIndex ?? -1 : b?.loadingIndex ?? -1,
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t) ??
          const BorderRadius.all(Radius.circular(14)),
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t) ??
          const BoxConstraints.tightFor(width: 80, height: 80),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingOverlayStyle &&
          runtimeType == other.runtimeType &&
          loadingColor == other.loadingColor &&
          backgroundColor == other.backgroundColor &&
          loadingSize == other.loadingSize &&
          loadingIndex == other.loadingIndex &&
          borderRadius == other.borderRadius &&
          constraints == other.constraints;

  @override
  int get hashCode => Object.hashAll([
        loadingColor,
        backgroundColor,
        loadingSize,
        loadingIndex,
        borderRadius,
        constraints,
      ]);
}

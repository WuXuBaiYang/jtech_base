import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

/*
* 骨架屏视图
* @author wuxubaiyang
* @Time 2024/8/10 23:20
*/
class ShimmerView extends StatelessWidget {
  // 动画时长
  final Duration duration;

  // 动画时长间隔
  final Duration interval;

  // 子元素
  final Widget child;

  // 是否启用
  final bool enabled;

  // 外间距
  final EdgeInsetsGeometry margin;

  // 内间距
  final EdgeInsetsGeometry padding;

  // 约束
  final BoxConstraints constraints;

  const ShimmerView({
    super.key,
    required this.enabled,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.constraints = const BoxConstraints(),
    this.interval = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Shimmer(
        enabled: enabled,
        interval: interval,
        duration: duration,
        child: Container(
          padding: padding,
          constraints: constraints,
          child: child,
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/*
* 加载动画
* @author wuxubaiyang
* @Time 2024/8/8 10:00
*/
class LoadingView extends StatelessWidget {
  // 大小
  final double size;

  // 颜色
  final Color? color;

  // 动画下标
  final int index;

  // 使用下标
  const LoadingView({
    super.key,
    required this.index,
    this.color,
    this.size = 35,
  });

  const LoadingView.random({
    super.key,
    this.color,
    this.size = 45,
    this.index = -1,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        this.color ?? Theme.of(context).primaryColor.withValues(alpha: 0.6);
    return switch (index > 0 ? index : Random().nextInt(17)) {
      0 => LoadingAnimationWidget.waveDots(color: color, size: size),
      1 => LoadingAnimationWidget.inkDrop(color: color, size: size),
      2 => LoadingAnimationWidget.threeRotatingDots(color: color, size: size),
      3 => LoadingAnimationWidget.staggeredDotsWave(color: color, size: size),
      4 => LoadingAnimationWidget.fourRotatingDots(color: color, size: size),
      5 => LoadingAnimationWidget.fallingDot(color: color, size: size),
      6 => LoadingAnimationWidget.threeArchedCircle(color: color, size: size),
      7 => LoadingAnimationWidget.bouncingBall(color: color, size: size),
      8 => LoadingAnimationWidget.hexagonDots(color: color, size: size),
      9 => LoadingAnimationWidget.beat(color: color, size: size),
      10 => LoadingAnimationWidget.twoRotatingArc(color: color, size: size),
      11 =>
        LoadingAnimationWidget.horizontalRotatingDots(color: color, size: size),
      12 => LoadingAnimationWidget.newtonCradle(color: color, size: size),
      13 => LoadingAnimationWidget.stretchedDots(color: color, size: size),
      14 => LoadingAnimationWidget.halfTriangleDot(color: color, size: size),
      15 => LoadingAnimationWidget.dotsTriangle(color: color, size: size),
      _ => LoadingAnimationWidget.discreteCircle(
          color: color,
          size: size,
          secondRingColor: color.withValues(alpha: 0.5),
          thirdRingColor: color.withValues(alpha: 0.25)),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
import 'view.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2024/10/11 13:52
*/
class LoadingOverlay extends StatelessWidget {
  // 进度流
  final Stream<double>? progressStream;

  // 装饰器
  final LoadingOverlayDecoration? decoration;

  const LoadingOverlay({
    super.key,
    this.decoration,
    this.progressStream,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = this.decoration ??
        CustomTheme.of(context)?.loadingDecoration ??
        const LoadingOverlayDecoration();
    final boxDecoration = BoxDecoration(
      borderRadius: decoration.borderRadius,
      color: decoration.backgroundColor ?? Theme.of(context).cardColor,
    );
    return Container(
      decoration: boxDecoration,
      alignment: Alignment.center,
      constraints: decoration.constraints,
      child: _buildLoading(context, decoration),
    );
  }

  // 构建进度加载视图
  Widget _buildLoading(
      BuildContext context, LoadingOverlayDecoration decoration) {
    if (progressStream == null) {
      return LoadingView(
        size: decoration.loadingSize,
        index: decoration.loadingIndex,
        color: decoration.loadingColor,
      );
    }
    return StreamBuilder<double>(
      stream: progressStream,
      builder: (_, snap) {
        final progress = snap.data ?? 0;
        return SizedBox.fromSize(
          size: Size.square(decoration.loadingSize),
          child: CircularProgressIndicator(
            value: progress,
            color: decoration.loadingColor,
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
class LoadingOverlayDecoration {
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

  const LoadingOverlayDecoration({
    this.loadingColor,
    this.backgroundColor,
    this.loadingSize = 48,
    this.loadingIndex = -1,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.constraints = const BoxConstraints.tightFor(width: 80, height: 80),
  });
}

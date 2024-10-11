import 'package:flutter/material.dart';
import 'view.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2024/10/11 13:52
*/
class FutureLoadingOverlay extends StatelessWidget {
  // 加载动画颜色
  final Color? loadingColor;

  // 加载动画大小
  final double loadingSize;

  // 加载动画索引
  final int loadingIndex;

  // 背景颜色
  final Color? backgroundColor;

  // 进度流
  final Stream<double>? progressStream;

  // 遮罩颜色
  final Color barrierColor;

  // 约束
  final BoxConstraints constraints;

  // 点击背景取消回调
  final VoidCallback? onCancel;

  const FutureLoadingOverlay({
    super.key,
    this.onCancel,
    this.loadingColor,
    this.progressStream,
    this.backgroundColor,
    this.loadingSize = 48,
    this.loadingIndex = -1,
    this.barrierColor = Colors.black38,
    this.constraints = const BoxConstraints.tightFor(width: 80, height: 80),
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: backgroundColor ?? Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
    );
    return GestureDetector(
      onTap: onCancel,
      child: AbsorbPointer(
        child: Material(
          color: barrierColor,
          child: Center(
            child: Container(
              decoration: decoration,
              constraints: constraints,
              alignment: Alignment.center,
              child: _buildLoading(context),
            ),
          ),
        ),
      ),
    );
  }

  // 构建进度加载视图
  Widget _buildLoading(BuildContext context) {
    if (progressStream == null) {
      return LoadingView(
        size: loadingSize,
        index: loadingIndex,
        color: loadingColor,
      );
    }
    return StreamBuilder<double>(
      stream: progressStream,
      builder: (_, snap) {
        final progress = snap.data ?? 0;
        return SizedBox.fromSize(
          size: Size.square(loadingSize),
          child: CircularProgressIndicator(
            value: progress,
            color: loadingColor,
          ),
        );
      },
    );
  }
}

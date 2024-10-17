import 'package:flutter/material.dart';

/*
* 自定义覆盖物视图
* @author wuxubaiyang
* @Time 2024/10/17 13:16
*/
class CustomOverlayView extends StatefulWidget {
  // 背景色动画
  final Animation<double>? barrierAnimation;

  // 动画控制器
  final Animation<double>? overlayAnimation;

  // 动画构造器
  final TransitionBuilder builder;

  // 子元素
  final Widget? child;

  // 是否可点击回调
  final VoidCallback? onOutsideTap;

  // 对齐方式
  final AlignmentGeometry alignment;

  // 背景色
  final Color? barrierColor;

  const CustomOverlayView({
    super.key,
    required this.builder,
    this.child,
    this.onOutsideTap,
    this.barrierColor,
    this.barrierAnimation,
    this.overlayAnimation,
    this.alignment = Alignment.center,
  });

  @override
  State<CustomOverlayView> createState() => _CustomOverlayViewState();
}

class _CustomOverlayViewState extends State<CustomOverlayView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: _buildOutside(context)),
      Align(alignment: widget.alignment, child: _buildOverlay(context)),
    ]);
  }

  // 构建元素外部容器
  Widget _buildOutside(BuildContext context) {
    final animation = widget.barrierAnimation;
    return GestureDetector(
      onTap: widget.onOutsideTap,
      child: animation != null
          ? AnimatedBuilder(
              animation: animation,
              builder: (_, __) {
                return Opacity(
                  opacity: animation.value,
                  child: Container(color: widget.barrierColor),
                );
              },
            )
          : Container(color: Colors.transparent),
    );
  }

  // 构建遮罩层
  Widget _buildOverlay(BuildContext context) {
    final animation = widget.overlayAnimation;
    return GestureDetector(
      onTap: () {},
      child: animation != null
          ? AnimatedBuilder(
              builder: widget.builder,
              animation: animation,
              child: widget.child,
            )
          : widget.builder(context, widget.child),
    );
  }
}

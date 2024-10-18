import 'package:flutter/material.dart';

/*
* 自定义弹窗
* @author wuxubaiyang
* @Time 2024/7/31 20:59
*/
class CustomDialog extends StatelessWidget {
  // 标题
  final Widget? title;

  // 内容
  final Widget? content;

  // 操作按钮
  final List<Widget> actions;

  // 是否可滚动
  final bool scrollable;

  // 约束
  final BoxConstraints constraints;

  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
    this.scrollable = false,
    this.constraints = const BoxConstraints.tightFor(width: 280),
  });

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 8);
    return AlertDialog(
      title: title,
      actions: actions,
      scrollable: scrollable,
      contentPadding: contentPadding,
      content: ConstrainedBox(
        constraints: constraints,
        child: content,
      ),
    );
  }
}

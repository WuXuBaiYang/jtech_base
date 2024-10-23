import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';

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

  // 装饰器
  final CustomDialogDecoration? decoration;

  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.decoration,
    this.actions = const [],
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CustomDialogThemeData.of(context);
    final decoration = this.decoration ?? themeData.decoration;
    return AlertDialog(
      title: title,
      actions: actions,
      scrollable: scrollable,
      contentPadding: decoration.contentPadding,
      content: ConstrainedBox(
        constraints: decoration.constraints,
        child: content,
      ),
    );
  }
}

/*
* 自定义弹窗装饰器
* @author wuxubaiyang
* @Time 2024/10/22 10:34
*/
class CustomDialogDecoration {
  // 约束
  final BoxConstraints constraints;

  // 内容间距
  final EdgeInsetsGeometry contentPadding;

  const CustomDialogDecoration({
    this.constraints = const BoxConstraints(maxWidth: 280),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  });
}

/*
* 自定义弹窗样式
* @author wuxubaiyang
* @Time 2024/10/22 13:17
*/
class CustomDialogThemeData {
  // 装饰器
  final CustomDialogDecoration decoration;

  const CustomDialogThemeData({
    this.decoration = const CustomDialogDecoration(),
  });

  // 获取通知主题
  static CustomDialogThemeData of(BuildContext context) =>
      maybeOf(context) ?? const CustomDialogThemeData();

  // 获取通知主题
  static CustomDialogThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.customDialogTheme;
}

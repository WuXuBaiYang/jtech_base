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

  // 样式
  final CustomDialogStyle? style;

  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.style,
    this.actions = const [],
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = CustomDialogStyle.mergeOf(context, this.style);
    return AlertDialog(
      title: title,
      actions: actions,
      scrollable: scrollable,
      contentPadding: style.contentPadding,
      content: ConstrainedBox(
        constraints: style.constraints,
        child: content,
      ),
    );
  }
}

/*
* 自定义弹窗样式
* @author wuxubaiyang
* @Time 2024/10/22 10:34
*/
class CustomDialogStyle {
  // 约束
  final BoxConstraints constraints;

  // 内容间距
  final EdgeInsetsGeometry contentPadding;

  // 传入样式与当前主题合并
  static CustomDialogStyle mergeOf(
          BuildContext context, CustomDialogStyle? r) =>
      CustomDialogThemeData.of(context).style.copyWith(
            constraints: r?.constraints,
            contentPadding: r?.contentPadding,
          );

  const CustomDialogStyle({
    this.constraints = const BoxConstraints(maxWidth: 280),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  });

  CustomDialogStyle copyWith({
    BoxConstraints? constraints,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return CustomDialogStyle(
      constraints: constraints ?? this.constraints,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  static CustomDialogStyle lerp(
      CustomDialogStyle? a, CustomDialogStyle? b, double t) {
    if (a == null && b == null) return CustomDialogStyle();
    return CustomDialogStyle(
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t)!,
      contentPadding:
          EdgeInsetsGeometry.lerp(a?.contentPadding, b?.contentPadding, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDialogStyle &&
          runtimeType == other.runtimeType &&
          constraints == other.constraints &&
          contentPadding == other.contentPadding;

  @override
  int get hashCode => Object.hashAll([
        constraints,
        contentPadding,
      ]);
}

/*
* 自定义弹窗样式
* @author wuxubaiyang
* @Time 2024/10/22 13:17
*/
class CustomDialogThemeData {
  // 样式
  final CustomDialogStyle style;

  const CustomDialogThemeData({
    this.style = const CustomDialogStyle(),
  });

  // 获取通知主题
  static CustomDialogThemeData of(BuildContext context) =>
      maybeOf(context) ?? const CustomDialogThemeData();

  // 获取通知主题
  static CustomDialogThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.customDialogTheme;

  CustomDialogThemeData copyWith({
    CustomDialogStyle? style,
  }) {
    return CustomDialogThemeData(
      style: style ?? this.style,
    );
  }

  static CustomDialogThemeData lerp(
      CustomDialogThemeData? a, CustomDialogThemeData? b, double t) {
    if (a == null && b == null) return CustomDialogThemeData();
    return CustomDialogThemeData(
      style: CustomDialogStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDialogThemeData &&
          runtimeType == other.runtimeType &&
          style == other.style;

  @override
  int get hashCode => Object.hashAll([
        style,
      ]);
}

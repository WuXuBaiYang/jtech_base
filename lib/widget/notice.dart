import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jtech_base/tool/notice.dart';

/*
* 消息通知组件
* @author wuxubaiyang
* @Time 2024/7/10 11:28
*/
class NoticeView extends StatelessWidget {
  // 标题
  final String? title;

  // 消息
  final String message;

  // 操作按钮
  final List<Widget> actions;

  // 消息状态
  final NoticeStatus status;

  // 样式
  final NoticeStyle? style;

  const NoticeView({
    super.key,
    this.title,
    required this.message,
    required this.actions,
    required this.status,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? NoticeThemeData.of(context).style;
    final shape = RoundedRectangleBorder(
      borderRadius: style.borderRadius,
    );
    return ConstrainedBox(
      constraints: style.constraints,
      child: Card(
        shape: shape,
        margin: style.margin,
        clipBehavior: Clip.antiAlias,
        elevation: style.elevation,
        color: style.backgroundColor,
        shadowColor: style.shadowColor,
        child: _buildMessage(context, style),
      ),
    );
  }

  // 构建内容消息
  Widget _buildMessage(BuildContext context, NoticeStyle style) {
    return Padding(
      padding: style.padding,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        style.noticeIcon.getStatusIcon(status),
        SizedBox(width: style.space),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(title!, style: style.getTitleStyle(context)),
              Text(message, style: style.getMessageStyle(context)),
            ],
          ),
        ),
        if (actions.isNotEmpty) ...[
          SizedBox(width: style.space),
          ...actions,
        ],
      ]),
    );
  }
}

// 消息通知-样式
class NoticeStyle {
  // 约束
  final BoxConstraints constraints;

  // 卡片背景色
  final Color? backgroundColor;

  // 卡片圆角
  final BorderRadius borderRadius;

  // 卡片阴影颜色
  final Color shadowColor;

  // 悬浮高度
  final double? elevation;

  // 标题字体样式
  final TextStyle? titleStyle;

  // 消息字体样式
  final TextStyle? messageStyle;

  // 图标管理
  final NoticeIcon noticeIcon;

  // 元素间距
  final double space;

  // 内间距
  final EdgeInsetsGeometry padding;

  // 外间距
  final EdgeInsetsGeometry margin;

  const NoticeStyle({
    this.elevation,
    this.titleStyle,
    this.space = 14,
    this.messageStyle,
    this.backgroundColor,
    this.shadowColor = Colors.black38,
    this.noticeIcon = const NoticeIcon(),
    this.margin = const EdgeInsets.all(14),
    this.padding = const EdgeInsets.all(14),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.constraints = const BoxConstraints(maxWidth: 350, minWidth: 80),
  });

  // 获取标题样式
  TextStyle? getTitleStyle(BuildContext context) =>
      titleStyle ??
      Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w600);

  // 获取消息样式
  TextStyle? getMessageStyle(BuildContext context) =>
      messageStyle ?? Theme.of(context).textTheme.bodyMedium;

  NoticeStyle copyWith({
    BoxConstraints? constraints,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Color? shadowColor,
    double? elevation,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    NoticeIcon? noticeIcon,
    double? space,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return NoticeStyle(
      constraints: constraints ?? this.constraints,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      titleStyle: titleStyle ?? this.titleStyle,
      messageStyle: messageStyle ?? this.messageStyle,
      noticeIcon: noticeIcon ?? this.noticeIcon,
      space: space ?? this.space,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  static NoticeStyle lerp(NoticeStyle? a, NoticeStyle? b, double t) {
    if (a == null && b == null) return NoticeStyle();
    return NoticeStyle(
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t) ??
          const BoxConstraints(),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t) ??
          BorderRadius.zero,
      shadowColor:
          Color.lerp(a?.shadowColor, b?.shadowColor, t) ?? Colors.black,
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      titleStyle: TextStyle.lerp(a?.titleStyle, b?.titleStyle, t),
      messageStyle: TextStyle.lerp(a?.messageStyle, b?.messageStyle, t),
      noticeIcon: NoticeIcon.lerp(a?.noticeIcon, b?.noticeIcon, t),
      space: lerpDouble(a?.space, b?.space, t) ?? 14,
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t) ??
          const EdgeInsets.all(14),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t) ??
          const EdgeInsets.all(14),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeStyle &&
          runtimeType == other.runtimeType &&
          constraints == other.constraints &&
          backgroundColor == other.backgroundColor &&
          borderRadius == other.borderRadius &&
          shadowColor == other.shadowColor &&
          elevation == other.elevation &&
          titleStyle == other.titleStyle &&
          messageStyle == other.messageStyle &&
          noticeIcon == other.noticeIcon &&
          space == other.space &&
          padding == other.padding &&
          margin == other.margin;

  @override
  int get hashCode => Object.hashAll([
        constraints,
        backgroundColor,
        borderRadius,
        shadowColor,
        elevation,
        titleStyle,
        messageStyle,
        noticeIcon,
        space,
        padding,
        margin,
      ]);
}

/*
* 消息通知-图标
* @author wuxubaiyang
* @Time 2024/10/16 17:02
*/
class NoticeIcon {
  // 图标大小
  final double iconSize;

  // 成功图标
  final Widget? successIcon;

  // 错误图标
  final Widget? errorIcon;

  // 警告图标
  final Widget? warningIcon;

  // 普通图标
  final Widget? infoIcon;

  const NoticeIcon({
    this.infoIcon,
    this.errorIcon,
    this.warningIcon,
    this.successIcon,
    this.iconSize = 35,
  });

  // 根据状态获取图标
  Widget getStatusIcon(NoticeStatus status) {
    return getCustomIcon(status) ??
        Icon(getDefaultIcon(status),
            size: iconSize, color: getDefaultIconColor(status));
  }

  // 获取自定义图标
  Widget? getCustomIcon(NoticeStatus status) {
    return switch (status) {
      NoticeStatus.success => successIcon,
      NoticeStatus.error => errorIcon,
      NoticeStatus.warning => warningIcon,
      NoticeStatus.info => infoIcon,
    };
  }

  // 获取icon
  IconData getDefaultIcon(NoticeStatus status) {
    return switch (status) {
      NoticeStatus.success => Icons.check_circle,
      NoticeStatus.error => Icons.error,
      NoticeStatus.warning => Icons.warning,
      NoticeStatus.info => Icons.info,
    };
  }

  // 根据状态获取图标颜色
  Color getDefaultIconColor(NoticeStatus status) {
    return switch (status) {
      NoticeStatus.success => Colors.green,
      NoticeStatus.error => Colors.red,
      NoticeStatus.warning => Colors.orange,
      NoticeStatus.info => Colors.blue,
    };
  }

  NoticeIcon copyWith({
    double? iconSize,
    Widget? successIcon,
    Widget? errorIcon,
    Widget? warningIcon,
    Widget? infoIcon,
  }) {
    return NoticeIcon(
      iconSize: iconSize ?? this.iconSize,
      successIcon: successIcon ?? this.successIcon,
      errorIcon: errorIcon ?? this.errorIcon,
      warningIcon: warningIcon ?? this.warningIcon,
      infoIcon: infoIcon ?? this.infoIcon,
    );
  }

  static NoticeIcon lerp(NoticeIcon? a, NoticeIcon? b, double t) {
    if (a == null && b == null) return NoticeIcon();
    return NoticeIcon(
      iconSize: lerpDouble(a?.iconSize, b?.iconSize, t) ?? 35,
      successIcon: t < 0.5 ? a?.successIcon : b?.successIcon,
      errorIcon: t < 0.5 ? a?.errorIcon : b?.errorIcon,
      warningIcon: t < 0.5 ? a?.warningIcon : b?.warningIcon,
      infoIcon: t < 0.5 ? a?.infoIcon : b?.infoIcon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeIcon &&
          runtimeType == other.runtimeType &&
          iconSize == other.iconSize &&
          successIcon == other.successIcon &&
          errorIcon == other.errorIcon &&
          warningIcon == other.warningIcon &&
          infoIcon == other.infoIcon;

  @override
  int get hashCode => Object.hashAll([
        iconSize,
        successIcon,
        errorIcon,
        warningIcon,
        infoIcon,
      ]);
}

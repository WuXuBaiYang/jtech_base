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

  // 装饰器
  final NoticeDecoration decoration;

  const NoticeView({
    super.key,
    this.title,
    required this.message,
    required this.actions,
    required this.status,
    this.decoration = const NoticeDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: decoration.borderRadius,
    );
    return ConstrainedBox(
      constraints: decoration.constraints,
      child: Card(
        shape: shape,
        margin: decoration.margin,
        clipBehavior: Clip.antiAlias,
        elevation: decoration.elevation,
        color: decoration.backgroundColor,
        shadowColor: decoration.shadowColor,
        child: _buildMessage(context),
      ),
    );
  }

  // 构建内容消息
  Widget _buildMessage(BuildContext context) {
    final titleStyle = decoration.titleStyle ??
        Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600);
    final messageStyle =
        decoration.messageStyle ?? Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: decoration.padding,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        decoration.noticeIcon.getStatusIcon(status),
        SizedBox(width: decoration.space),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) Text(title!, style: titleStyle),
            Text(message, style: messageStyle),
          ],
        ),
        if (actions.isNotEmpty) ...[
          SizedBox(width: decoration.space),
          ...actions,
        ],
      ]),
    );
  }
}

// 消息通知-装饰器
class NoticeDecoration {
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

  const NoticeDecoration({
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
}
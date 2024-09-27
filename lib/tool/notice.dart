import 'dart:async';

import 'package:flutter/material.dart';

/*
* 消息通知工具
* @author wuxubaiyang
* @Time 2024/4/30 10:37
*/
class Notice {
  // 显示提示信息
  static OverlayEntry? show(
    BuildContext context, {
    required String message,
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
    NoticeStatus status = NoticeStatus.info,
    Duration duration = const Duration(milliseconds: 1400),
    Duration animeDuration = const Duration(milliseconds: 340),
  }) {
    OverlayEntry? overlayEntry;
    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return overlayEntry;
    final controller = AnimationController(
      vsync: overlayState,
      duration: animeDuration,
    )..forward();
    dispose(bool isAnime) async {
      if (isAnime) await controller.reverse();
      overlayEntry?.remove();
      controller.dispose();
    }

    overlayEntry = OverlayEntry(builder: (_) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutBack,
        )),
        child: NoticeView(
          title: title,
          status: status,
          message: message,
          actions: actions,
          onDismiss: dispose,
        ),
      );
    });
    overlayState.insert(overlayEntry);
    // 一定时间后移除
    if (!onGoing) Timer(duration, () => dispose(overlayState.mounted));
    return overlayEntry;
  }

  // 显示成功提示信息
  static OverlayEntry? showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
  }) {
    return show(
      context,
      title: title,
      message: message,
      actions: actions,
      onGoing: onGoing,
      status: NoticeStatus.success,
    );
  }

  // 显示错误提示信息
  static OverlayEntry? showError(
    BuildContext context, {
    required String message,
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
  }) {
    return show(
      context,
      title: title,
      message: message,
      actions: actions,
      onGoing: onGoing,
      status: NoticeStatus.error,
    );
  }

  // 显示警告提示信息
  static OverlayEntry? showWarning(
    BuildContext context, {
    required String message,
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
  }) {
    return show(
      context,
      title: title,
      message: message,
      actions: actions,
      onGoing: onGoing,
      status: NoticeStatus.warning,
    );
  }

  // 显示普通提示信息
  static OverlayEntry? showInfo(
    BuildContext context, {
    required String message,
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
  }) {
    return show(
      context,
      title: title,
      message: message,
      actions: actions,
      onGoing: onGoing,
      status: NoticeStatus.info,
    );
  }
}

// 消息状态枚举
enum NoticeStatus {
  success,
  error,
  warning,
  info,
}

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

  // 外间距
  final EdgeInsetsGeometry margin;

  // 内间距
  final EdgeInsetsGeometry padding;

  // 主动撤销回调
  final ValueChanged<bool>? onDismiss;

  const NoticeView({
    super.key,
    this.title,
    required this.message,
    required this.actions,
    required this.status,
    this.onDismiss,
    this.margin = const EdgeInsets.all(14),
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.topCenter,
          child: Dismissible(
            key: ValueKey(message),
            direction: DismissDirection.up,
            onDismissed: (_) => onDismiss?.call(false),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  // 构建内容
  Widget _buildContent(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(14),
      child: ListTile(
        leading: Icon(_statusIcon, color: _statusColor, size: 35),
        subtitle: Text(
          message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        title: title == null
            ? null
            : Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  // 获取状态图标
  IconData get _statusIcon => switch (status) {
        NoticeStatus.success => Icons.check_circle,
        NoticeStatus.error => Icons.error,
        NoticeStatus.warning => Icons.warning,
        NoticeStatus.info => Icons.info,
      };

  // 获取状态颜色
  Color get _statusColor => switch (status) {
        NoticeStatus.success => Colors.green,
        NoticeStatus.error => Colors.red,
        NoticeStatus.warning => Colors.orange,
        NoticeStatus.info => Colors.blue,
      };
}

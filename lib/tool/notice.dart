import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
import 'package:jtech_base/widget/notice.dart';
import 'overlay.dart';

/*
* 消息通知工具
* @author wuxubaiyang
* @Time 2024/4/30 10:37
*/
class Notice {
  // 弹层管理
  static final _customOverlay = CustomOverlay();

  // 显示提示信息
  static Future<T?> show<T>(
    BuildContext context, {
    required String message,
    String? key,
    Curve? curve,
    bool? onGoing,
    String? title,
    Duration? duration,
    Curve? reverseCurve,
    Duration? animeDuration,
    NoticeDecoration? decoration,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
    NoticeStatus status = NoticeStatus.info,
  }) {
    token ??= CustomOverlayToken<T>();
    final customTheme = CustomTheme.of(context);
    onGoing ??= customTheme?.noticeOnGoing ?? false;
    curve ??= customTheme?.noticeCurve ?? Curves.bounceInOut;
    decoration ??= customTheme?.noticeDecoration ?? const NoticeDecoration();
    reverseCurve ??= customTheme?.noticeReverseCurve ?? Curves.easeInOutBack;
    duration ??=
        customTheme?.noticeDuration ?? const Duration(milliseconds: 1800);
    animeDuration ??=
        customTheme?.noticeAnimeDuration ?? const Duration(milliseconds: 240);
    final noticeTimer = _NoticeTimer(
        autoStart: true,
        func: token.cancel,
        duration: duration,
        isEffective: !onGoing);
    return _customOverlay.insert<T>(
      context,
      key: key,
      token: token,
      dismissible: false,
      interceptPop: false,
      alignment: Alignment.topCenter,
      animationDuration: animeDuration,
      builder: (_, animation, __) {
        return SafeArea(
          child: Dismissible(
            direction: DismissDirection.up,
            onDismissed: (_) => token?.cancel(null, false),
            onUpdate: (details) =>
                noticeTimer.pauseOrResume(details.progress > 0),
            key: ValueKey(DateTime.now().microsecondsSinceEpoch),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                curve: curve!,
                parent: animation,
                reverseCurve: reverseCurve,
              )),
              child: NoticeView(
                title: title,
                status: status,
                message: message,
                actions: actions,
                decoration: decoration,
              ),
            ),
          ),
        );
      },
    );
  }

  // 显示成功提示信息
  static Future<T?> showSuccess<T>(
    BuildContext context, {
    required String message,
    String? key,
    Curve? curve,
    bool? onGoing,
    String? title,
    Curve? reverseCurve,
    NoticeDecoration? decoration,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
  }) {
    return show<T>(
      context,
      key: key,
      curve: curve,
      title: title,
      token: token,
      message: message,
      actions: actions,
      onGoing: onGoing,
      decoration: decoration,
      reverseCurve: reverseCurve,
      status: NoticeStatus.success,
    );
  }

  // 显示错误提示信息
  static Future<T?> showError<T>(
    BuildContext context, {
    required String message,
    String? key,
    Curve? curve,
    bool? onGoing,
    String? title,
    Curve? reverseCurve,
    NoticeDecoration? decoration,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
  }) {
    return show<T>(
      context,
      key: key,
      curve: curve,
      title: title,
      token: token,
      message: message,
      actions: actions,
      onGoing: onGoing,
      decoration: decoration,
      status: NoticeStatus.error,
      reverseCurve: reverseCurve,
    );
  }

  // 显示警告提示信息
  static Future<T?> showWarning<T>(
    BuildContext context, {
    required String message,
    String? key,
    Curve? curve,
    bool? onGoing,
    String? title,
    Curve? reverseCurve,
    NoticeDecoration? decoration,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
  }) {
    return show<T>(
      context,
      key: key,
      title: title,
      token: token,
      curve: curve,
      message: message,
      actions: actions,
      onGoing: onGoing,
      decoration: decoration,
      reverseCurve: reverseCurve,
      status: NoticeStatus.warning,
    );
  }

  // 显示普通提示信息
  static Future<T?> showInfo<T>(
    BuildContext context, {
    required String message,
    String? key,
    Curve? curve,
    bool? onGoing,
    String? title,
    Curve? reverseCurve,
    NoticeDecoration? decoration,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
  }) {
    return show<T>(
      context,
      key: key,
      curve: curve,
      title: title,
      token: token,
      message: message,
      actions: actions,
      onGoing: onGoing,
      decoration: decoration,
      status: NoticeStatus.info,
      reverseCurve: reverseCurve,
    );
  }
}

/*
* 自动取消定时器
* @author wuxubaiyang
* @Time 2024/10/18 9:53
*/
class _NoticeTimer {
  // 计时器是否生效
  final bool _isEffective;

  // 计时时长
  final Duration duration;

  // 事件
  final VoidCallback? func;

  _NoticeTimer({
    this.func,
    bool autoStart = true,
    bool isEffective = true,
    this.duration = const Duration(milliseconds: 1800),
  }) : _isEffective = isEffective {
    if (autoStart) start();
  }

  // 计时器
  Timer? _timer;

  // 暂停或恢复定时器
  void pauseOrResume(bool pause) => pause ? cancel() : start();

  // 启动定时器
  void start() {
    cancel();
    if (!_isEffective) return;
    _timer = Timer(duration, () => func?.call());
  }

  // 销毁定时器
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

// 消息状态枚举
enum NoticeStatus {
  success,
  error,
  warning,
  info,
}

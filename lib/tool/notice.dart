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
    NoticeStyle? style,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
    NoticeStatus status = NoticeStatus.info,
  }) {
    token ??= CustomOverlayToken<T>();
    final themeData = NoticeThemeData.of(context);
    final noticeTimer = _NoticeTimer(
        autoStart: true,
        func: token.cancel,
        duration: duration ?? themeData.duration,
        isEffective: !(onGoing ?? themeData.onGoing));
    return _customOverlay.insert<T>(
      context,
      key: key,
      token: token,
      dismissible: false,
      interceptPop: false,
      alignment: Alignment.topCenter,
      animationDuration: animeDuration ?? themeData.animeDuration,
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
                parent: animation,
                curve: curve ?? themeData.curve,
                reverseCurve: reverseCurve ?? themeData.reverseCurve,
              )),
              child: NoticeView(
                title: title,
                status: status,
                message: message,
                actions: actions,
                style: style ?? themeData.style,
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
    NoticeStyle? style,
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
      style: style,
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
    NoticeStyle? style,
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
      style: style,
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
    NoticeStyle? style,
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
      style: style,
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
    NoticeStyle? style,
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
      style: style,
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

/*
* 通知配置
* @author wuxubaiyang
* @Time 2024/10/22 11:22
*/
class NoticeThemeData {
  // 通知样式
  final NoticeStyle style;

  // 通知是否持续
  final bool onGoing;

  // 通知动画曲线
  final Curve curve;

  // 通知反向动画曲线
  final Curve reverseCurve;

  // 通知持续时间
  final Duration duration;

  // 通知动画持续时间
  final Duration animeDuration;

  const NoticeThemeData({
    this.onGoing = false,
    this.curve = Curves.bounceInOut,
    this.reverseCurve = Curves.easeInOutBack,
    this.style = const NoticeStyle(),
    this.duration = const Duration(milliseconds: 1800),
    this.animeDuration = const Duration(milliseconds: 240),
  });

  // 获取通知主题
  static NoticeThemeData of(BuildContext context) =>
      maybeOf(context) ?? const NoticeThemeData();

  // 获取通知主题
  static NoticeThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.noticeTheme;

  NoticeThemeData copyWith({
    NoticeStyle? style,
    bool? onGoing,
    Curve? curve,
    Curve? reverseCurve,
    Duration? duration,
    Duration? animeDuration,
  }) {
    return NoticeThemeData(
      style: style ?? this.style,
      onGoing: onGoing ?? this.onGoing,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      duration: duration ?? this.duration,
      animeDuration: animeDuration ?? this.animeDuration,
    );
  }

  static NoticeThemeData lerp(
      NoticeThemeData? a, NoticeThemeData? b, double t) {
    if (a == null && b == null) return NoticeThemeData();
    return NoticeThemeData(
      style: NoticeStyle.lerp(a?.style, b?.style, t),
      onGoing: t < 0.5 ? a?.onGoing ?? false : b?.onGoing ?? false,
      curve: t < 0.5
          ? a?.curve ?? Curves.bounceInOut
          : b?.curve ?? Curves.bounceInOut,
      reverseCurve: t < 0.5
          ? a?.reverseCurve ?? Curves.easeInOutBack
          : b?.reverseCurve ?? Curves.easeInOutBack,
      duration: (t < 0.5 ? a?.duration : b?.duration) ??
          const Duration(milliseconds: 1800),
      animeDuration: (t < 0.5 ? a?.animeDuration : b?.animeDuration) ??
          const Duration(milliseconds: 240),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeThemeData &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          onGoing == other.onGoing &&
          curve == other.curve &&
          reverseCurve == other.reverseCurve &&
          duration == other.duration &&
          animeDuration == other.animeDuration;

  @override
  int get hashCode => Object.hashAll([
        style,
        onGoing,
        curve,
        reverseCurve,
        duration,
        animeDuration,
      ]);
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
import 'package:jtech_base/widget/overlay.dart';

/*
* 自定义覆盖物
* @author wuxubaiyang
* @Time 2024/10/17 8:38
*/
class CustomOverlay {
  // 弹层凭证
  final _overlayTokens = <String, CustomOverlayToken>{};

  // 最大弹层数
  final int _maxCount;

  CustomOverlay({
    int maxCount = 999,
  })  : assert(maxCount >= 1, 'maxCount must be greater than 0'),
        _maxCount = maxCount;

  CustomOverlay.single() : _maxCount = 1;

  // 插入弹层
  Future<T?> insert<T>(
    BuildContext context, {
    required AnimatedTransitionBuilder builder,
    String? key,
    Widget? child,
    bool opaque = false,
    bool replace = true, // 如果数量超过限制，是否替换最早的弹层,false则不弹出
    Color? barrierColor,
    bool dismissible = false,
    bool interceptPop = true,
    VoidCallback? onOutsideTap,
    bool maintainState = false,
    bool canSizeOverlay = false,
    Duration? animationDuration,
    CustomOverlayToken<T>? token,
    AlignmentGeometry alignment = Alignment.center,
  }) async {
    // 检查弹层数量是否超出限制以及是否需要移除
    if (!_checkOverlayCount(replace)) return null;
    // 创建初始化字段
    OverlayEntry? overlayEntry;
    token ??= CustomOverlayToken<T>();
    final overlayState = Overlay.of(context);
    key ??= DateTime.now().microsecondsSinceEpoch.toString();
    final themeData = CustomOverlayThemeData.of(context);
    final animation = _OverlayAnimation(
        vsync: overlayState,
        duration: animationDuration ?? themeData.animationDuration);
    final overlayPop = _OverlayPop<T>(context,
        canPop: true,
        overlayKey: key,
        autoRegister: interceptPop,
        onPop: (v) => cancel(key!, v),
        onDidPop: () => animation.dispose());
    try {
      // 插入覆盖层
      overlayState.insert(overlayEntry = OverlayEntry(
        opaque: opaque,
        maintainState: maintainState,
        canSizeOverlay: canSizeOverlay,
        builder: (context) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => animation.forward());
          return CustomOverlayView(
            alignment: alignment,
            barrierColor: barrierColor,
            barrierAnimation: animation.barrier,
            overlayAnimation: animation.overlay,
            onOutsideTap: () {
              if (onOutsideTap != null) return onOutsideTap();
              if (dismissible) cancel(key!);
            },
            builder: (_, child) {
              return builder(context, animation.overlay, child);
            },
            child: child,
          );
        },
      ));
      // 处理弹层后续事件
      final result = await (_overlayTokens[key] = token).whenCancel;
      if (token.withAnime) await animation.reverse();
      return result;
    } catch (e) {
      if (kDebugMode) print('弹窗异常：${e.toString()}');
    } finally {
      animation.dispose();
      overlayEntry?.remove();
      overlayPop.unregister();
      _overlayTokens.remove(key);
    }
    return null;
  }

  // 根据key取消弹层
  bool cancel<T extends Object?>(String key, [T? result]) {
    final token = _overlayTokens.remove(key);
    if (token == null) return false;
    token.cancel(result);
    return true;
  }

  // 取消全部弹层
  void cancelAll() {
    _overlayTokens.forEach((_, v) => v.cancel());
    _overlayTokens.clear();
  }

  // 检查弹层数量
  bool _checkOverlayCount(bool replace) {
    if (_overlayTokens.length >= _maxCount) {
      if (!replace) return false;
      cancel(_overlayTokens.keys.first);
    }
    return true;
  }
}

/*
* 动画管理
* @author wuxubaiyang
* @Time 2024/10/18 8:54
*/
class _OverlayAnimation {
  // 遮罩动画
  final AnimationController _barrierController;

  // 覆盖物动画
  final AnimationController _overlayController;

  // 动画控制器
  final Tween<double> tween;

  _OverlayAnimation({
    required TickerProvider vsync,
    double end = 1,
    double begin = 0,
    Duration duration = const Duration(milliseconds: 130),
  })  : tween = Tween<double>(begin: begin, end: end),
        _barrierController =
            AnimationController(vsync: vsync, duration: duration),
        _overlayController =
            AnimationController(vsync: vsync, duration: duration);

  // 获取遮罩动画
  Animation<double> get barrier => tween.animate(_barrierController);

  // 获取覆盖物动画
  Animation<double> get overlay => tween.animate(_overlayController);

  // 正向动画
  Future<void> forward() async {
    await Future.wait([
      _barrierController.forward(),
      _overlayController.forward(),
    ]);
  }

  // 反向动画
  Future<void> reverse() async {
    if (!_isCompleted) return;
    await Future.wait([
      _barrierController.reverse(),
      _overlayController.reverse(),
    ]);
  }

  // 判断是否处于销毁状态
  bool get _isDismissed =>
      _barrierController.isDismissed && _overlayController.isDismissed;

  // 动画是否处于完成状态
  bool get _isCompleted =>
      _barrierController.isCompleted && _overlayController.isCompleted;

  // 动画销毁
  void dispose() {
    if (_isDismissed) return;
    _barrierController.dispose();
    _overlayController.dispose();
  }
}

/*
* 路由pop拦截
* @author wuxubaiyang
* @Time 2024/10/17 17:30
*/
class _OverlayPop<T> implements PopEntry<T> {
  // 上下文
  final BuildContext context;

  // overlay覆盖层key
  final String overlayKey;

  // 是否拦截pop
  final bool canPop;

  // didPop回调
  final VoidCallback? onDidPop;

  // pop回调
  final ValueChanged<T?>? onPop;

  // 是否自动注册
  final bool autoRegister;

  _OverlayPop(
    this.context, {
    required this.overlayKey,
    this.onPop,
    this.onDidPop,
    this.canPop = false,
    this.autoRegister = true,
  }) {
    if (!autoRegister) return;
    final modalRoute = ModalRoute.of(context);
    modalRoute?.registerPopEntry(this);
  }

  // 注销拦截
  void unregister() {
    if (!autoRegister) return;
    final modalRoute = ModalRoute.of(context);
    modalRoute?.unregisterPopEntry(this);
  }

  @override
  void onPopInvoked(bool didPop) => throw UnimplementedError();

  @override
  void onPopInvokedWithResult(bool didPop, T? result) {
    if (didPop) return onDidPop?.call();
    onPop?.call(result);
  }

  @override
  late final ValueNotifier<bool> canPopNotifier = ValueNotifier(canPop);
}

/*
* 自定义覆盖物凭证
* @author wuxubaiyang
* @Time 2024/10/17 8:39
*/
class CustomOverlayToken<T> {
  final _completer = Completer<T?>();

  CustomOverlayToken();

  T? _data;

  T? get data => _data;

  bool _withAnime = true;

  bool get withAnime => _withAnime;

  bool get isFinish => _completer.isCompleted;

  Future<T?> get whenCancel => _completer.future;

  void cancel([T? data, bool withAnime = true]) {
    _withAnime = withAnime;
    if (!_completer.isCompleted) _completer.complete(data);
    _data = data;
  }
}

/*
* 自定义覆盖物样式
* @author wuxubaiyang
* @Time 2024/10/22 13:15
*/
class CustomOverlayThemeData {
  // 动画时间
  final Duration animationDuration;

  const CustomOverlayThemeData({
    this.animationDuration = const Duration(milliseconds: 130),
  });

  // 获取通知主题
  static CustomOverlayThemeData of(BuildContext context) =>
      maybeOf(context) ?? const CustomOverlayThemeData();

  // 获取通知主题
  static CustomOverlayThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.customOverlayTheme;
}

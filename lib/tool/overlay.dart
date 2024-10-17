import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

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
    VoidCallback? onOutsideTap,
    bool maintainState = false,
    bool canSizeOverlay = false,
    CustomOverlayToken<T>? token,
    AlignmentGeometry alignment = Alignment.center,
    Duration animationDuration = const Duration(milliseconds: 130),
  }) async {
    OverlayEntry? overlayEntry;
    final modalRoute = ModalRoute.of(context);
    if (_overlayTokens.length >= _maxCount) {
      if (!replace) return null;
      cancel(_overlayTokens.keys.first);
    }
    token ??= CustomOverlayToken<T>();
    key ??= DateTime.now().microsecondsSinceEpoch.toString();
    final overlayState = Overlay.of(context);
    // 创建动画控制器并装载动画
    final tween = Tween<double>(begin: 0, end: 1);
    final barrierController = AnimationController(
            vsync: overlayState, duration: animationDuration),
        overlayController = AnimationController(
            vsync: overlayState, duration: animationDuration);
    // 拦截路由pop
    final popEntry = _OverlayPopEntry<T>(
      canPop: dismissible,
      onPopWithResult: (didPop, result) {
        if (dismissible && didPop) token?.cancel(result);
      },
    );
    modalRoute?.registerPopEntry(popEntry);
    // 插入覆盖层
    overlayState.insert(overlayEntry = OverlayEntry(
      opaque: opaque,
      maintainState: maintainState,
      canSizeOverlay: canSizeOverlay,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          barrierController.forward();
          overlayController.forward();
        });
        return CustomOverlayView(
          alignment: alignment,
          barrierColor: barrierColor,
          barrierAnimation: tween.animate(barrierController),
          overlayAnimation: tween.animate(overlayController),
          onOutsideTap: () {
            if (onOutsideTap != null) return onOutsideTap();
            if (dismissible) token?.cancel();
          },
          builder: (_, child) =>
              builder(context, overlayController.view, child),
          child: child,
        );
      },
    ));
    // 处理弹层后续事件
    _overlayTokens[key] = token;
    return token.whenCancel.then((result) async {
      if (token?.withAnime != true) return result;
      await Future.wait([
        barrierController.reverse(),
        overlayController.reverse(),
      ]);
      return result;
    }).whenComplete(() {
      modalRoute?.unregisterPopEntry(popEntry);
      barrierController.dispose();
      overlayController.dispose();
      _overlayTokens.remove(key);
      overlayEntry?.remove();
    });
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
}

/*
* 路由pop拦截
* @author wuxubaiyang
* @Time 2024/10/17 17:30
*/
class _OverlayPopEntry<T> implements PopEntry<T> {
  // 是否可以pop
  final bool canPop;

  // pop回调
  final PopInvokedWithResultCallback<T>? onPopWithResult;

  _OverlayPopEntry({
    this.canPop = false,
    this.onPopWithResult,
  });

  @override
  void onPopInvoked(bool didPop) => throw UnimplementedError();

  @override
  void onPopInvokedWithResult(bool didPop, T? result) =>
      onPopWithResult?.call(didPop, result);

  @override
  late final ValueNotifier<bool> canPopNotifier = ValueNotifier(false);
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

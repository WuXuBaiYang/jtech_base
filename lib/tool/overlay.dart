import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    required WidgetBuilder builder,
    String? key,
    bool opaque = false,
    bool replace = true, // 如果数量超过限制，是否替换最早的弹层,false则不弹出
    Color? barrierColor,
    bool dismissible = false,
    VoidCallback? onOutsideTap,
    bool maintainState = false,
    bool canSizeOverlay = false,
    CustomOverlayToken<T>? token,
    AsyncCallback? onBeforeCancel,
    AlignmentGeometry alignment = Alignment.center,
  }) async {
    OverlayEntry? overlayEntry;
    if (_overlayTokens.length >= _maxCount) {
      if (!replace) return null;
      cancel(_overlayTokens.keys.first);
    }
    // 销毁弹层方法
    Future<T?> dispose(T? result) async {
      await onBeforeCancel?.call();
      _overlayTokens.remove(key);
      overlayEntry?.remove();
      return result;
    }

    token ??= CustomOverlayToken<T>();
    key ??= DateTime.now().microsecondsSinceEpoch.toString();
    Overlay.of(context).insert(overlayEntry = OverlayEntry(
      opaque: opaque,
      maintainState: maintainState,
      canSizeOverlay: canSizeOverlay,
      builder: (context) {
        final onTap =
            onOutsideTap ?? (dismissible ? () => dispose(null) : null);
        return GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: Material(
              color: barrierColor,
              type: MaterialType.transparency,
              child: Align(
                alignment: alignment,
                child: builder(context),
              ),
            ),
          ),
        );
      },
    ));
    _overlayTokens[key] = token;
    return token.whenCancel.then(dispose);
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
* 自定义覆盖物凭证
* @author wuxubaiyang
* @Time 2024/10/17 8:39
*/
class CustomOverlayToken<T> {
  final _completer = Completer<T?>();

  CustomOverlayToken();

  T? _data;

  T? get data => _data;

  bool get isFinish => _completer.isCompleted;

  Future<T?> get whenCancel => _completer.future;

  void cancel([T? data]) {
    if (!_completer.isCompleted) _completer.complete(data);
    _data = data;
  }
}

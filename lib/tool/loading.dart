import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jtech_base/widget/loading/overlay.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2023/7/19 16:43
*/
class Loading {
  // 弹层缓存(全局同时有且只有一个)
  static OverlayEntry? _loading;

  // 展示加载弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required Future<T?> loadFuture,
    Color? loadingColor,
    int loadingIndex = -1,
    Color? backgroundColor,
    bool dismissible = true,
    double loadingSize = 48,
    Stream<double>? progressStream,
    Color barrierColor = Colors.black38,
    BoxConstraints constraints =
        const BoxConstraints.tightFor(width: 80, height: 80),
  }) async {
    cancel();
    try {
      Overlay.of(context).insert(_loading = OverlayEntry(builder: (_) {
        return FutureLoadingOverlay(
          onCancel: () {
            if (dismissible) cancel();
          },
          constraints: constraints,
          loadingSize: loadingSize,
          barrierColor: barrierColor,
          loadingIndex: loadingIndex,
          loadingColor: loadingColor,
          progressStream: progressStream,
          backgroundColor: backgroundColor,
        );
      }));
      return await loadFuture;
    } catch (e) {
      rethrow;
    } finally {
      cancel();
    }
  }

  // 取消加载弹窗
  static void cancel() {
    _loading?.remove();
    _loading = null;
  }
}

// 扩展future方法实现loading
extension FutureLoading<T> on Future<T> {
  Future<T?> loading(
    BuildContext context, {
    Color? loadingColor,
    int loadingIndex = -1,
    Color? backgroundColor,
    bool dismissible = true,
    double loadingSize = 48,
    Stream<double>? progressStream,
    Color barrierColor = Colors.black38,
    BoxConstraints constraints =
        const BoxConstraints.tightFor(width: 80, height: 80),
  }) =>
      Loading.show(
        context,
        loadFuture: this,
        constraints: constraints,
        dismissible: dismissible,
        loadingSize: loadingSize,
        loadingIndex: loadingIndex,
        barrierColor: barrierColor,
        loadingColor: loadingColor,
        progressStream: progressStream,
        backgroundColor: backgroundColor,
      );
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jtech_base/tool/overlay.dart';
import 'package:jtech_base/widget/loading/overlay.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2023/7/19 16:43
*/
class Loading {
  // 弹层管理
  static final _customOverlay = CustomOverlay.single();

  // 展示加载弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required Future<T?> loadFuture,
    bool dismissible = true,
    Stream<double>? progressStream,
    Color barrierColor = Colors.black38,
    LoadingOverlayDecoration decoration = const LoadingOverlayDecoration(),
  }) async {
    cancel();
    try {
      _customOverlay.insert(
        context,
        dismissible: dismissible,
        barrierColor: barrierColor,
        alignment: Alignment.center,
        builder: (_) {
          return LoadingOverlay(
            decoration: decoration,
            progressStream: progressStream,
          );
        },
      );
      return await loadFuture;
    } catch (e) {
      rethrow;
    } finally {
      cancel();
    }
  }

  // 取消加载弹窗
  static void cancel() => _customOverlay.cancelAll();
}

// 扩展future方法实现loading
extension FutureLoading<T> on Future<T> {
  Future<T?> loading(
    BuildContext context, {
    bool dismissible = true,
    Stream<double>? progressStream,
    Color barrierColor = Colors.black38,
    LoadingOverlayDecoration decoration = const LoadingOverlayDecoration(),
  }) =>
      Loading.show(
        context,
        loadFuture: this,
        decoration: decoration,
        dismissible: dismissible,
        barrierColor: barrierColor,
        progressStream: progressStream,
      );
}

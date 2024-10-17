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
    String? key,
    bool dismissible = true,
    Stream<double>? progressStream,
    Curve curve = Curves.easeInOut,
    Color barrierColor = Colors.black38,
    Curve reverseCurve = Curves.easeInOutBack,
    LoadingOverlayDecoration decoration = const LoadingOverlayDecoration(),
  }) async {
    _customOverlay.cancelAll();
    key ??= DateTime.now().microsecondsSinceEpoch.toString();
    try {
      _customOverlay.insert(
        context,
        key: key,
        dismissible: dismissible,
        barrierColor: barrierColor,
        alignment: Alignment.center,
        builder: (_, animation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              curve: curve,
              parent: animation,
              reverseCurve: reverseCurve,
            ),
            child: child,
          );
        },
        child: LoadingOverlay(
          progressStream: progressStream,
          decoration: decoration,
        ),
      );
      return await loadFuture;
    } catch (e) {
      rethrow;
    } finally {
      _customOverlay.cancel(key);
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
    Curve curve = Curves.easeInOut,
    Color barrierColor = Colors.black38,
    Curve reverseCurve = Curves.easeInOutBack,
    LoadingOverlayDecoration decoration = const LoadingOverlayDecoration(),
  }) =>
      Loading.show(
        context,
        curve: curve,
        loadFuture: this,
        decoration: decoration,
        dismissible: dismissible,
        reverseCurve: reverseCurve,
        barrierColor: barrierColor,
        progressStream: progressStream,
      );
}

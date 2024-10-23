import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
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
    Curve? curve,
    bool? dismissible,
    Color? barrierColor,
    Curve? reverseCurve,
    Alignment? alignment,
    Stream<double>? progressStream,
    LoadingOverlayDecoration? decoration,
  }) async {
    _customOverlay.cancelAll();
    key ??= DateTime.now().microsecondsSinceEpoch.toString();
    final themeData = LoadingThemeData.of(context);
    try {
      _customOverlay.insert(
        context,
        key: key,
        interceptPop: false,
        alignment: alignment ?? themeData.alignment,
        dismissible: dismissible ?? themeData.dismissible,
        barrierColor: barrierColor ?? themeData.barrierColor,
        builder: (_, animation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: curve ?? themeData.curve,
              reverseCurve: reverseCurve ?? themeData.reverseCurve,
            ),
            child: child,
          );
        },
        child: LoadingOverlay(
          progressStream: progressStream,
          decoration: decoration ?? themeData.decoration,
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
    Curve? curve,
    bool? dismissible,
    Color? barrierColor,
    Curve? reverseCurve,
    Stream<double>? progressStream,
    LoadingOverlayDecoration? decoration,
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

/*
* 加载弹窗样式数据
* @author wuxubaiyang
* @Time 2024/10/22 11:27
*/
class LoadingThemeData {
  // 加载遮罩装饰器
  final LoadingOverlayDecoration decoration;

  // 加载遮罩是否可点击取消
  final bool dismissible;

  // 加载遮罩背景色
  final Color barrierColor;

  // 加载遮罩对齐方式
  final Alignment alignment;

  // 加载遮罩动画曲线
  final Curve curve;

  // 加载遮罩反向动画曲线
  final Curve reverseCurve;

  const LoadingThemeData({
    this.dismissible = true,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.barrierColor = Colors.black38,
    this.reverseCurve = Curves.easeInOutBack,
    this.decoration = const LoadingOverlayDecoration(),
  });

  // 获取通知主题
  static LoadingThemeData of(BuildContext context) =>
      maybeOf(context) ?? const LoadingThemeData();

  // 获取通知主题
  static LoadingThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.loadingTheme;
}

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
    LoadingOverlayStyle? style,
    bool cancelWithAnime = false,
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
          style: style ?? themeData.style,
        ),
      );
      return await loadFuture;
    } catch (e) {
      rethrow;
    } finally {
      _customOverlay.cancel(key, null, cancelWithAnime);
    }
  }

  // 取消加载弹窗
  static void cancel([bool withAnime = true]) =>
      _customOverlay.cancelAll(withAnime);
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
    LoadingOverlayStyle? style,
    bool cancelWithAnime = false,
  }) =>
      Loading.show(
        context,
        curve: curve,
        loadFuture: this,
        style: style,
        dismissible: dismissible,
        reverseCurve: reverseCurve,
        barrierColor: barrierColor,
        progressStream: progressStream,
        cancelWithAnime: cancelWithAnime,
      );
}

/*
* 加载弹窗样式数据
* @author wuxubaiyang
* @Time 2024/10/22 11:27
*/
class LoadingThemeData {
  // 加载遮罩样式
  final LoadingOverlayStyle style;

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
    this.style = const LoadingOverlayStyle(),
  });

  // 获取通知主题
  static LoadingThemeData of(BuildContext context) =>
      maybeOf(context) ?? const LoadingThemeData();

  // 获取通知主题
  static LoadingThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.loadingTheme;

  LoadingThemeData copyWith({
    bool? dismissible,
    Color? barrierColor,
    Alignment? alignment,
    Curve? curve,
    Curve? reverseCurve,
    LoadingOverlayStyle? style,
  }) =>
      LoadingThemeData(
        dismissible: dismissible ?? this.dismissible,
        barrierColor: barrierColor ?? this.barrierColor,
        alignment: alignment ?? this.alignment,
        curve: curve ?? this.curve,
        reverseCurve: reverseCurve ?? this.reverseCurve,
        style: style ?? this.style,
      );

  static LoadingThemeData lerp(
      LoadingThemeData? a, LoadingThemeData? b, double t) {
    if (a == null && b == null) return LoadingThemeData();
    return LoadingThemeData(
      dismissible: t < 0.5 ? a?.dismissible ?? true : b?.dismissible ?? true,
      barrierColor:
          Color.lerp(a?.barrierColor, b?.barrierColor, t) ?? Colors.black38,
      alignment:
          Alignment.lerp(a?.alignment, b?.alignment, t) ?? Alignment.center,
      curve:
          t < 0.5 ? a?.curve ?? Curves.easeInOut : b?.curve ?? Curves.easeInOut,
      reverseCurve: t < 0.5
          ? a?.reverseCurve ?? Curves.easeInOutBack
          : b?.reverseCurve ?? Curves.easeInOutBack,
      style: LoadingOverlayStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LoadingThemeData &&
      other.style == style &&
      other.dismissible == dismissible &&
      other.barrierColor == barrierColor &&
      other.alignment == alignment &&
      other.curve == curve &&
      other.reverseCurve == reverseCurve;

  @override
  int get hashCode => Object.hashAll([
        style,
        dismissible,
        barrierColor,
        alignment,
        curve,
        reverseCurve,
      ]);
}

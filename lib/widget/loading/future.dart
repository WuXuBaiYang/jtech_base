import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';

import 'status.dart';

/*
* 异步加载状态组件
* @author wuxubaiyang
* @Time 2024/10/11 13:22
*/
class LoadingFutureBuilder<T> extends StatelessWidget {
  // 初始值
  final T? initialData;

  // 报错状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder;

  // 视图构建
  final ValueWidgetBuilder<T> builder;

  // future
  final Future<T>? future;

  // 子元素
  final Widget? child;

  // 加载状态样式
  final LoadingStatusStyle? style;

  const LoadingFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.child,
    this.style,
    this.initialData,
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = LoadingFutureThemeData.of(context);
    return FutureBuilder<T>(
      future: future,
      initialData: initialData,
      builder: (_, snap) {
        return LoadingStatusBuilder(
          status: _handleStatus(snap),
          style: style ?? themeData.style,
          failBuilder: failBuilder ?? themeData.failBuilder,
          noDataBuilder: noDataBuilder ?? themeData.noDataBuilder,
          loadingBuilder: loadingBuilder ?? themeData.loadingBuilder,
          builder: (_, child) => builder(context, snap.data as T, child),
          child: child,
        );
      },
    );
  }

  // 根据当前数据状态获取对应的状态
  LoadStatus _handleStatus(AsyncSnapshot<T> snap) {
    if (snap.hasError) return LoadStatus.fail;
    if (snap.connectionState == ConnectionState.waiting) {
      return LoadStatus.loading;
    }
    if (snap.hasData) return LoadStatus.success;
    return LoadStatus.noData;
  }
}

/*
* 异步加载构造器样式
* @author wuxubaiyang
* @Time 2024/10/22 13:11
*/
class LoadingFutureThemeData extends LoadingStatusThemeData {
  const LoadingFutureThemeData({
    super.style,
    super.failBuilder,
    super.noDataBuilder,
    super.loadingBuilder,
  });

  // 获取通知主题
  static LoadingFutureThemeData of(BuildContext context) =>
      maybeOf(context) ?? const LoadingFutureThemeData();

  // 获取通知主题
  static LoadingFutureThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.loadingFutureTheme;

  @override
  LoadingStatusThemeData copyWith({
    LoadingStatusStyle? style,
    ValueWidgetBuilder<LoadingStatusStyle>? failBuilder,
    ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder,
    ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder,
  }) {
    return LoadingFutureThemeData(
      style: style ?? this.style,
      failBuilder: failBuilder ?? this.failBuilder,
      noDataBuilder: noDataBuilder ?? this.noDataBuilder,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
    );
  }

  static LoadingFutureThemeData lerp(
      LoadingFutureThemeData? a, LoadingFutureThemeData? b, double t) {
    if (a == null && b == null) return LoadingFutureThemeData();
    return LoadingFutureThemeData(
      style: LoadingStatusStyle.lerp(a?.style, b?.style, t),
      failBuilder: t < 0.5 ? a?.failBuilder : b?.failBuilder,
      noDataBuilder: t < 0.5 ? a?.noDataBuilder : b?.noDataBuilder,
      loadingBuilder: t < 0.5 ? a?.loadingBuilder : b?.loadingBuilder,
    );
  }
}

import 'package:flutter/foundation.dart';
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
  final ValueWidgetBuilder<LoadingStatusDecoration>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? loadingBuilder;

  // 视图构建
  final ValueWidgetBuilder<T?> builder;

  // 异步方法
  final AsyncValueGetter<T> onFuture;

  // 子元素
  final Widget? child;

  // 加载状态装饰器
  final LoadingStatusDecoration? decoration;

  const LoadingFutureBuilder({
    super.key,
    required this.builder,
    required this.onFuture,
    this.child,
    this.decoration,
    this.initialData,
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context)?.loadingFutureTheme;
    return FutureBuilder<T>(
      future: onFuture(),
      initialData: initialData,
      builder: (_, snap) {
        return LoadingStatusBuilder(
          status: _getStatus(snap),
          decoration: decoration ?? theme?.decoration,
          failBuilder: failBuilder ?? theme?.failBuilder,
          noDataBuilder: noDataBuilder ?? theme?.noDataBuilder,
          loadingBuilder: loadingBuilder ?? theme?.loadingBuilder,
          builder: (_, child) => builder(context, snap.data, child),
          child: child,
        );
      },
    );
  }

  // 根据当前数据状态获取对应的状态
  LoadStatus _getStatus(AsyncSnapshot<T> snap) {
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
    super.decoration,
    super.failBuilder,
    super.noDataBuilder,
    super.loadingBuilder,
  });
}

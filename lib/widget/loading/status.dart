import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
import 'view.dart';

/*
* 加载状态组件
* @author wuxubaiyang
* @Time 2024/8/8 11:07
*/
class LoadingStatusBuilder extends StatelessWidget {
  // 状态
  final LoadStatus status;

  // 报错状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder;

  // 视图构建
  final TransitionBuilder builder;

  // 子元素
  final Widget? child;

  // 加载状态样式
  final LoadingStatusStyle? style;

  const LoadingStatusBuilder({
    super.key,
    required this.builder,
    this.child,
    this.style,
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
    this.status = LoadStatus.success,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = LoadingStatusThemeData.of(context);
    return switch (status) {
      LoadStatus.fail => _buildFail(context, themeData),
      LoadStatus.noData => _buildNoData(context, themeData),
      LoadStatus.loading => _buildLoading(context, themeData),
      LoadStatus.success => builder(context, child),
    };
  }

  // 构建加载中状态
  Widget _buildLoading(BuildContext context, LoadingStatusThemeData themeData) {
    final style = this.style ?? themeData.style;
    final builder = loadingBuilder ?? themeData.loadingBuilder;
    return _buildStatus(context, (_) {
      if (builder != null) return builder(context, style, child);
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(style.loadingHint, style: style.getHintStyle(context)),
          SizedBox(height: 8),
          LoadingView.random(size: style.loadingSize),
        ]),
      );
    });
  }

  // 构建空数据状态
  Widget _buildNoData(BuildContext context, LoadingStatusThemeData themeData) {
    final style = this.style ?? themeData.style;
    final builder = noDataBuilder ?? themeData.noDataBuilder;
    return _buildStatus(context, (_) {
      if (builder != null) return builder(context, style, child);
      return Center(
        child: Text(style.noDataHint, style: style.getHintStyle(context)),
      );
    });
  }

  // 构建加载失败状态
  Widget _buildFail(BuildContext context, LoadingStatusThemeData themeData) {
    final style = this.style ?? themeData.style;
    final builder = failBuilder ?? themeData.failBuilder;
    return _buildStatus(context, (_) {
      if (builder != null) return builder(context, style, child);
      return Center(
        child: TextButton(
          onPressed: style.onFileRetry,
          child: Text(style.failHint),
        ),
      );
    });
  }

  // 构建状态
  Widget _buildStatus(BuildContext context, WidgetBuilder builder) {
    return CustomScrollView(slivers: [
      SliverFillViewport(
        delegate: SliverChildListDelegate([
          builder(context),
        ]),
      ),
    ]);
  }
}

// 加载状态枚举
enum LoadStatus {
  // 加载中
  loading,
  // 加载成功
  success,
  // 加载失败
  fail,
  // 无数据
  noData,
}

/*
* 加载状态样式
* @author wuxubaiyang
* @Time 2024/10/22 10:05
*/
class LoadingStatusStyle {
  // 加载状态尺寸
  final double loadingSize;

  // 失败重试回调
  final VoidCallback? onFileRetry;

  // 加载提示
  final String loadingHint;

  // 空数据提示
  final String noDataHint;

  // 失败提示
  final String failHint;

  // 提示字体样式
  final TextStyle? hintStyle;

  const LoadingStatusStyle({
    this.hintStyle,
    this.onFileRetry,
    this.loadingSize = 35,
    this.failHint = '点击重试',
    this.noDataHint = '暂无数据',
    this.loadingHint = '加载中',
  });

  // 获取提示字体样式
  TextStyle? getHintStyle(BuildContext context) =>
      hintStyle ??
      Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]);

  LoadingStatusStyle copyWith({
    TextStyle? hintStyle,
    VoidCallback? onFileRetry,
    double? loadingSize,
    String? failHint,
    String? noDataHint,
    String? loadingHint,
  }) {
    return LoadingStatusStyle(
      hintStyle: hintStyle ?? this.hintStyle,
      onFileRetry: onFileRetry ?? this.onFileRetry,
      loadingSize: loadingSize ?? this.loadingSize,
      failHint: failHint ?? this.failHint,
      noDataHint: noDataHint ?? this.noDataHint,
      loadingHint: loadingHint ?? this.loadingHint,
    );
  }

  static LoadingStatusStyle lerp(
      LoadingStatusStyle? a, LoadingStatusStyle? b, double t) {
    if (a == null && b == null) return LoadingStatusStyle();
    return LoadingStatusStyle(
      hintStyle: TextStyle.lerp(a?.hintStyle, b?.hintStyle, t),
      onFileRetry: b?.onFileRetry,
      loadingSize: lerpDouble(a?.loadingSize, b?.loadingSize, t) ?? 35,
      failHint: b?.failHint ?? '点击重试',
      noDataHint: b?.noDataHint ?? '暂无数据',
      loadingHint: b?.loadingHint ?? '加载中',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingStatusStyle &&
          runtimeType == other.runtimeType &&
          loadingSize == other.loadingSize &&
          onFileRetry == other.onFileRetry &&
          loadingHint == other.loadingHint &&
          noDataHint == other.noDataHint &&
          failHint == other.failHint &&
          hintStyle == other.hintStyle;

  @override
  int get hashCode => Object.hashAll([
        loadingSize,
        onFileRetry,
        loadingHint,
        noDataHint,
        failHint,
        hintStyle,
      ]);
}

/*
* 自定义刷新组件样式
* @author wuxubaiyang
* @Time 2024/10/22 11:30
*/
class LoadingStatusThemeData {
  // 报错状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder;

  // 加载状态样式
  final LoadingStatusStyle style;

  const LoadingStatusThemeData({
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
    this.style = const LoadingStatusStyle(),
  });

  // 获取通知主题
  static LoadingStatusThemeData of(BuildContext context) =>
      maybeOf(context) ?? const LoadingStatusThemeData();

  // 获取通知主题
  static LoadingStatusThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.loadingStatusTheme;

  LoadingStatusThemeData copyWith({
    ValueWidgetBuilder<LoadingStatusStyle>? failBuilder,
    ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder,
    ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder,
    LoadingStatusStyle? style,
  }) {
    return LoadingStatusThemeData(
      failBuilder: failBuilder ?? this.failBuilder,
      noDataBuilder: noDataBuilder ?? this.noDataBuilder,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
      style: style ?? this.style,
    );
  }

  static LoadingStatusThemeData lerp(
      LoadingStatusThemeData? a, LoadingStatusThemeData? b, double t) {
    if (a == null && b == null) return LoadingStatusThemeData();
    return LoadingStatusThemeData(
      style: LoadingStatusStyle.lerp(a?.style, b?.style, t),
      failBuilder: t < 0.5 ? a?.failBuilder : b?.failBuilder,
      noDataBuilder: t < 0.5 ? a?.noDataBuilder : b?.noDataBuilder,
      loadingBuilder: t < 0.5 ? a?.loadingBuilder : b?.loadingBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingStatusThemeData &&
          runtimeType == other.runtimeType &&
          failBuilder == other.failBuilder &&
          noDataBuilder == other.noDataBuilder &&
          loadingBuilder == other.loadingBuilder &&
          style == other.style;

  @override
  int get hashCode => Object.hashAll([
        failBuilder,
        noDataBuilder,
        loadingBuilder,
        style,
      ]);
}

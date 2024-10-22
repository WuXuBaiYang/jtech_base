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
  final ValueWidgetBuilder<LoadingStatusDecoration>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? loadingBuilder;

  // 视图构建
  final TransitionBuilder builder;

  // 子元素
  final Widget? child;

  // 加载状态装饰器
  final LoadingStatusDecoration? decoration;

  const LoadingStatusBuilder({
    super.key,
    required this.builder,
    this.child,
    this.decoration,
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
    this.status = LoadStatus.success,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context)?.loadingStatusTheme;
    final decoration =
        this.decoration ?? theme?.decoration ?? const LoadingStatusDecoration();
    return switch (status) {
      LoadStatus.fail => _buildFail(context, theme, decoration),
      LoadStatus.noData => _buildNoData(context, theme, decoration),
      LoadStatus.loading => _buildLoading(context, theme, decoration),
      LoadStatus.success => builder(context, child),
    };
  }

  // 构建加载中状态
  Widget _buildLoading(BuildContext context, LoadingStatusThemeData? theme,
      LoadingStatusDecoration decoration) {
    final builder = loadingBuilder ?? theme?.loadingBuilder;
    return _buildStatus(context, (_) {
      if (builder != null) return builder(context, decoration, child);
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(decoration.loadingHint, style: decoration.getHintStyle(context)),
          SizedBox(height: 8),
          LoadingView.random(size: decoration.loadingSize),
        ]),
      );
    });
  }

  // 构建空数据状态
  Widget _buildNoData(BuildContext context, LoadingStatusThemeData? theme,
      LoadingStatusDecoration decoration) {
    final builder = noDataBuilder ?? theme?.noDataBuilder;
    return _buildStatus(context, (_) {
      if (builder != null) return builder(context, decoration, child);
      return Center(
        child: Text(decoration.noDataHint,
            style: decoration.getHintStyle(context)),
      );
    });
  }

  // 构建加载失败状态
  Widget _buildFail(BuildContext context, LoadingStatusThemeData? theme,
      LoadingStatusDecoration decoration) {
    final builder = failBuilder ?? theme?.failBuilder;
    return _buildStatus(context, (_) {
      if (builder != null) return builder(context, decoration, child);
      return Center(
        child: TextButton(
          onPressed: decoration.onFileRetry,
          child: Text(decoration.failHint),
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
* 加载状态装饰器
* @author wuxubaiyang
* @Time 2024/10/22 10:05
*/
class LoadingStatusDecoration {
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

  const LoadingStatusDecoration({
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
}

/*
* 自定义刷新组件样式
* @author wuxubaiyang
* @Time 2024/10/22 11:30
*/
class LoadingStatusThemeData {
  // 报错状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusDecoration>? loadingBuilder;

  // 加载状态装饰器
  final LoadingStatusDecoration decoration;

  const LoadingStatusThemeData({
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
    this.decoration = const LoadingStatusDecoration(),
  });
}

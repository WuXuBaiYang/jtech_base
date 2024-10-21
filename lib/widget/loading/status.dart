import 'package:flutter/material.dart';
import 'view.dart';

/*
* 加载状态组件
* @author wuxubaiyang
* @Time 2024/8/8 11:07
*/
class LoadingStatusBuilder extends StatelessWidget {
  // 状态
  final LoadStatus status;

  // 加载状态尺寸
  final double? loadingSize;

  // 报错状态构建
  final WidgetBuilder? failBuilder;

  // 空数据状态构建
  final WidgetBuilder? emptyBuilder;

  // 加载中状态构建
  final WidgetBuilder? loadingBuilder;

  // 失败重试回调
  final VoidCallback? onRetry;

  // 视图构建
  final TransitionBuilder builder;

  // 子元素
  final Widget? child;

  const LoadingStatusBuilder({
    super.key,
    required this.builder,
    this.child,
    this.onRetry,
    this.failBuilder,
    this.loadingSize,
    this.emptyBuilder,
    this.loadingBuilder,
    this.status = LoadStatus.success,
  });

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      LoadStatus.fail => _buildFail(context),
      LoadStatus.empty => _buildEmpty(context),
      LoadStatus.loading => _buildLoading(context),
      LoadStatus.success => builder(context, child),
    };
  }

  // 构建加载中状态
  Widget _buildLoading(BuildContext context) {
    return _buildStatus(context, (_) {
      if (loadingBuilder != null) return loadingBuilder!(context);
      final size = loadingSize ?? 80;
      return Center(child: LoadingView.random(size: size));
    });
  }

  // 构建空数据状态
  Widget _buildEmpty(BuildContext context) {
    return _buildStatus(context, (_) {
      if (emptyBuilder != null) return emptyBuilder!(context);
      final hintColor = Colors.grey[400];
      final hintStyle =
          Theme.of(context).textTheme.bodySmall?.copyWith(color: hintColor);
      return Text('暂无数据', style: hintStyle);
    });
  }

  // 构建加载失败状态
  Widget _buildFail(BuildContext context) {
    return _buildStatus(context, (_) {
      if (failBuilder != null) return failBuilder!(context);
      return TextButton(
        onPressed: onRetry,
        child: Text('点击重试'),
      );
    });
  }

  // 构建状态
  Widget _buildStatus(BuildContext context, WidgetBuilder builder) {
    return CustomScrollView(slivers: [
      SliverFillViewport(
        delegate: SliverChildListDelegate([
          Center(child: builder(context)),
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
  empty,
}

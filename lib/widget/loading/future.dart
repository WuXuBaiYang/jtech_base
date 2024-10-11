import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 异步加载状态组件
* @author wuxubaiyang
* @Time 2024/10/11 13:22
*/
class LoadingFutureBuilder<T> extends StatelessWidget {
  // 初始值
  final T? initialData;

  // 加载动画大小
  final double? loadingSize;

  // 子元素
  final Widget? child;

  // 失败重试回调
  final VoidCallback? onRetry;

  // 报错状态构建
  final WidgetBuilder? failBuilder;

  // 空数据状态构建
  final WidgetBuilder? emptyBuilder;

  // 加载中状态构建
  final WidgetBuilder? loadingBuilder;

  // 视图构建
  final ValueWidgetBuilder<T?> builder;

  // 异步方法
  final AsyncValueGetter<T> onFuture;

  const LoadingFutureBuilder({
    super.key,
    required this.builder,
    required this.onFuture,
    this.child,
    this.onRetry,
    this.initialData,
    this.loadingSize,
    this.failBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: onFuture(),
      builder: (_, snap) {
        return LoadingStatus(
          onRetry: onRetry,
          status: _getStatus(snap),
          loadingSize: loadingSize,
          failBuilder: failBuilder,
          emptyBuilder: emptyBuilder,
          loadingBuilder: loadingBuilder,
          builder: (_, child) {
            return builder(context, snap.data, child);
          },
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
    return LoadStatus.empty;
  }
}

import 'package:flutter/material.dart';
import 'package:jtech_base/common/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/*
* provider组件视图基类
* @author wuxubaiyang
* @Time 2023/11/20 15:30
*/
abstract class ProviderView<T extends BaseProvider> extends StatelessWidget {
  // 页面上下文
  final _pageContext = PageContext();

  ProviderView({super.key});

  List<SingleChildWidget> loadProviders(BuildContext context) {
    return [
      ChangeNotifierProvider<T?>(
        lazy: lazyLoadProvider,
        create: createProvider,
      ),
      ...extensionProviders(),
    ];
  }

  // 创建provider
  T? createProvider(BuildContext context) => null;

  // provider是否懒加载
  bool get lazyLoadProvider => true;

  // 扩展provider
  List<SingleChildWidget> extensionProviders() => [];

  // 获取上下文
  BuildContext get context => _pageContext.context;

  // 页面provider
  T get provider {
    final provider = context.read<T?>();
    assert(provider != null, '使用provider之前请先调用create(Page)Provider');
    return provider!;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: loadProviders(context),
      builder: (context, _) {
        _pageContext.update(context);
        return buildWidget(context);
      },
    );
  }

  // 构建组件内容
  @mustCallSuper
  Widget buildWidget(BuildContext context);

  // 创建本页面选择器
  Widget createSelector<S>({
    required ValueWidgetBuilder<S> builder,
    required S Function(BuildContext context, T) selector,
    ShouldRebuild<S>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, S>(
      builder: builder,
      selector: selector,
      shouldRebuild: shouldRebuild,
      child: child,
    );
  }

  // 创建双元素选择器
  Widget createSelector2<S1, S2>({
    required Widget Function(
            BuildContext context, S1 value1, S2 value2, Widget? child)
        builder,
    required (S1, S2) Function(BuildContext context, T) selector,
    ShouldRebuild<(S1, S2)>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, (S1, S2)>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (context, values, child) =>
          builder(context, values.$1, values.$2, child),
      child: child,
    );
  }

// 创建三元素选择器
  Widget createSelector3<S1, S2, S3>({
    required Widget Function(BuildContext context, S1 value1, S2 value2,
            S3 value3, Widget? child)
        builder,
    required (S1, S2, S3) Function(BuildContext context, T) selector,
    ShouldRebuild<(S1, S2, S3)>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, (S1, S2, S3)>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (context, values, child) =>
          builder(context, values.$1, values.$2, values.$3, child),
      child: child,
    );
  }

// 创建四元素选择器
  Widget createSelector4<S1, S2, S3, S4>({
    required Widget Function(BuildContext context, S1 value1, S2 value2,
            S3 value3, S4 value4, Widget? child)
        builder,
    required (S1, S2, S3, S4) Function(BuildContext context, T) selector,
    ShouldRebuild<(S1, S2, S3, S4)>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, (S1, S2, S3, S4)>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (context, values, child) =>
          builder(context, values.$1, values.$2, values.$3, values.$4, child),
      child: child,
    );
  }

// 创建四元素选择器
  Widget createSelector5<S1, S2, S3, S4, S5>({
    required Widget Function(BuildContext context, S1 value1, S2 value2,
            S3 value3, S4 value4, S5 value5, Widget? child)
        builder,
    required (S1, S2, S3, S4, S5) Function(BuildContext context, T) selector,
    ShouldRebuild<(S1, S2, S3, S4, S5)>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, (S1, S2, S3, S4, S5)>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (context, values, child) => builder(context, values.$1,
          values.$2, values.$3, values.$4, values.$5, child),
      child: child,
    );
  }
}

// 页面上下文管理
class PageContext {
// 页面上下文
  BuildContext? _context;

// 更新
  void update(BuildContext context) => _context = context;

// 使用
  BuildContext get context {
    assert(_context != null, '请在build方法之后使用context');
    return _context!;
  }
}

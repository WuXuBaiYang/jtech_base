import 'package:flutter/material.dart';
import 'package:jtech_base/common/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// 双参数构造器
typedef SelectorBuilder2<S1, S2, T> = Widget Function(
    BuildContext context, S1 value1, S2 value2, Widget? child);

// 三参数构造器
typedef SelectorBuilder3<S1, S2, S3, T> = Widget Function(
    BuildContext context, S1 value1, S2 value2, S3 value3, Widget? child);

// 选择器
typedef ProviderSelector<S, T> = S Function(BuildContext context, T provider);

// 双参数选择器
typedef ProviderSelector2<S1, S2, T> = (S1, S2) Function(
    BuildContext context, T provider);

// 三参数选择器
typedef ProviderSelector3<S1, S2, S3, T> = (S1, S2, S3) Function(
    BuildContext context, T provider);

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

  // 创建provider监听器
  Widget createConsumer({
    required ValueWidgetBuilder<T> builder,
    Widget? child,
  }) {
    return Consumer<T>(
      builder: builder,
      child: child,
    );
  }

  // 创建本页面选择器
  Widget createSelector<S>({
    required ProviderSelector<S, T> selector,
    required ValueWidgetBuilder<S> builder,
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
    required ProviderSelector2<S1, S2, T> selector,
    required SelectorBuilder2<S1, S2, T> builder,
    ShouldRebuild<(S1, S2)>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, (S1, S2)>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (context, r, child) {
        return builder(context, r.$1, r.$2, child);
      },
      child: child,
    );
  }

  // 创建三元素选择器
  Widget createSelector3<S1, S2, S3>({
    required ProviderSelector3<S1, S2, S3, T> selector,
    required SelectorBuilder3<S1, S2, S3, T> builder,
    ShouldRebuild<(S1, S2, S3)>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<T, (S1, S2, S3)>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (context, r, child) {
        return builder(context, r.$1, r.$2, r.$3, child);
      },
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

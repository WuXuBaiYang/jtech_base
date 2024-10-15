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

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(
          lazy: lazyLoadProvider,
          create: (context) => createProvider(context),
        ),
        ...extensionProviders(),
      ];

  // 创建provider
  T createProvider(BuildContext context);

  // provider是否懒加载
  bool get lazyLoadProvider => true;

  // 扩展provider
  List<SingleChildWidget> extensionProviders() => [];

  // 获取上下文
  BuildContext get context => _pageContext.context;

  // 页面provider
  T get provider => context.read<T>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (context, _) {
        _pageContext.update(context);
        return buildWidget(context);
      },
    );
  }

  // 构建组件内容
  @mustCallSuper
  Widget buildWidget(BuildContext context);
}

// 页面上下文管理
class PageContext {
  // 页面上下文
  BuildContext? _context;

  // 更新
  void update(BuildContext context) => _context = context;

  // 使用
  BuildContext get context {
    assert(_context != null, 'context is null');
    return _context!;
  }
}

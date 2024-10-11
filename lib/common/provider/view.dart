import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/*
* provider组件视图基类
* @author wuxubaiyang
* @Time 2023/11/20 15:30
*/
abstract class ProviderView extends StatelessWidget {
  // 页面上下文
  final PageContext _pageContext;

  ProviderView({super.key}) : _pageContext = PageContext();

  List<SingleChildWidget> get providers => [];

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

  // 获取上下文
  BuildContext get context => _pageContext.context;

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

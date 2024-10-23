import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 组件-加载状态
* @author wuxubaiyang
* @Time 2024/10/23 15:24
*/
class WidgetLoadStatusPage extends ProviderPage<WidgetLoadStatusProvider> {
  WidgetLoadStatusPage({super.key, super.state});

  @override
  WidgetLoadStatusProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      WidgetLoadStatusProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件-加载状态'),
      ),
    );
  }
}


class WidgetLoadStatusProvider extends PageProvider {
  WidgetLoadStatusProvider(super.context, super.state);
}
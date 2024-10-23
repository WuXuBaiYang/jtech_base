import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 组件-列表刷新
* @author wuxubaiyang
* @Time 2024/10/23 15:25
*/
class WidgetRefreshPage extends ProviderPage<WidgetRefreshProvider> {
  WidgetRefreshPage({super.key, super.state});

  @override
  WidgetRefreshProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      WidgetRefreshProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件-列表刷新'),
      ),
    );
  }
}


class WidgetRefreshProvider extends PageProvider {
  WidgetRefreshProvider(super.context, super.state);
}

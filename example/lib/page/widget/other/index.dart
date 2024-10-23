import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 组件-其他组件
* @author wuxubaiyang
* @Time 2024/10/23 15:24
*/
class WidgetOtherPage extends ProviderPage<WidgetOtherProvider> {
  WidgetOtherPage({super.key, super.state});

  @override
  WidgetOtherProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      WidgetOtherProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件-其他组件'),
      ),
    );
  }
}


class WidgetOtherProvider extends PageProvider {
  WidgetOtherProvider(super.context, super.state);
}

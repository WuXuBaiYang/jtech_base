import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 组件-消息通知
* @author wuxubaiyang
* @Time 2024/10/23 15:24
*/
class WidgetNoticePage extends ProviderPage<WidgetNoticeProvider> {
  WidgetNoticePage({super.key, super.state});

  @override
  WidgetNoticeProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      WidgetNoticeProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件-消息通知'),
      ),
    );
  }
}


class WidgetNoticeProvider extends PageProvider {
  WidgetNoticeProvider(super.context, super.state);
}

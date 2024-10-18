import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-通知
* @author wuxubaiyang
* @Time 2024/10/18 10:13
*/
class ToolNoticePage extends ProviderPage<ToolNoticeProvider> {
  ToolNoticePage({super.key, super.state});

  @override
  ToolNoticeProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolNoticeProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-通知'),
      ),
    );
  }
}

class ToolNoticeProvider extends PageProvider {
  ToolNoticeProvider(super.context, super.state);
}

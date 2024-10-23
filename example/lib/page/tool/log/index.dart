import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-日志
* @author wuxubaiyang
* @Time 2024/10/23 15:26
*/
class ToolLogPage extends ProviderPage<ToolLogProvider> {
  ToolLogPage({super.key, super.state});

  @override
  ToolLogProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolLogProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-日志'),
      ),
    );
  }
}


class ToolLogProvider extends PageProvider {
  ToolLogProvider(super.context, super.state);
}

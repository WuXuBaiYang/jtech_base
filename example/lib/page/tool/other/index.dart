import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-其他
* @author wuxubaiyang
* @Time 2024/10/23 15:26
*/
class ToolOtherPage extends ProviderPage<ToolOtherProvider> {
  ToolOtherPage({super.key, super.state});

  @override
  ToolOtherProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolOtherProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-其他'),
      ),
    );
  }
}


class ToolOtherProvider extends PageProvider {
  ToolOtherProvider(super.context, super.state);
}

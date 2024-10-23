import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-防抖
* @author wuxubaiyang
* @Time 2024/10/23 15:26
*/
class ToolDebouncePage extends ProviderPage<ToolDebounceProvider> {
  ToolDebouncePage({super.key, super.state});

  @override
  ToolDebounceProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolDebounceProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-防抖'),
      ),
    );
  }
}


class ToolDebounceProvider extends PageProvider {
  ToolDebounceProvider(super.context, super.state);
}

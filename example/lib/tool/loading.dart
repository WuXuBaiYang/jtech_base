import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-加载
* @author wuxubaiyang
* @Time 2024/10/18 10:12
*/
class ToolLoadingPage extends ProviderPage<ToolLoadingProvider> {
  ToolLoadingPage({super.key, super.state});

  @override
  ToolLoadingProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolLoadingProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-加载'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ToolLoadingProvider extends PageProvider {
  ToolLoadingProvider(super.context, super.state);
}

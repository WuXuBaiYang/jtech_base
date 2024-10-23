import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-文件
* @author wuxubaiyang
* @Time 2024/10/23 15:26
*/
class ToolFilePage extends ProviderPage<ToolFileProvider> {
  ToolFilePage({super.key, super.state});

  @override
  ToolFileProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolFileProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-文件'),
      ),
    );
  }
}


class ToolFileProvider extends PageProvider {
  ToolFileProvider(super.context, super.state);
}

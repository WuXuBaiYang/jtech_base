import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';


/*
* 工具-弹窗
* @author wuxubaiyang
* @Time 2024/10/18 10:12
*/
class ToolDialogPage extends ProviderPage<ToolDialogProvider> {
  ToolDialogPage({super.key, super.state});

  @override
  bool get lazyLoadProvider => false;

  @override
  ToolDialogProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolDialogProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-弹窗'),
      ),
    );
  }
}

class ToolDialogProvider extends PageProvider {
  ToolDialogProvider(super.context, super.state);
}

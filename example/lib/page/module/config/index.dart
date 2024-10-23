import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 模块-应用配置
* @author wuxubaiyang
* @Time 2024/10/23 15:22
*/
class ModuleConfigPage extends ProviderPage<ModuleConfigProvider> {
  ModuleConfigPage({super.key, super.state});

  @override
  ModuleConfigProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ModuleConfigProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模块-应用配置'),
      ),
    );
  }
}


class ModuleConfigProvider extends PageProvider {
  ModuleConfigProvider(super.context, super.state);
}

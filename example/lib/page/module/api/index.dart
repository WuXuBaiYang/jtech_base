import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 模块-接口页面
* @author wuxubaiyang
* @Time 2024/10/23 15:21
*/
class ModuleApiPage extends ProviderPage<ModuleApiProvider> {
  ModuleApiPage({super.key, super.state});

  @override
  ModuleApiProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ModuleApiProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模块-接口页面'),
      ),
    );
  }
}


class ModuleApiProvider extends PageProvider {
  ModuleApiProvider(super.context, super.state);
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 模块-路由
* @author wuxubaiyang
* @Time 2024/10/23 15:22
*/
class ModuleRouterPage extends ProviderPage<ModuleRouterProvider> {
  ModuleRouterPage({super.key, super.state});

  @override
  ModuleRouterProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ModuleRouterProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模块-路由'),
      ),
    );
  }
}


class ModuleRouterProvider extends PageProvider {
  ModuleRouterProvider(super.context, super.state);
}

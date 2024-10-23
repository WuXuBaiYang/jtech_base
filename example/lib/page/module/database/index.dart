import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 模块-数据库
* @author wuxubaiyang
* @Time 2024/10/23 15:22
*/
class ModuleDatabasePage extends ProviderPage<ModuleDatabaseProvider> {
  ModuleDatabasePage({super.key, super.state});

  @override
  ModuleDatabaseProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ModuleDatabaseProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模块-数据库'),
      ),
    );
  }
}


class ModuleDatabaseProvider extends PageProvider {
  ModuleDatabaseProvider(super.context, super.state);
}

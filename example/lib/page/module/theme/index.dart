import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 模块-样式
* @author wuxubaiyang
* @Time 2024/10/23 15:23
*/
class ModuleThemePage extends ProviderPage<ModuleThemeProvider> {
  ModuleThemePage({super.key, super.state});

  @override
  ModuleThemeProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ModuleThemeProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('模块-样式'),
      ),
    );
  }
}

class ModuleThemeProvider extends PageProvider {
  ModuleThemeProvider(super.context, super.state);
}

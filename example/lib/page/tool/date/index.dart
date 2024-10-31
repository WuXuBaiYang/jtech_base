import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 工具-日期
* @author wuxubaiyang
* @Time 2024/10/23 15:26
*/
class ToolDatePage extends ProviderPage<ToolDateProvider> {
  ToolDatePage({super.key, super.state});

  @override
  ToolDateProvider createPageProvider(
          BuildContext context, GoRouterState? state) =>
      ToolDateProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工具-日期时间'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [

        ]),
      ),
    );
  }
}

class ToolDateProvider extends PageProvider {
  ToolDateProvider(super.context, super.state);
}

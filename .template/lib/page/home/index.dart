import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomePage extends ProviderPage<HomePageProvider> {
  HomePage({super.key, super.state});

  @override
  HomePageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomePageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${jtech_base_app_name}$')),
      body: Text('${jtech_base_app_name}$'),
    );
  }
}

/*
* 首页状态管理
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomePageProvider extends PageProvider {
  HomePageProvider(super.context, super.state);
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页演示子页面
* @author wuxubaiyang
* @Time 2024/10/22 16:06
*/
class HomeSubView extends ProviderView<HomeSubProvider> {
  // 标题
  final String title;

  HomeSubView({super.key, required this.title});

  @override
  HomeSubProvider? createProvider(BuildContext context) =>
      HomeSubProvider(context);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}

class HomeSubProvider extends BaseProvider {
  HomeSubProvider(super.context);
}

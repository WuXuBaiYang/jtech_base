import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页-子页面
* @author wuxubaiyang
* @Time 2024/10/23 14:37
*/
class HomeSubView extends ProviderView<HomeSubViewProvider> {
  // 标题
  final String title;

  // 配置集合
  final List<OptionItem> options;

  HomeSubView({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  HomeSubViewProvider? createProvider(BuildContext context) =>
      HomeSubViewProvider(context);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (_, i) {
          final item = options[i];
          return ListTile(
            leading: item.icon,
            title: Text(item.label),
            subtitle: Text(item.subLabel ?? ''),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}

class HomeSubViewProvider extends BaseProvider {
  HomeSubViewProvider(super.context);
}

import 'package:example/common/router.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页-模块
* @author wuxubaiyang
* @Time 2024/10/23 14:37
*/
class HomeModuleView extends ProviderView<HomeModuleProvider> {
  HomeModuleView({super.key});

  @override
  HomeModuleProvider? createProvider(BuildContext context) =>
      HomeModuleProvider(context);

  @override
  Widget buildWidget(BuildContext context) {
    final modules = provider.modules;
    return Scaffold(
      appBar: AppBar(
        title: Text('基础模块'),
      ),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (_, i) {
          final item = modules[i];
          return ListTile(
            leading: Icon(Icons.view_module_outlined),
            title: Text(item.label),
            subtitle: Text(item.subLabel ?? ''),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}

class HomeModuleProvider extends BaseProvider {
  // 模块列表
  final modules = [
    OptionItem(
      label: '数据库',
      subLabel: '接入Objectbox数据库，封装了基本使用方法',
      onTap: router.goModuleDatabase,
    ),
    OptionItem(
      label: '网络请求',
      subLabel: '演示基本网络请求方法与扩展使用方法',
      onTap: router.goModuleApi,
    ),
    OptionItem(
      label: '应用配置/缓存',
      subLabel: '封装了应用内零散配置字段与缓存字段的读写方法',
      onTap: router.goModuleConfig,
    ),
    OptionItem(
      label: '主题样式',
      subLabel: '自定义主题与主题样式更改',
      onTap: router.goModuleTheme,
    ),
    OptionItem(
      label: '路由管理',
      subLabel: '路由管理与路由跳转方法',
      onTap: router.goModuleRouter,
    ),
  ];

  HomeModuleProvider(super.context);
}

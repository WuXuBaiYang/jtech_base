import 'package:example/common/router.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页-工具
* @author wuxubaiyang
* @Time 2024/10/23 14:38
*/
class HomeToolView extends ProviderView<HomeToolProvider> {
  HomeToolView({super.key});

  @override
  HomeToolProvider? createProvider(BuildContext context) =>
      HomeToolProvider(context);

  @override
  Widget buildWidget(BuildContext context) {
    final tools = provider.tools;
    return Scaffold(
      appBar: AppBar(
        title: Text('工具'),
      ),
      body: ListView.builder(
        itemCount: tools.length,
        itemBuilder: (_, i) {
          final item = tools[i];
          return ListTile(
            leading: Icon(Icons.build_outlined),
            title: Text(item.label),
            subtitle: Text(item.subLabel ?? ''),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}

class HomeToolProvider extends BaseProvider {
  // 工具集合
  final tools = [
    OptionItem(
      label: '日期时间工具',
      subLabel: '时间段格式化、时间格式化、解析等',
      onTap: router.goToolDate,
    ),
    OptionItem(
      label: '防抖、节流',
      subLabel: '演示防抖、节流的使用方法',
      onTap: router.goToolDebounce,
    ),
    OptionItem(
      label: '日志工具',
      subLabel: '演示日志工具的使用方法',
      onTap: router.goToolLog,
    ),
    OptionItem(
      label: '文件管理工具、文件选择、路径选择',
      subLabel: '演示文件管理工具的使用方法',
      onTap: router.goToolFile,
    ),
    OptionItem(
      label: '其他工具',
      subLabel: '列表方法扩展、随机数、加密、生成id等',
      onTap: router.goToolOther,
    ),
  ];

  HomeToolProvider(super.context);
}

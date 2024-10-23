import 'package:example/common/router.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页-组件
* @author wuxubaiyang
* @Time 2024/10/23 14:39
*/
class HomeWidgetView extends ProviderView<HomeWidgetProvider> {
  HomeWidgetView({super.key});

  @override
  HomeWidgetProvider? createProvider(BuildContext context) =>
      HomeWidgetProvider(context);

  @override
  Widget buildWidget(BuildContext context) {
    final widgets = provider.widgets;
    return Scaffold(
      appBar: AppBar(
        title: Text('组件'),
      ),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (_, i) {
          final item = widgets[i];
          return ListTile(
            leading: Icon(Icons.widgets_outlined),
            title: Text(item.label),
            subtitle: Text(item.subLabel ?? ''),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}

class HomeWidgetProvider extends BaseProvider {
  // 组件列表
  final widgets = [
    OptionItem(
      label: '列表刷新组件',
      subLabel: '列表下拉刷新、上拉加载，数据管理，分页管理',
      onTap: router.goWidgetRefresh,
    ),
    OptionItem(
      label: '状态/异步状态构造器',
      subLabel: '用于管理状态、异步状态、错误状态、空状态',
      onTap: router.goWidgetLoadStatus,
    ),
    OptionItem(
      label: '异步加载弹层、消息提示',
      subLabel: 'loading、toast、notice等组件演示',
      onTap: router.goWidgetNotice,
    ),
    OptionItem(
      label: '其他组件',
      subLabel: '自定义图片、自定义对话框、组件状态保持',
      onTap: router.goWidgetOther,
    ),
  ];

  HomeWidgetProvider(super.context);
}

import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 组件-列表刷新
* @author wuxubaiyang
* @Time 2024/10/23 15:25
*/
class WidgetRefreshPage extends ProviderPage<WidgetRefreshProvider> {
  WidgetRefreshPage({super.key, super.state});

  @override
  WidgetRefreshProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => WidgetRefreshProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('组件-列表刷新')),
      body: CustomRefreshView(
        controller: provider.controller,
        onRefreshLoad: provider.loadMore,
        builder: (_, data, _) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) =>
                ListTile(title: Text('数据${data[index]}')),
          );
        },
      ),
    );
  }
}

class WidgetRefreshProvider extends PageProvider {
  // 控制器
  final controller = CustomRefreshController.empty();

  WidgetRefreshProvider(super.context, super.state);

  void loadMore(bool loadMore) async {
    await Future.delayed(const Duration(seconds: 1));
    controller.finish(List.generate(40, (i) => i), loadMore);
  }
}

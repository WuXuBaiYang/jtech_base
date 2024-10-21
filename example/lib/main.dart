import 'package:example/router.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JTech Base Demo',
      routerConfig: router.createRouter(),
    );
  }
}

class MyHomePage extends ProviderView<MyHomePageProvider> {
  MyHomePage({super.key});

  @override
  MyHomePageProvider? createProvider(BuildContext context) =>
      MyHomePageProvider(context);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JTech Base Demo'),
      ),
      // body: _buildFunctionList(context, provider.functions),
      body: _buildFunctionList(context, provider.functions),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }

  // 构建列表
  Widget _buildFunctionList(BuildContext context, List<OptionItem> functions,
      [ScrollPhysics? physics]) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: true,
      itemCount: functions.length,
      separatorBuilder: (_, __) => const Divider(),
      padding: const EdgeInsets.symmetric(vertical: 14),
      itemBuilder: (_, index) {
        final item = functions[index];
        final children = item.children;
        return ListTile(
          title: Text(item.label),
          subtitle: children.isNotEmpty
              ? _buildFunctionList(
                  context, children, const NeverScrollableScrollPhysics())
              : Text(item.subLabel ?? ''),
          onTap: item.onTap,
        );
      },
    );
  }
}

class MyHomePageProvider extends BaseProvider {
  // 功能列表
  late final functions = [
    OptionItem(label: '工具', children: [
      OptionItem(
        label: '弹窗(CustomDialog)',
        onTap: router.goToolDialog,
        subLabel: '可精准取消，可从外部指定取消',
      ),
      OptionItem(
        label: '加载(Loading)',
        onTap: router.goToolLoading,
        subLabel: '可用于future等异步操作',
      ),
      OptionItem(
        label: '通知(Notice)',
        onTap: router.goToolNotice,
        subLabel: '弹出式消息通知，含有多种状态',
      ),
    ]),
  ];

  MyHomePageProvider(super.context);
}

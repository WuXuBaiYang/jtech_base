import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jtech_base/jtech_base.dart';
import 'tool/dialog.dart';
import 'tool/loading.dart';
import 'tool/notice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JTech Base Demo',
      routerConfig: GoRouter(initialLocation: '/', routes: [
        GoRoute(
          path: '/',
          builder: (_, state) => MyHomePage(),
        ),
        GoRoute(
          path: '/tool/dialog',
          builder: (_, state) => ToolDialogPage(state: state),
        ),
        GoRoute(
          path: '/tool/loading',
          builder: (_, state) => ToolLoadingPage(state: state),
        ),
        GoRoute(
          path: '/tool/notice',
          builder: (_, state) => ToolNoticePage(state: state),
        ),
      ]),
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
      body: _buildFunctionList(context, provider.functions),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Picker.file(dialogTitle: 'xxxx',);
          // ImagePicker().pickImage(source: ImageSource.gallery);
        },
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
          onTap: () => context.push(item.value),
        );
      },
    );
  }
}

class MyHomePageProvider extends BaseProvider {
  // 功能列表
  final functions = [
    OptionItem(label: '工具', children: [
      OptionItem(
        label: '弹窗(CustomDialog)',
        subLabel: '可精准取消，可从外部指定取消',
        value: '/tool/dialog',
      ),
      OptionItem(
        label: '加载(Loading)',
        subLabel: '可用于future等异步操作',
        value: '/tool/loading',
      ),
      OptionItem(
        label: '通知(Notice)',
        subLabel: '弹出式消息通知，含有多种状态',
        value: '/tool/notice',
      ),
    ]),
  ];

  MyHomePageProvider(super.context);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ProviderView<MyHomePageProvider> {
  MyHomePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestDemo'),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextButton(
            onPressed: () {
              fu() async {
                await Future.delayed(const Duration(seconds: 3));
                Navigator.pop(context);
                return 'xxxx';
              }

              fu().loading(context);
            },
            child: const Text('Loading'),
          ),
          TextButton(
            onPressed: () {
              Notice.showSuccess(context, message: 'xxxx' * 10);
            },
            child: const Text('Notify'),
          ),
          TextButton(
            onPressed: () async {
              final result = await showCustomDialog(
                context,
                builder: (context) {
                  return CustomDialog(
                    title: const Text('自定义弹窗标题'),
                    content: const Text('自定义弹窗内容'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.maybePop(context, 'xxxxxx');
                          // CustomDialog.cancel(context, '1');
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          CustomDialog.cancel(context, 1);
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  );
                },
              );
              if (kDebugMode) print(result);
            },
            child: const Text('Dialog'),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'debug',
        child: const Icon(Icons.bug_report),
        onPressed: () {},
      ),
    );
  }
}

class MyHomePageProvider extends BaseProvider {
  MyHomePageProvider(super.context);
}

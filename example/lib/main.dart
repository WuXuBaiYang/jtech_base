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
        child: TextButton(onPressed: () {}, child: Text('xxx')),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'debug',
        child: const Icon(Icons.bug_report),
        onPressed: () {
          Future.delayed(Duration(seconds: 10)).loading(context);
          // Notice.showInfo(context, message: '消息提示', title: '错误', onGoing: true);
        },
      ),
    );
  }
}

class MyHomePageProvider extends BaseProvider {
  MyHomePageProvider(super.context);
}

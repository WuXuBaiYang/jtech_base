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
      body: LoadingStatus(
        status: LoadStatus.loading,
        builder: (_, __) {
          return const SizedBox();
        },
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

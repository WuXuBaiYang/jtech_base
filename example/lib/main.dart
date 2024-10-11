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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
        onPressed: () {
          Future.delayed(const Duration(seconds: 999)).loading(context);
        },
      ),
    );
  }
}

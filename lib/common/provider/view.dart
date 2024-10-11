import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/*
* provider组件视图基类
* @author wuxubaiyang
* @Time 2023/11/20 15:30
*/
abstract class ProviderView extends StatelessWidget {
  // 页面context
  final BuildContext context;

  const ProviderView({super.key, required this.context});

  List<SingleChildWidget> get providers => [];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (context, _) {
        return buildWidget(context);
      },
    );
  }

  // 构建组件内容
  Widget buildWidget(BuildContext context);
}

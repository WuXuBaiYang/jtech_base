import 'package:flutter/material.dart';

/*
* 自定义行
* @author wuxubaiyang
* @Time 2024/10/23 16:46
*/
class CustomCell extends StatelessWidget {
  // 标签
  final String label;

  // 子元素
  final Widget child;

  const CustomCell({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(label),
      subtitle: child,
    );
  }
}

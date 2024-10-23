import 'package:flutter/material.dart';

/*
* 自定义功能卡片
* @author wuxubaiyang
* @Time 2024/10/23 16:42
*/
class CustomCard extends StatelessWidget {
  // 标题
  final String title;

  // 副标题
  final String? subTitle;

  // 子元素集合
  final List<Widget> children;

  const CustomCard({
    super.key,
    required this.title,
    required this.children,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          title: Text(title),
          subtitle: subTitle != null ? Text(subTitle!) : null,
        ),
        SizedBox(height: 14),
        for (var child in children) ...[
          child,
          if (children.last != child) const Divider(indent: 14),
        ],
      ]),
    );
  }
}

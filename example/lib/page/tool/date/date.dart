import 'package:example/widget/card.dart';
import 'package:example/widget/cell.dart';
import 'package:flutter/material.dart';

/*
* 工具-时间组件卡片
* @author wuxubaiyang
* @Time 2024/10/23 16:48
*/
class ToolDateTimeCard extends StatelessWidget {
  const ToolDateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: '日期工具',
      children: [
        CustomCell(
          label: '格式化',
          child: Text('data'),
        ),
      ],
    );
  }
}

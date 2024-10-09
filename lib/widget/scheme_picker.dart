import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/provider/theme.dart';
import 'dialog.dart';

// 展示主题配色弹窗
Future<ThemeScheme?> showSchemePicker(
  BuildContext context, {
  required List<ThemeScheme> themeSchemes,
  ThemeScheme? current,
}) {
  return showDialog<ThemeScheme>(
    context: context,
    builder: (context) => SchemePickerDialog(
      current: current,
      themeSchemes: themeSchemes,
    ),
  );
}

/*
* 主题配色对话框
* @author wuxubaiyang
* @Time 2023/11/25 19:38
*/
class SchemePickerDialog extends StatelessWidget {
  // 主题配色方案列表
  final List<ThemeScheme> themeSchemes;

  // 当前主题配色方案
  final ThemeScheme? current;

  const SchemePickerDialog({
    super.key,
    required this.themeSchemes,
    this.current,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      scrollable: true,
      title: const Text('选择主题配色'),
      content: _buildContent(context),
      constraints: const BoxConstraints.tightFor(width: 340),
    );
  }

  // 构建内容
  Widget _buildContent(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: themeSchemes
          .map((item) => ThemeSchemeItem(
                themeScheme: item,
                isSelected: item.scheme == current?.scheme,
                onPressed: () => Navigator.pop(context, item),
              ))
          .toList(),
    );
  }
}

/*
* 主题配色项
* @author wuxubaiyang
* @Time 2023/11/24 15:36
*/
class ThemeSchemeItem extends StatelessWidget {
  // 主题配色项
  final ThemeScheme themeScheme;

  // 旋转角度(0-12)
  final double angle;

  // 大小
  final double size;

  // 内间距
  final EdgeInsetsGeometry padding;

  // 点击事件
  final VoidCallback? onPressed;

  // 是否已选中
  final bool isSelected;

  // 自定义tooltip
  final String? tooltip;

  const ThemeSchemeItem({
    super.key,
    required this.themeScheme,
    this.tooltip,
    this.size = 45,
    this.onPressed,
    this.angle = 7,
    this.isSelected = false,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: SizedBox.fromSize(
        size: Size.square(size),
        child: _buildItem(themeScheme),
      ),
    );
  }

  // 构建子项
  Widget _buildItem(ThemeScheme item) {
    if (isSelected) {
      return IconButton.outlined(
        padding: padding,
        onPressed: onPressed,
        icon: _buildItemSub(item),
        tooltip: tooltip ?? item.label,
      );
    }
    return IconButton(
      padding: padding,
      onPressed: onPressed,
      icon: _buildItemSub(item),
      tooltip: tooltip ?? item.label,
    );
  }

  // 构建子项sub
  Widget _buildItemSub(ThemeScheme item) {
    return CustomPaint(
      size: Size.infinite,
      painter: HalfCirclePainter((
        item.primary,
        item.secondary,
      )),
    );
  }
}

/*
* 半圆形绘制器
* @author wuxubaiyang
* @Time 2023/11/24 15:17
*/
class HalfCirclePainter extends CustomPainter {
  // 传入要绘制的颜色
  final (Color, Color) colors;

  HalfCirclePainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = colors.$1;
    final paint2 = Paint()..color = colors.$2;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    canvas.drawArc(rect, 0, pi, true, paint1);
    canvas.drawArc(rect, pi, pi, true, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

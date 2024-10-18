import 'package:flutter/material.dart';
import 'package:jtech_base/common/model.dart';

/*
* 选项数据模型
* @author wuxubaiyang
* @Time 2024/8/16 17:08
*/
class OptionItem<T> extends BaseModel {
  // 标签
  final String label;

  // 副标签
  final String? subLabel;

  // 提示
  final String? hint;

  // 图标
  final Widget? icon;

  // 活动图标
  final Widget? activeIcon;

  // 子元素
  final Widget? child;

  // 点击事件
  final VoidCallback? onTap;

  // 值
  final T? value;

  // 子元素集合
  final List<OptionItem<T>> children;

  OptionItem({
    required this.label,
    this.icon,
    this.hint,
    this.value,
    this.child,
    this.onTap,
    this.subLabel,
    this.activeIcon,
    this.children = const [],
  });
}

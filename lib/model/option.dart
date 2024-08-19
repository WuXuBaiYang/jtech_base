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

  // 图标
  final Widget? icon;

  // 活动图标
  final Widget? activeIcon;

  // 子元素
  final Widget? child;

  // 值
  final T? value;

  OptionItem({
    required this.label,
    this.icon,
    this.value,
    this.child,
    this.subLabel,
    this.activeIcon,
  });
}

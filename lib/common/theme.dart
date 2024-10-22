import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:jtech_base/widget/notice.dart';

/*
* 自定义样式配置
* @author wuxubaiyang
* @Time 2024/10/22 8:53
*/
class CustomTheme extends ThemeExtension<CustomTheme> {
  // 通知装饰器
  final NoticeDecoration noticeDecoration;

  // 通知是否持续
  final bool noticeOnGoing;

  // 通知动画曲线
  final Curve noticeCurve;

  // 通知反向动画曲线
  final Curve noticeReverseCurve;

  // 通知持续时间
  final Duration noticeDuration;

  // 通知动画持续时间
  final Duration noticeAnimeDuration;

  // 加载遮罩装饰器
  final LoadingOverlayDecoration loadingDecoration;

  // 加载遮罩是否可点击取消
  final bool loadingDismissible;

  // 加载遮罩背景色
  final Color loadingBarrierColor;

  // 加载遮罩对齐方式
  final Alignment loadingAlignment;

  // 加载遮罩动画曲线
  final Curve loadingCurve;

  // 加载遮罩反向动画曲线
  final Curve loadingReverseCurve;

  // 遮罩层动画持续时间
  final Duration animationDuration;

  CustomTheme({
    // 通知
    this.noticeOnGoing = false,
    this.noticeCurve = Curves.bounceInOut,
    this.noticeReverseCurve = Curves.easeInOutBack,
    this.noticeDecoration = const NoticeDecoration(),
    this.noticeDuration = const Duration(milliseconds: 1800),
    this.noticeAnimeDuration = const Duration(milliseconds: 240),
    // 加载遮罩
    this.loadingDismissible = true,
    this.loadingCurve = Curves.easeInOut,
    this.loadingAlignment = Alignment.center,
    this.loadingBarrierColor = Colors.black38,
    this.loadingReverseCurve = Curves.easeInOutBack,
    this.loadingDecoration = const LoadingOverlayDecoration(),
    // 遮罩层
    this.animationDuration = const Duration(milliseconds: 130),
  });

  // 获取自定义主题
  static CustomTheme? of(BuildContext context) =>
      Theme.of(context).extension<CustomTheme>();

  @override
  ThemeExtension<CustomTheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<CustomTheme> lerp(
      covariant ThemeExtension<CustomTheme>? other, double t) {
    throw UnimplementedError();
  }
}
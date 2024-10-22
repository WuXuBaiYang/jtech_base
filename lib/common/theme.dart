import 'package:flutter/material.dart';
import 'package:jtech_base/tool/loading.dart';
import 'package:jtech_base/tool/notice.dart';
import 'package:jtech_base/tool/overlay.dart';
import 'package:jtech_base/widget/dialog.dart';
import 'package:jtech_base/widget/image.dart';
import 'package:jtech_base/widget/loading/future.dart';
import 'package:jtech_base/widget/loading/status.dart';
import 'package:jtech_base/widget/refresh.dart';

/*
* 自定义样式配置
* @author wuxubaiyang
* @Time 2024/10/22 8:53
*/
class CustomTheme extends ThemeExtension<CustomTheme> {
  // 通知样式
  final NoticeThemeData noticeTheme;

  // 加载遮罩样式
  final LoadingThemeData loadingTheme;

  // 自定义刷新组件样式
  final CustomRefreshThemeData customRefreshTheme;

  // 异步加载构造器样式
  final LoadingFutureThemeData loadingFutureTheme;

  // 加载状态组件样式
  final LoadingStatusThemeData loadingStatusTheme;

  // 自定义遮罩样式
  final CustomOverlayThemeData customOverlayTheme;

  // 自定义弹窗
  final CustomDialogThemeData customDialogTheme;

  // 自定义图片
  final CustomImageThemeData customImageTheme;

  CustomTheme({
    // 通知
    this.noticeTheme = const NoticeThemeData(),
    // 加载遮罩
    this.loadingTheme = const LoadingThemeData(),
    // 加载状态
    this.loadingStatusTheme = const LoadingStatusThemeData(),
    // 自定义刷新组件
    this.customRefreshTheme = const CustomRefreshThemeData(),
    // 异步加载构造器
    this.loadingFutureTheme = const LoadingFutureThemeData(),
    // 自定义遮罩
    this.customOverlayTheme = const CustomOverlayThemeData(),
    // 自定义弹窗
    this.customDialogTheme = const CustomDialogThemeData(),
    // 自定义图片
    this.customImageTheme = const CustomImageThemeData(),
  });

  // 获取自定义主题
  static CustomTheme? of(BuildContext context) =>
      Theme.of(context).extension<CustomTheme>();

  @override
  ThemeExtension<CustomTheme> copyWith({
    NoticeThemeData? noticeTheme,
    LoadingThemeData? loadingTheme,
    LoadingStatusThemeData? loadingStatusTheme,
    CustomRefreshThemeData? customRefreshTheme,
    LoadingFutureThemeData? loadingFutureTheme,
    CustomOverlayThemeData? customOverlayTheme,
    CustomDialogThemeData? customDialogTheme,
    CustomImageThemeData? customImageTheme,
  }) {
    return CustomTheme(
      noticeTheme: noticeTheme ?? this.noticeTheme,
      loadingTheme: loadingTheme ?? this.loadingTheme,
      loadingStatusTheme: loadingStatusTheme ?? this.loadingStatusTheme,
      customRefreshTheme: customRefreshTheme ?? this.customRefreshTheme,
      loadingFutureTheme: loadingFutureTheme ?? this.loadingFutureTheme,
      customOverlayTheme: customOverlayTheme ?? this.customOverlayTheme,
      customDialogTheme: customDialogTheme ?? this.customDialogTheme,
      customImageTheme: customImageTheme ?? this.customImageTheme,
    );
  }

  @override
  ThemeExtension<CustomTheme> lerp(
          covariant ThemeExtension<CustomTheme>? other, double t) =>
      CustomTheme();
}

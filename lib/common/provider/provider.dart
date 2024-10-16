import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:jtech_base/tool/notice.dart';
import 'package:jtech_base/tool/toast.dart';

/*
* 代理基类
* @author wuxubaiyang
* @Time 2023/11/24 11:14
*/
abstract class BaseProvider extends ChangeNotifier {
  final BuildContext context;

  BaseProvider(this.context);

  // notice的弹层对象持有(同时只能有一个)
  OverlayEntry? _noticeOverlay;

  // 展示toast
  void showToast(
    String message, {
    Color? textColor,
    double? fontSize,
    double? fontAsset,
    bool longToast = false,
    Color? backgroundColor,
    ft.ToastGravity? gravity,
  }) {
    Toast.show(
      message,
      gravity: gravity,
      fontSize: fontSize,
      textColor: textColor,
      fontAsset: fontAsset,
      longToast: longToast,
      backgroundColor: backgroundColor,
    );
  }

  // 取消toast
  void cancelToast() => Toast.cancel();

  // 展示notice
  void showNoticeInfo(
    String message, {
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) {
    if (!context.mounted) return;
    _noticeOverlay = Notice.showInfo(
      context,
      title: title,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 展示notice
  void showNoticeError(
    String message, {
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) {
    if (!context.mounted) return;
    _noticeOverlay = Notice.showError(
      context,
      title: title,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 展示notice
  void showNoticeWarning(
    String message, {
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) {
    if (!context.mounted) return;
    _noticeOverlay = Notice.showWarning(
      context,
      title: title,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 展示notice
  void showNoticeSuccess(
    String message, {
    String? title,
    bool onGoing = false,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) {
    if (!context.mounted) return;
    _noticeOverlay = Notice.showSuccess(
      context,
      title: title,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 取消notice
  void cancelNotice() {
    _noticeOverlay?.remove();
    _noticeOverlay = null;
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:jtech_base/tool/notice.dart';
import 'package:jtech_base/tool/overlay.dart';
import 'package:jtech_base/tool/toast.dart';
import 'package:jtech_base/widget/notice.dart';

/*
* 代理基类
* @author wuxubaiyang
* @Time 2023/11/24 11:14
*/
abstract class BaseProvider extends ChangeNotifier {
  final BuildContext context;

  BaseProvider(this.context);

  // notice单一token管理
  CustomOverlayToken? _overlayToken;

  // 展示toast
  void showToast(
    String message, {
    Color? textColor,
    double? fontSize,
    bool longToast = false,
    Color? backgroundColor,
    ft.ToastGravity? gravity,
  }) {
    Toast.show(
      message,
      gravity: gravity,
      fontSize: fontSize,
      textColor: textColor,
      longToast: longToast,
      backgroundColor: backgroundColor,
    );
  }

  // 取消toast
  void cancelToast() => Toast.cancel();

  // 展示notice
  Future<T?> showNoticeInfo<T>(
    String message, {
    String? key,
    String? title,
    bool onGoing = false,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) async {
    cancelNotice();
    if (!context.mounted) return null;
    _overlayToken = token ??= CustomOverlayToken<T>();
    return Notice.showInfo<T>(
      context,
      key: key,
      title: title,
      token: token,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 展示notice
  Future<T?> showNoticeError<T>(
    String message, {
    String? key,
    String? title,
    bool onGoing = false,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) async {
    cancelNotice();
    if (!context.mounted) return null;
    _overlayToken = token ??= CustomOverlayToken<T>();
    return Notice.showError<T>(
      context,
      key: key,
      title: title,
      token: token,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 展示notice
  Future<T?> showNoticeWarning<T>(
    String message, {
    String? key,
    String? title,
    bool onGoing = false,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) async {
    cancelNotice();
    if (!context.mounted) return null;
    _overlayToken = token ??= CustomOverlayToken<T>();
    return Notice.showWarning(
      context,
      key: key,
      title: title,
      token: token,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 展示notice
  Future<T?> showNoticeSuccess<T>(
    String message, {
    String? key,
    String? title,
    bool onGoing = false,
    CustomOverlayToken<T>? token,
    List<Widget> actions = const [],
    NoticeDecoration decoration = const NoticeDecoration(),
  }) async {
    cancelNotice();
    if (!context.mounted) return null;
    _overlayToken = token ??= CustomOverlayToken<T>();
    return Notice.showSuccess<T>(
      context,
      key: key,
      title: title,
      token: token,
      message: message,
      onGoing: onGoing,
      actions: actions,
      decoration: decoration,
    );
  }

  // 取消notice
  void cancelNotice() {
    _overlayToken?.cancel();
    _overlayToken = null;
  }
}

import 'package:flutter/material.dart';
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

  // 展示toast
  void showToast(String message) => Toast.show(message);

  // 展示notice
  void showNoticeInfo(String message, {String? title}) {
    if (!context.mounted) return;
    Notice.showInfo(context, message: message, title: title);
  }

  // 展示notice
  void showNoticeError(String message, {String? title}) {
    if (!context.mounted) return;
    Notice.showError(context, message: message, title: title);
  }

  // 展示notice
  void showNoticeWarning(String message, {String? title}) {
    if (!context.mounted) return;
    Notice.showWarning(context, message: message, title: title);
  }

  // 展示notice
  void showNoticeSuccess(String message, {String? title}) {
    if (!context.mounted) return;
    Notice.showSuccess(context, message: message, title: title);
  }
}

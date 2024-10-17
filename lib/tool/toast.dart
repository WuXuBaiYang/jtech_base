import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;

/*
* toast消息通知
* @author wuxubaiyang
* @Time 2024/9/26 15:54
*/
class Toast {
  // 展示消息通知
  static Future<bool?> show(
    String msg, {
    Color? textColor,
    double? fontSize,
    bool longToast = false,
    Color? backgroundColor,
    ft.ToastGravity? gravity,
  }) {
    final toastLength =
        longToast ? ft.Toast.LENGTH_LONG : ft.Toast.LENGTH_SHORT;
    return ft.Fluttertoast.showToast(
      msg: msg,
      gravity: gravity,
      fontSize: fontSize,
      textColor: textColor,
      toastLength: toastLength,
      backgroundColor: backgroundColor,
    );
  }

  // 取消消息通知
  static Future<bool?> cancel() => ft.Fluttertoast.cancel();
}

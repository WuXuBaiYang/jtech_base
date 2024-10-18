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
    Alignment? gravity,
    bool longToast = false,
    Color? backgroundColor,
  }) {
    final toastLength =
        longToast ? ft.Toast.LENGTH_LONG : ft.Toast.LENGTH_SHORT;
    return ft.Fluttertoast.showToast(
      msg: msg,
      fontSize: fontSize,
      textColor: textColor,
      toastLength: toastLength,
      backgroundColor: backgroundColor,
      gravity: switch (gravity) {
        Alignment.topCenter => ft.ToastGravity.TOP,
        Alignment.topLeft => ft.ToastGravity.TOP_LEFT,
        Alignment.topRight => ft.ToastGravity.TOP_RIGHT,
        Alignment.center => ft.ToastGravity.CENTER,
        Alignment.centerLeft => ft.ToastGravity.CENTER_LEFT,
        Alignment.centerRight => ft.ToastGravity.CENTER_RIGHT,
        Alignment.bottomCenter => ft.ToastGravity.BOTTOM,
        Alignment.bottomLeft => ft.ToastGravity.BOTTOM_LEFT,
        Alignment.bottomRight => ft.ToastGravity.BOTTOM_RIGHT,
        _ => ft.ToastGravity.BOTTOM,
      },
    );
  }

  // 取消消息通知
  static Future<bool?> cancel() => ft.Fluttertoast.cancel();
}

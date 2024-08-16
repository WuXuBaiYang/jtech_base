import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'date.dart';

/*
* 工具方法
* @author wuxubaiyang
* @Time 2022/9/8 15:09
*/
class Tool {
  // 图片转base64
  static String image2Base64(File image) =>
      base64Encode(image.readAsBytesSync());

  // 生成时间戳签名
  static String genDateSign() => DateTime.now().format(DatePattern.dateSign);

  // 获取状态栏高度
  static double getStatusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  // 设置屏幕竖向
  static void setScreenPortrait() =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 设置屏幕横向
  static void setScreenLandscape() => SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // 设置屏幕方向
  static void setPreferredOrientations(List<DeviceOrientation> orientations) =>
      SystemChrome.setPreferredOrientations(orientations);

  // 设置状态栏显示隐藏
  static void setStatusBarVisible(bool visible) =>
      SystemChrome.setEnabledSystemUIMode(
          visible ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky);

  // 尝试解析色值
  static Color? tryParseColor(String colorString) {
    if (colorString.isEmpty) return null;
    // 解析16进制格式的色值 0xffffff
    if (colorString.contains(RegExp(r'#|0x'))) {
      String hexColor = colorString.replaceAll(RegExp(r'#|0x'), '');
      if (hexColor.length == 6) hexColor = 'ff$hexColor';
      final result = int.tryParse(hexColor, radix: 16);
      if (result == null) return null;
      return Color(result);
    }
    // 解析rgb格式的色值 rgb(0,0,0)
    if (colorString.toLowerCase().contains(RegExp(r'rgb(.*)'))) {
      String valuesString = colorString.substring(4, colorString.length - 1);
      List<String> values = valuesString.split(',');
      if (values.length != 3) return null;
      final red = int.tryParse(values[0].trim());
      final green = int.tryParse(values[1].trim());
      final blue = int.tryParse(values[2].trim());
      if (red == null || green == null || blue == null) return null;
      return Color.fromARGB(255, red, green, blue);
    }
    return null;
  }

  // 尝试解析duration
  static Duration? tryParseDuration(String durationString) {
    if (durationString.isEmpty) return null;
    final parts = durationString.split(':');
    int? hours = 0, minutes = 0, seconds = 0;
    if (parts.length == 3) {
      hours = int.tryParse(parts[0]);
      minutes = int.tryParse(parts[1]);
      seconds = int.tryParse(parts[2]);
      if (hours == null || minutes == null || seconds == null) return null;
    } else if (parts.length == 2) {
      minutes = int.tryParse(parts[0]);
      seconds = int.tryParse(parts[1]);
      if (minutes == null || seconds == null) return null;
    }
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // 文件大小对照表
  static final Map<int, String> _fileSizeMap = {
    1024 * 1024 * 1024 * 1024: 'TB',
    1024 * 1024 * 1024: 'GB',
    1024 * 1024: 'MB',
    1024: 'KB',
    0: 'B',
  };

  // 文件大小格式转换
  static String formatFileSize(int size,
      {bool lowerCase = true, int fixed = 1}) {
    for (final item in _fileSizeMap.keys) {
      if (size >= item) {
        final result = item > 0 ? (size / item).toStringAsFixed(fixed) : 0;
        var unit = _fileSizeMap[item];
        if (lowerCase) unit = unit!.toLowerCase();
        return '$result$unit';
      }
    }
    return '';
  }

  // 计算文件sha256
  static Future<String> calcFileSha256(File file) async {
    final bytes = await file.readAsBytes();
    return crypto.sha256.convert(bytes).toString();
  }
}

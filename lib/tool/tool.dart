import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'date.dart';

/*
* 工具方法
* @author wuxubaiyang
* @Time 2022/9/8 15:09
*/
class Tool {
  // 获取版本号
  static Future<int> get buildNumber async {
    final packageInfo = await PackageInfo.fromPlatform();
    return int.tryParse(packageInfo.buildNumber) ?? 0;
  }

  // 获取版本名
  static Future<String> get version async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // 获取app名称
  static Future<String> get packageName async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

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

  // 图片转base64
  static String image2Base64(File image) =>
      base64Encode(image.readAsBytesSync());

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
}

// 生成id
String genID({int? seed}) {
  final time = DateTime.now().millisecondsSinceEpoch;
  return genMd5('${time}_${Random(seed ?? time).nextDouble()}');
}

// 生成时间戳签名
String genDateSign() => DateTime.now().format(DatePattern.dateSign);

// 生成md5
String genMd5(String data) => crypto.md5.convert(utf8.encode(data)).toString();

// 区间计算
T range<T extends num>(T value, T begin, T end) => max(begin, min(end, value));

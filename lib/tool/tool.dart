import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'date.dart';
import 'file.dart';

/*
* 工具方法
* @author wuxubaiyang
* @Time 2022/9/8 15:09
*/
class Tool {
  // 获取零点时间戳
  static DateTime getDayZero({int dayOffset = 0}) {
    if (dayOffset < 0) return DateTime.now();
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .add(Duration(days: dayOffset));
  }

  // 获取距离零点的duration
  static Duration toDayZeroDuration({int dayOffset = 1}) {
    if (dayOffset < 1) return Duration.zero;
    return getDayZero(dayOffset: dayOffset).difference(DateTime.now());
  }

  // 缓存目标文件到缓存目录
  static Future<String?> cacheFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final baseDir = await getCacheFilePath();
    if (baseDir == null) return null;
    final outputPath = join(baseDir, '${genDateSign()}${file.suffixes}');
    return (await file.copy(outputPath)).path;
  }

  // 获取文件缓存目录
  static Future<String?> getCacheFilePath(
          [String cacheFilePath = 'cache_file']) =>
      FileTool.getDirPath(cacheFilePath, root: FileDir.temporary);

  // 图片转base64
  static String image2Base64(File image) =>
      base64Encode(image.readAsBytesSync());

  // 获取状态栏高度
  static double getStatusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

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

  // 压缩图片
  static Future<File?> compressImage(
    String path, {
    String? output,
    int quality = 85,
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    if (output == null) {
      final dir = await getApplicationCacheDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      output = join(dir.path, 'compressed_$timestamp.jpg');
    }
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      output,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );
    if (result == null) return null;
    return File(result.path);
  }

  // 压缩图片并返回bytes
  static Future<Uint8List> compressImageWithList(Uint8List image,
      {int quality = 85, int minWidth = 1920, int minHeight = 1080}) {
    return FlutterImageCompress.compressWithList(image,
        quality: quality, minWidth: minWidth, minHeight: minHeight);
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

  // 选择文件集合
  static Future<List<String>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
  }) async {
    if (kIsWeb) return [];
    final result = await FilePicker.platform.pickFiles(
      type: type,
      lockParentWindow: true,
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
    );
    if (result == null || result.files.isEmpty) return [];
    return result.files.map((e) => e.path!).toList();
  }

  // 选择单文件
  static Future<String?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
  }) async {
    final result = await pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
    );
    return result.firstOrNull;
  }

  // 选择图片集合
  static Future<List<String>> pickImages({
    String? dialogTitle,
    String? initialDirectory,
  }) {
    return pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: FileType.image,
    );
  }

  // 选择单文件
  static Future<String?> pickImage({
    String? dialogTitle,
    String? initialDirectory,
  }) {
    return pickFile(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: FileType.image,
    );
  }

  // 选择目录
  static Future<String?> pickDirectory({
    String? dialogTitle,
    String? initialDirectory,
  }) async {
    return FilePicker.platform.getDirectoryPath(
      lockParentWindow: true,
      dialogTitle: dialogTitle,
    );
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

// 扩展字符串
extension StringExtension on String {
  // 正则匹配第一个分组
  String regFirstGroup(String source, [int index = 0, bool trim = true]) {
    final match = RegExp(source).firstMatch(this);
    final result = match?.group(index) ?? '';
    if (!trim) return result;
    return result.trim();
  }
}

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:jtech_base/tool/log.dart';
import 'package:jtech_base/tool/tool.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/*
* 文件操作工具方法baseCachePath
* @author wuxubaiyang
* @Time 2022/3/17 16:11
*/
class FileTool {
  // 缓存目标文件到缓存目录
  static Future<String?> cache(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final baseDir = await getCachePath();
    if (baseDir == null) return null;
    final outputPath = join(baseDir, '${genDateSign()}${extension(filePath)}');
    return (await file.copy(outputPath)).path;
  }

  // 获取文件缓存目录
  static Future<String?> getCachePath([String cacheFilePath = 'cache_file']) =>
      FileTool.getDirPath(cacheFilePath, root: FileDir.temporary);

  // 清除目录文件
  static Future<bool> clearDir([String path = '']) async {
    try {
      final dir = Directory(path);
      if (dir.existsSync()) await dir.delete(recursive: true);
      return true;
    } catch (e) {
      Log.e('dir_cache_clear_error：', error: e);
    }
    return false;
  }

  // 解析目录大小
  static Future<String> formatDirSize({
    String path = '',
    bool lowerCase = false,
    int fixed = 1,
  }) async {
    final result = await getDirSize(path);
    return formatSize(result, lowerCase: lowerCase, fixed: fixed);
  }

  // 迭代计算一个目录的大小
  static Future<int> getDirSize(String path, [int size = 0]) async {
    final items = Directory(path).listSync(recursive: true, followLinks: true);
    for (final item in items) {
      if (item is File) {
        size += await item.length();
      } else if (item is Directory) {
        size = await getDirSize(item.absolute.path, size);
      }
    }
    return size;
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
  static String formatSize(int size, {bool lowerCase = true, int fixed = 1}) {
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

  // 获取本地文件目录(传入相对路径，拼接目标路径)
  static Future<String?> getDirPath(
    String path, {
    FileDir root = FileDir.temporary,
  }) async {
    final rootPath = await root.path;
    if (null == rootPath) return null;
    final dir = Directory(join(rootPath, path));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir.path;
  }

  // 获取文件的sha256
  static Future<String> calcFileSha256(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) throw Exception('文件不存在');
    return sha256.convert(await file.readAsBytes()).toString();
  }
}

/*
* 目录枚举
* @author wuxubaiyang
* @Time 2022/9/9 17:41
*/
enum FileDir {
  temporary,
  applicationSupport,
  applicationDocuments,
}

/*
* 目录枚举扩展
* @author wuxubaiyang
* @Time 2022/9/9 17:43
*/
extension FileDirExtension on FileDir {
  // 获取目录
  Future<Directory?> get dir {
    switch (this) {
      case FileDir.temporary:
        return getTemporaryDirectory();
      case FileDir.applicationDocuments:
        return getApplicationDocumentsDirectory();
      case FileDir.applicationSupport:
        return getApplicationSupportDirectory();
    }
  }

  // 获取路径
  Future<String?> get path async => (await dir)?.path;
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/*
* 附件选择
* @author wuxubaiyang
* @Time 2024/10/18 16:50
*/
class Picker {
  // 选择文件集合
  static Future<List<String>> files({
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
  static Future<String?> file({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
  }) async {
    final result = await files(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
    );
    return result.firstOrNull;
  }

  // 选择图片集合
  static Future<List<String>> images({
    String? dialogTitle,
    String? initialDirectory,
  }) {
    return files(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: FileType.image,
    );
  }

  // 选择单文件
  static Future<String?> image({
    String? dialogTitle,
    String? initialDirectory,
  }) {
    return file(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: FileType.image,
    );
  }

  // 选择目录
  static Future<String?> directory({
    String? dialogTitle,
    String? initialDirectory,
  }) async {
    return FilePicker.platform.getDirectoryPath(
      lockParentWindow: true,
      dialogTitle: dialogTitle,
    );
  }
}

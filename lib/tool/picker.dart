import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

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
    bool allowMultiple = true,
    int compressionQuality = 30,
    FileType type = FileType.any,
    bool allowCompression = true,
    bool lockParentWindow = false,
    List<String>? allowedExtensions,
  }) async {
    if (kIsWeb) return [];
    final result = await FilePicker.platform.pickFiles(
      type: type,
      dialogTitle: dialogTitle,
      allowMultiple: allowMultiple,
      allowCompression: allowCompression,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
      allowedExtensions: allowedExtensions,
      compressionQuality: compressionQuality,
    );
    final files = result?.files ?? [];
    return files.map((e) => e.path!).toList();
  }

  // 选择单文件
  static Future<String?> file({
    String? dialogTitle,
    String? initialDirectory,
    int compressionQuality = 30,
    FileType type = FileType.any,
    bool allowCompression = true,
    bool lockParentWindow = false,
    List<String>? allowedExtensions,
  }) async {
    final result = await files(
      type: type,
      allowMultiple: false,
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      lockParentWindow: lockParentWindow,
      allowCompression: allowCompression,
      allowedExtensions: allowedExtensions,
      compressionQuality: compressionQuality,
    );
    return result.firstOrNull;
  }

  // 选择图片集合
  static Future<List<String>> images({
    String? dialogTitle,
    String? initialDirectory,
    int compressionQuality = 30,
    bool allowCompression = true,
    bool lockParentWindow = false,
  }) {
    return files(
      type: FileType.image,
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      allowCompression: allowCompression,
      initialDirectory: initialDirectory,
      compressionQuality: compressionQuality,
    );
  }

  // 选择图片文件
  static Future<String?> image({
    String? dialogTitle,
    String? initialDirectory,
    int compressionQuality = 30,
    bool allowCompression = true,
    bool lockParentWindow = false,
  }) {
    return file(
      type: FileType.image,
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      allowCompression: allowCompression,
      initialDirectory: initialDirectory,
      compressionQuality: compressionQuality,
    );
  }

  // 图片拍照
  static Future<String?> imageCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    final result = await ImagePicker().pickImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      source: ImageSource.camera,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
      preferredCameraDevice: preferredCameraDevice,
    );
    return result?.path;
  }

  // 选择视频集合
  static Future<List<String>> videos({
    String? dialogTitle,
    String? initialDirectory,
    bool lockParentWindow = false,
  }) {
    return files(
      type: FileType.video,
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
    );
  }

  // 选择视频文件
  static Future<String?> video({
    String? dialogTitle,
    String? initialDirectory,
    bool lockParentWindow = false,
  }) {
    return file(
      type: FileType.video,
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
    );
  }

  // 视频录制
  static Future<String?> videoCamera({
    Duration? maxDuration,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    final result = await ImagePicker().pickVideo(
      maxDuration: maxDuration,
      source: ImageSource.camera,
      preferredCameraDevice: preferredCameraDevice,
    );
    return result?.path;
  }

  // 选择媒体文件集合
  static Future<List<String>> customs({
    String? dialogTitle,
    String? initialDirectory,
    bool lockParentWindow = false,
    List<String>? allowedExtensions,
  }) {
    return files(
      type: FileType.custom,
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
      allowedExtensions: allowedExtensions,
    );
  }

  // 选择媒体文件
  static Future<String?> custom({
    String? dialogTitle,
    String? initialDirectory,
    bool lockParentWindow = false,
    List<String>? allowedExtensions,
  }) {
    return file(
      type: FileType.custom,
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
      allowedExtensions: allowedExtensions,
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

  // 选择目录
  static Future<String?> save({
    Uint8List? bytes,
    String? fileName,
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    bool lockParentWindow = false,
    List<String>? allowedExtensions,
  }) async {
    return FilePicker.platform.saveFile(
      type: type,
      bytes: bytes,
      fileName: fileName,
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      lockParentWindow: lockParentWindow,
      allowedExtensions: allowedExtensions,
    );
  }

  // 清理缓存
  static Future<bool?> clear() => FilePicker.platform.clearTemporaryFiles();
}

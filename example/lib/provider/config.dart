import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jtech_base/jtech_base.dart';

part 'config.g.dart';

part 'config.freezed.dart';

/*
* 全局设置
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ConfigProvider extends BaseConfigProvider<AppConfig> {
  ConfigProvider(super.context)
    : super(
        creator: (e) => AppConfig.fromJson(e),
        serializer: (c) => c.toJson(),
      );

  // 开关状态
  bool get switcher => config.switcher ?? false;

  // 更新开关状态
  void updateSwitcher(bool switcher) =>
      updateConfig(config.copyWith(switcher: switcher));

  // 进度
  double get progress => config.progress ?? 0;

  // 更新进度
  void updateProgress(double progress) =>
      updateConfig(config.copyWith(progress: progress));
}

// 配置对象
@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    required bool? switcher,
    required double? progress,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}

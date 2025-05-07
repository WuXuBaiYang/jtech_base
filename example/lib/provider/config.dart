import 'package:jtech_base/jtech_base.dart';

/*
* 全局设置
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ConfigProvider extends BaseConfigProvider<AppConfig> {
  ConfigProvider(super.context)
      : super(creator: AppConfig.from, serializer: (c) => c.to());

  // 开关状态
  bool get switcher => config.switcher;

  // 更新开关状态
  void updateSwitcher(bool switcher) =>
      updateConfig(config.copyWith(switcher: switcher));

  // 进度
  double get progress => config.progress;

  // 更新进度
  void updateProgress(double progress) =>
      updateConfig(config.copyWith(progress: progress));
}

/*
* 配置文件对象
* @author wuxubaiyang
* @Time 2024/8/14 14:40
*/
class AppConfig {
  // 开关
  final bool switcher;

  // 进度
  final double progress;

  AppConfig({
    required this.switcher,
    required this.progress,
  });

  AppConfig.from(obj)

      /// 可以在这里设置默认值
      : switcher = obj['switcher'] ?? false,
        progress = obj['progress'] ?? 0.5;

  Map<String, dynamic> to() => {
        'switcher': switcher,
        'progress': progress,
      };

  AppConfig copyWith({
    bool? switcher,
    double? progress,
  }) {
    return AppConfig(
      switcher: switcher ?? this.switcher,
      progress: progress ?? this.progress,
    );
  }
}

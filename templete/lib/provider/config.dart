import 'package:jtech_base/jtech_base.dart';

/*
* 全局设置
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ConfigProvider extends BaseConfigProvider<AppConfig> {
  ConfigProvider(super.context) : super(creator: AppConfig.from);

  /// 占位方法，使用时可以删除，在此处实现全局配置的操作方法，有需要可以通过selector监听
  String get placeholder => config.placeholder;

  /// 占位方法，使用时可以删除
  set placeholder(String v) => updateConfig(config.copyWith(placeholder: v));
}

/*
* 配置文件对象
* @author wuxubaiyang
* @Time 2024/8/14 14:40
*/
class AppConfig extends BaseConfig {
  /// 占位字段，使用时可以删除，每新增一个字段都请按照如下结构填写
  final String placeholder;

  AppConfig({
    this.placeholder = '',
  });

  AppConfig.from(obj) : placeholder = obj['placeholder'] ?? '';

  @override
  Map<String, dynamic> to() => {
        'placeholder': placeholder,
      };

  @override
  AppConfig copyWith({
    String? placeholder,
  }) {
    return AppConfig(
      placeholder: placeholder ?? this.placeholder,
    );
  }
}

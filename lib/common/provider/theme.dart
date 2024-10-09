import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/model.dart';
import 'package:jtech_base/common/provider/provider.dart';
import 'package:jtech_base/tool/cache.dart';
import 'package:jtech_base/widget/scheme_picker.dart';

/*
* 主题提供者
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
abstract class BaseThemeProvider extends BaseProvider {
  // 当前主题模式缓存key
  String get themeModeKey => 'theme_mode_key';

  // 当前主题配色方案缓存key
  String get themeSchemeKey => 'theme_scheme_key';

  // 默认主题模式
  ThemeMode get defaultThemeMode => ThemeMode.system;

  // 默认主题配色方案
  FlexScheme get defaultThemeScheme => FlexScheme.blueM3;

  BaseThemeProvider(super.context);

  // 缓存配色方案
  late FlexScheme _scheme = FlexScheme
      .values[localCache.getInt(themeSchemeKey) ?? defaultThemeScheme.index];

  // 获取配色方案
  FlexScheme get scheme => _scheme;

  // 缓存当前主题模式
  late ThemeMode _themeMode = ThemeMode
      .values[localCache.getInt(themeModeKey) ?? defaultThemeMode.index];

  // 获取当前主题模式
  ThemeMode get themeMode => _themeMode;

  // 缓存当前主题数据
  late ThemeData _themeData = _genThemeData(Brightness.light);

  // 获取主题数据
  ThemeData get themeData => _themeData;

  // 缓存暗色主题数据
  late ThemeData _darkThemeData = _genThemeData(Brightness.dark);

  // 获取暗色主题数据
  ThemeData get darkThemeData => _darkThemeData;

  // 缓存主题亮度
  late Brightness _brightness = _mode2Brightness(_themeMode);

  // 获取主题亮度
  Brightness get brightness => _brightness;

  // themeMode转换为亮度
  Brightness _mode2Brightness(ThemeMode themeMode) => switch (themeMode) {
        ThemeMode.dark => Brightness.dark,
        ThemeMode.light => Brightness.light,
        ThemeMode.system => MediaQuery.platformBrightnessOf(context),
      };

  // 根据scheme获取配色
  FlexSchemeColor getSchemeColor(FlexScheme scheme) {
    const schemesMap = FlexColor.schemesWithCustom;
    return switch (brightness) {
      Brightness.light => schemesMap[scheme]!.light,
      Brightness.dark => schemesMap[scheme]!.dark,
    };
  }

  // 获取当前的主题配色方案
  ThemeScheme get themeScheme {
    final schemeColor = getSchemeColor(_scheme);
    return ThemeScheme(
      scheme: _scheme,
      label: _scheme.label,
      primary: schemeColor.primary,
      secondary: schemeColor.secondary,
    );
  }

  // 切换主题配色
  Future<ThemeScheme?> showSchemeChangePicker() async {
    final result = await showSchemePicker(
      context,
      current: themeScheme,
      themeSchemes: getThemeSchemeList(),
    );
    if (!context.mounted) return null;
    return changeThemeScheme(result);
  }

  // 切换主题模式
  Future<ThemeMode?> changeThemeMode(ThemeMode? themeMode) async {
    if (themeMode == null) return null;
    final result = await localCache.setInt(themeModeKey, themeMode.index);
    if (!result) return null;
    _brightness = _mode2Brightness(
      _themeMode = themeMode,
    );
    await _updateThemeData();
    return themeMode;
  }

  // 切换主题配色方案
  Future<ThemeScheme?> changeThemeScheme(ThemeScheme? themeScheme) async {
    if (themeScheme == null) return null;
    final result =
        await localCache.setInt(themeSchemeKey, themeScheme.scheme.index);
    if (!result) return null;
    _scheme = themeScheme.scheme;
    await _updateThemeData();
    return themeScheme;
  }

  // 获取全部支持的配色方案
  List<ThemeScheme> getThemeSchemeList({bool useMaterial3 = true}) {
    return FlexScheme.values.where((e) {
      if (e == FlexScheme.custom) return false;
      if (useMaterial3) return e.name.contains('M3');
      return !e.name.contains('M3');
    }).map((scheme) {
      final schemeColor = getSchemeColor(scheme);
      return ThemeScheme(
        scheme: _scheme,
        label: _scheme.label,
        primary: schemeColor.primary,
        secondary: schemeColor.secondary,
      );
    }).toList();
  }

  // 更新主题数据
  Future<void> _updateThemeData() async {
    _themeData = _genThemeData(Brightness.light);
    _darkThemeData = _genThemeData(Brightness.dark);
    notifyListeners();
  }

  // 根据主题亮色/暗色获取基本themeData
  ThemeData _getThemeData(Brightness brightness, [bool useMaterial3 = true]) =>
      switch (brightness) {
        Brightness.light => FlexThemeData.light(
            scheme: _scheme,
            useMaterial3: useMaterial3,
          ),
        Brightness.dark => FlexThemeData.dark(
            scheme: _scheme,
            useMaterial3: useMaterial3,
          ),
      };

  // 根据主题亮度生成不同的主题数据
  ThemeData _genThemeData(Brightness brightness, [bool useMaterial3 = true]) {
    final currentTheme = _getThemeData(brightness, useMaterial3);
    return customTheme(currentTheme, brightness, useMaterial3);
  }

  // 自定义主题样式
  ThemeData customTheme(
      ThemeData current, Brightness brightness, bool useMaterial3);
}

/*
* 扩展主题模式枚举类，添加中文名称属性
*
* @author wuxubaiyang
* @Time 2023/11/24 15:47
*/
extension ThemeModeExtension on ThemeMode {
  // 获取主题模式名称
  String get label => switch (this) {
        ThemeMode.light => '浅色模式',
        ThemeMode.dark => '深色模式',
        ThemeMode.system => '跟随系统',
      };

  // 获取主题模式图标
  IconData get icon => switch (this) {
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.system => Icons.auto_awesome,
      };
}

/*
* 扩展主题配色方案枚举类，添加中文名称属性
* @author wuxubaiyang
* @Time 2023/11/24 15:48
*/
extension FlexSchemeExtension on FlexScheme {
  // 获取主题配色方案名称
  String get label => switch (this) {
        FlexScheme.redM3 => '骚气红',
        FlexScheme.pinkM3 => '温柔粉',
        FlexScheme.purpleM3 => '高贵紫',
        FlexScheme.indigoM3 => '宁静靛',
        FlexScheme.blueM3 => '沉稳蓝',
        FlexScheme.cyanM3 => '清新青',
        FlexScheme.tealM3 => '苍翠绿',
        FlexScheme.greenM3 => '清新绿',
        FlexScheme.limeM3 => '活力黄绿',
        FlexScheme.yellowM3 => '明亮黄',
        FlexScheme.orangeM3 => '暖心橙',
        FlexScheme.deepOrangeM3 => '深邃橙',
        FlexScheme _ => '',
      };
}

/*
* 扩展亮度枚举类，添加中文名称属性
* @author wuxubaiyang
* @Time 2023/11/24 15:49
*/
extension BrightnessExtension on Brightness {
  // 获取亮度名称
  String get label => switch (this) {
        Brightness.light => '浅色',
        Brightness.dark => '深色',
      };
}

/*
* 配色方案
* @author wuxubaiyang
* @Time 2024/10/9 16:01
*/
class ThemeScheme extends BaseModel {
  // 配色方案
  final FlexScheme scheme;

  // 主色
  final Color primary;

  // 辅色
  final Color secondary;

  // 配色方案名称
  final String label;

  ThemeScheme({
    required this.scheme,
    required this.primary,
    required this.secondary,
    required this.label,
  });

  ThemeScheme.from(obj)
      : scheme = FlexScheme.values[obj?['scheme'] ?? 0],
        primary = Color(obj?['primary'] ?? 0),
        secondary = Color(obj?['secondary'] ?? 0),
        label = obj?['label'] ?? '';

  @override
  Map<String, dynamic> to() => {
        'scheme': scheme.index,
        'primary': primary.value,
        'secondary': secondary.value,
        'label': label,
      };

  @override
  ThemeScheme copyWith({
    FlexScheme? scheme,
    Color? primary,
    Color? secondary,
    String? label,
  }) {
    return ThemeScheme(
      scheme: scheme ?? this.scheme,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      label: label ?? this.label,
    );
  }
}

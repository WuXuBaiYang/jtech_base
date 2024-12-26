import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/provider/provider.dart';
import 'package:jtech_base/common/theme.dart';
import 'package:jtech_base/tool/cache.dart';

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

  // 创建系统主题样式
  ThemeData createTheme(ThemeData themeData, Brightness brightness);

  // 创建自定义主题样式
  CustomTheme? createCustomTheme(ThemeData themeData, Brightness brightness) =>
      null;

  // 切换主题模式
  Future<bool> changeThemeMode(ThemeMode? themeMode) async {
    if (themeMode == null) return false;
    if (!await localCache.setInt(themeModeKey, themeMode.index)) return false;
    _brightness = _mode2Brightness(
      _themeMode = themeMode,
    );
    return _updateThemeData();
  }

  // 切换主题配色方案
  Future<bool> changeThemeScheme(FlexScheme? scheme) async {
    if (scheme == null) return false;
    if (!await localCache.setInt(themeSchemeKey, scheme.index)) return false;
    _scheme = scheme;
    return _updateThemeData();
  }

  // 获取主题配色方案表
  Map<FlexScheme, FlexSchemeData> get themeSchemes => FlexColor.schemes;

  // 更新主题数据
  bool _updateThemeData() {
    _themeData = _genThemeData(Brightness.light);
    _darkThemeData = _genThemeData(Brightness.dark);
    notifyListeners();
    return true;
  }

  // themeMode转换为亮度
  Brightness _mode2Brightness(ThemeMode themeMode) => switch (themeMode) {
        ThemeMode.dark => Brightness.dark,
        ThemeMode.light => Brightness.light,
        ThemeMode.system => MediaQuery.platformBrightnessOf(context),
      };

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
    final themeData =
        createTheme(_getThemeData(brightness, useMaterial3), brightness);
    final customTheme = createCustomTheme(themeData, brightness);
    if (customTheme == null) return themeData;
    return themeData.copyWith(extensions: [customTheme]);
  }
}

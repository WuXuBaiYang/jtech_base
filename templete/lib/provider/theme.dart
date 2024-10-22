import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 主题提供者
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class ThemeProvider extends BaseThemeProvider {
  ThemeProvider(super.context);

  @override
  ThemeData createTheme(ThemeData themeData, Brightness brightness) {
    return themeData.copyWith(

        /// TODO 在此处添加自定义组件样式，重启后生效
        );
  }

  @override
  CustomTheme? createCustomTheme(ThemeData themeData, Brightness brightness) {
    return CustomTheme(

        /// TODO 在此处实现自定义组件样式（如LoadingStatusBuilder，CustomImage），重启后生效
        );
  }
}

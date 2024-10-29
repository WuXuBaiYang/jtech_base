import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jtech_base/jtech_base.dart';
import 'common/common.dart';
import 'common/router.dart';
import 'database/database.dart';
import 'provider/config.dart';
import 'provider/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化本地缓存
  await localCache.initialize();
  // 初始化数据库
  await database.initialize(Common.databaseName);
  // 启动应用
  runApp(MyApp());
}

class MyApp extends ProviderView {
  MyApp({super.key});

  @override
  List<SingleChildWidget> loadProviders(BuildContext context) => [
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(context)),
        ChangeNotifierProvider<ConfigProvider>(
            create: (context) => ConfigProvider(context)),
      ];

  @override
  Widget buildWidget(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) {
        return MaterialApp.router(
          title: '{jtech_base_app_name}',
          theme: theme.themeData,
          themeMode: theme.themeMode,
          darkTheme: theme.darkThemeData,
          debugShowCheckedModeBanner: false,
          routerConfig: router.createRouter(),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}

// 扩展context
extension GlobeProviderExtension on BuildContext {
  // 获取主题provider
  ThemeProvider get theme => Provider.of<ThemeProvider>(this, listen: false);

  // 获取配置provider
  ConfigProvider get config => Provider.of<ConfigProvider>(this, listen: false);
}

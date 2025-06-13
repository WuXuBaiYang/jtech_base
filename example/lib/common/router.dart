import 'package:example/page/module/api/index.dart';
import 'package:example/page/module/config/index.dart';
import 'package:example/page/module/database/index.dart';
import 'package:example/page/module/router/index.dart';
import 'package:example/page/module/theme/index.dart';
import 'package:example/page/tool/date/index.dart';
import 'package:example/page/tool/debounce/index.dart';
import 'package:example/page/tool/file/index.dart';
import 'package:example/page/tool/log/index.dart';
import 'package:example/page/tool/other/index.dart';
import 'package:example/page/widget/load/index.dart';
import 'package:example/page/widget/notice/index.dart';
import 'package:example/page/widget/other/index.dart';
import 'package:example/page/widget/refresh/index.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:example/page/home/index.dart';

/*
* 路由管理
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class Router extends BaseRouter {
  static final Router _instance = Router._internal();

  factory Router() => _instance;

  Router._internal();

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomePage(state: state),
          routes: [
            GoRoute(
              path: '/module',
              builder: (_, _) => SizedBox(),
              routes: [
                GoRoute(
                  path: '/database',
                  builder: (_, _) => ModuleDatabasePage(),
                ),
                GoRoute(
                  path: '/api',
                  builder: (_, _) => ModuleApiPage(),
                ),
                GoRoute(
                  path: '/config',
                  builder: (_, _) => ModuleConfigPage(),
                ),
                GoRoute(
                  path: '/theme',
                  builder: (_, _) => ModuleThemePage(),
                ),
                GoRoute(
                  path: '/router',
                  builder: (_, _) => ModuleRouterPage(),
                ),
              ],
            ),
            GoRoute(
              path: '/widget',
              builder: (_, _) => SizedBox(),
              routes: [
                GoRoute(
                  path: '/refresh',
                  builder: (_, _) => WidgetRefreshPage(),
                ),
                GoRoute(
                  path: '/loadStatus',
                  builder: (_, _) => WidgetLoadStatusPage(),
                ),
                GoRoute(
                  path: '/notice',
                  builder: (_, _) => WidgetNoticePage(),
                ),
                GoRoute(
                  path: '/other',
                  builder: (_, _) => WidgetOtherPage(),
                ),
              ],
            ),
            GoRoute(
              path: '/tool',
              builder: (_, _) => SizedBox(),
              routes: [
                GoRoute(
                  path: '/date',
                  builder: (_, _) => ToolDatePage(),
                ),
                GoRoute(
                  path: '/debounce',
                  builder: (_, _) => ToolDebouncePage(),
                ),
                GoRoute(
                  path: '/log',
                  builder: (_, _) => ToolLogPage(),
                ),
                GoRoute(
                  path: '/file',
                  builder: (_, _) => ToolFilePage(),
                ),
                GoRoute(
                  path: '/other',
                  builder: (_, _) => ToolOtherPage(),
                ),
              ],
            ),
          ],
        ),
      ];

  // 跳转首页
  void goHome() => go('/');

  // 跳转模块-数据库操作
  void goModuleDatabase() => go('/module/database');

  // 跳转模块-网络请求
  void goModuleApi() => go('/module/api');

  // 跳转模块-应用配置/缓存
  void goModuleConfig() => go('/module/config');

  // 跳转模块-主题样式
  void goModuleTheme() => go('/module/theme');

  // 跳转模块-路由管理
  void goModuleRouter() => go('/module/router');

  // 跳转组件-列表刷新组件
  void goWidgetRefresh() => go('/widget/refresh');

  // 跳转组件-状态/异步状态构造器
  void goWidgetLoadStatus() => go('/widget/loadStatus');

  // 跳转组件-异步加载弹层、消息提示
  void goWidgetNotice() => go('/widget/notice');

  // 跳转组件-其他组件
  void goWidgetOther() => go('/widget/other');

  // 跳转工具-日期时间工具
  void goToolDate() => go('/tool/date');

  // 跳转工具-防抖、节流
  void goToolDebounce() => go('/tool/debounce');

  // 跳转工具-日志工具
  void goToolLog() => go('/tool/log');

  // 跳转工具-文件管理工具、文件选择、路径选择
  void goToolFile() => go('/tool/file');

  // 跳转工具-其他
  void goToolOther() => go('/tool/other');
}

// 全局单例
final router = Router();

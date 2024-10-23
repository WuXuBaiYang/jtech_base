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
            /// TODO 在此处添加子路由
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

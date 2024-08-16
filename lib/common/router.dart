import 'package:go_router/go_router.dart';

/*
* 路由基类
* @author wuxubaiyang
* @Time 2024/8/14 13:23
*/
abstract class BaseRouter {
  // 路由配置
  GoRouter? _routerConfig;

  // 获取路由配置
  GoRouter get routerConfig {
    assert(_routerConfig != null, 'Router is not initialized!');
    return _routerConfig!;
  }

  // 默认路由列表
  List<RouteBase> get routes;

  // 添加路由（只在创建之前生效）
  void addRoutes(List<RouteBase> routes) => this.routes.addAll(routes);

  // 创建路由
  GoRouter createRouter({
    List<RouteBase> extensions = const [],
    String initialLocation = '/',
  }) =>
      _routerConfig = GoRouter(
        routes: routes + extensions,
        initialLocation: initialLocation,
      );
}

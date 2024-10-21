import 'dart:convert';

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
      _routerConfig ??= GoRouter(
        routes: routes + extensions,
        initialLocation: initialLocation,
      );

  // 推送
  Future<T?> push<T extends Object?>(String location, {Object? extra}) =>
      routerConfig.push(location, extra: extra);

  // 推送
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
  }) {
    return routerConfig.pushNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: _handleParameters(queryParameters),
    );
  }

  // 推送
  Future<T?> pushReplacement<T extends Object?>(String location,
          {Object? extra}) =>
      routerConfig.pushReplacement(location, extra: extra);

  // 推送
  Future<T?> pushReplacementNamed<T extends Object?>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
  }) {
    return routerConfig.pushReplacementNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: _handleParameters(queryParameters),
    );
  }

  // 跳转
  void go(String location, {Object? extra}) =>
      routerConfig.go(location, extra: extra);

  // 跳转
  void goNamed(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
  }) {
    return routerConfig.goNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: _handleParameters(queryParameters),
    );
  }

  // 处理路由传参问题（接收多种格式类型）
  Map<String, dynamic> _handleParameters(Map<String, dynamic> queryParameters) {
    return queryParameters.map((k, v) {
      if (v is String) return MapEntry(k, v);
      // 如果是数字、布尔、浮点数、数字类型，则转为字符串
      if ([int, bool, double, num].contains(v.runtimeType)) {
        return MapEntry(k, '$v');
      }
      try {
        return MapEntry(k, jsonEncode(v));
      } catch (_) {}
      // 其他类型直接返回
      return MapEntry(k, v);
    });
  }
}

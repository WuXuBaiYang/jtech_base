import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'provider.dart';
import 'view.dart';

/*
* 页面基类
* @author wuxubaiyang
* @Time 2023/11/20 15:30
*/
abstract class ProviderPage<T extends PageProvider> extends ProviderView<T> {
  // 路由状态管理
  final GoRouterState? _state;

  ProviderPage({
    super.key,
    GoRouterState? state,
  }) : _state = state;

  @override
  T? createProvider(BuildContext context) =>
      createPageProvider(context, _state);

  // 创建页面provider
  T createPageProvider(BuildContext context, GoRouterState? state);
}

/*
* 页面状态管理
* @author wuxubaiyang
* @Time 2024/8/11 20:44
*/
abstract class PageProvider extends BaseProvider {
  final GoRouterState? state;

  PageProvider(super.context, [this.state]);

  // 从state中获取值
  T? find<T>(String key) {
    // 先检查query/path中是否包含目标值
    final value = state?.uri.queryParameters[key] ?? state?.pathParameters[key];
    if (value != null) return value as T?;
    // 然后检查extra是否为map，且包含目标值
    if (state?.extra is Map) {
      final value = (state?.extra as Map<String, dynamic>)[key];
      if (value != null) return value as T?;
    }
    return null;
  }

  // 从state中获取整数
  int? findInt(String key) {
    final value = find(key);
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  // 从state中获取浮点数
  double? findDouble(String key) {
    final value = find(key);
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }

  // 总state中获取num
  num? findNum(String key) {
    final value = find(key);
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  // 从state中获取布尔值
  bool? findBool(String key) {
    final value = find(key);
    if (value is bool) return value;
    if (value is String) return bool.tryParse(value);
    return null;
  }

  // 获取extra
  T? getExtra<T>() => state?.extra as T?;
}

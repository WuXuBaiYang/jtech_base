import 'dart:convert';
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
  String? find(String key) =>
      state?.uri.queryParameters[key] ?? state?.pathParameters[key];

  // 从state中获取整数
  int? findInt(String key) {
    final value = find(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  // 从state中获取布尔值
  bool? findBool(String key) {
    final value = find(key);
    if (value == null) return null;
    return bool.tryParse(value);
  }

  // 从state中获取浮点数
  double? findDouble(String key) {
    final value = find(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  // 从state中获取json
  Map<String, dynamic>? findJson(String key) {
    final value = find(key);
    if (value == null) return null;
    return jsonDecode(value);
  }

  // 从state中获取json数组
  List<T>? findJsonList<T>(String key) {
    final value = find(key);
    if (value == null) return null;
    return List<T>.from(jsonDecode(value));
  }

  // 获取extra
  T? getExtra<T>() => state?.extra as T?;
}

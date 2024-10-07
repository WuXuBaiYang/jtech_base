import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'provider.dart';
import 'view.dart';

/*
* 页面基类
* @author wuxubaiyang
* @Time 2023/11/20 15:30
*/
abstract class ProviderPage<T extends PageProvider> extends ProviderView {
  // 路由状态管理
  final GoRouterState? state;

  const ProviderPage({super.key, this.state});

  @override
  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(
            create: (context) => createProvider(context, state), lazy: lazy),
        ...extensionProviders(),
      ];

  // 获取页面provider
  T getProvider(BuildContext context) => context.read<T>();

  // 页面provider是否懒加载
  bool get lazy => true;

  // 创建页面provider
  T createProvider(BuildContext context, GoRouterState? state);

  // 扩展provider
  List<SingleChildWidget> extensionProviders() => [];
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
  String? find(String key) => state?.uri.queryParameters[key];

  // 从state中获取整数
  int? findInt(String key) => int.tryParse(find(key) ?? '');

  // 从state中获取布尔值
  bool? findBool(String key) => bool.tryParse(find(key) ?? '');

  // 从state中获取浮点数
  double? findDouble(String key) => double.tryParse(find(key) ?? '');

  // 从state中获取json
  Map<String, dynamic>? findJson(String key) {
    final value = find(key);
    return value != null ? jsonDecode(value) : null;
  }

  // 从state中获取json数组
  List<T>? findJsonList<T>(String key) {
    final value = find(key);
    return value != null ? List<T>.from(jsonDecode(value)) : null;
  }

  // 获取extra
  T? getExtra<T>() => state?.extra as T?;
}

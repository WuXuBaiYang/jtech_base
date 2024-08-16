import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jtech_base/widget/loading.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2023/7/19 16:43
*/
class Loading {
  // 加载弹窗dialog缓存
  static Future? _loading;

  // 展示加载弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required Future<T?> loadFuture,
    bool dismissible = true,
  }) async {
    final buildFlag = Completer<bool>();
    final navigator = Navigator.of(context);
    try {
      if (_loading != null) navigator.maybePop();
      _loading = showDialog<void>(
          context: context,
          barrierDismissible: dismissible,
          builder: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!buildFlag.isCompleted) buildFlag.complete(false);
            });
            return _buildLoading(context);
          })
        ..whenComplete(() => _loading = null);
      return await loadFuture;
    } catch (e) {
      rethrow;
    } finally {
      await buildFlag.future;
      if (_loading != null) await navigator.maybePop();
    }
  }

  // 构建加载视图
  static Widget _buildLoading(BuildContext context) {
    final constraints = BoxConstraints.tight(const Size.square(80));
    final decoration = BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
    );
    final loadingSize = constraints.minWidth * 0.6;
    return Center(
      child: Container(
        decoration: decoration,
        constraints: constraints,
        alignment: Alignment.center,
        child: LoadingView.random(size: loadingSize),
      ),
    );
  }
}

// 扩展future方法实现loading
extension LoadingFuture<T> on Future<T> {
  Future<T?> loading(BuildContext context, {bool dismissible = true}) =>
      Loading.show(context, loadFuture: this, dismissible: dismissible);
}

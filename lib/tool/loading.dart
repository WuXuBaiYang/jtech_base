import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jtech_base/widget/loading.dart';

/*
* 加载弹窗动画
* @author wuxubaiyang
* @Time 2023/7/19 16:43
*/
class Loading {
  // 弹层缓存(全局同时有且只有一个)
  static OverlayEntry? _loading;

  // 展示加载弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required Future<T?> loadFuture,
    bool dismissible = true,
  }) async {
    try {
      _loading?.remove();
      Overlay.of(context).insert(_loading = OverlayEntry(builder: (_) {
        return _buildLoading(context, dismissible);
      }));
      return await loadFuture;
    } catch (e) {
      rethrow;
    } finally {
      _loading?.remove();
      _loading = null;
    }
  }

  // 构建加载视图
  static Widget _buildLoading(BuildContext context, [bool dismissible = true]) {
    final constraints = BoxConstraints.tight(const Size.square(80));
    final decoration = BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
    );
    final loadingSize = constraints.minWidth * 0.6;
    return GestureDetector(
      onTap: () {
        if (!dismissible) return;
        _loading?.remove();
        _loading = null;
      },
      child: AbsorbPointer(
        child: Material(
          color: Colors.black38,
          child: Center(
            child: Container(
              decoration: decoration,
              constraints: constraints,
              alignment: Alignment.center,
              child: LoadingView.random(size: loadingSize),
            ),
          ),
        ),
      ),
    );
  }
}

// 扩展future方法实现loading
extension LoadingFuture<T> on Future<T> {
  Future<T?> loading(BuildContext context, {bool dismissible = true}) =>
      Loading.show(context, loadFuture: this, dismissible: dismissible);
}

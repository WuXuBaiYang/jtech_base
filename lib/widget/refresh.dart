import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'loading/status.dart';

// 刷新控件构造器
typedef CustomRefreshWidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> data);

/*
* 自定义刷新控件
* @author wuxubaiyang
* @Time 2024/8/11 0:29
*/
class CustomRefreshView<T> extends StatelessWidget {
  // 自定义刷新控制器
  final CustomRefreshController<T> controller;

  // 是否初始化刷新
  final bool initRefresh;

  // 刷新/加载
  final ValueChanged<bool>? onRefreshLoad;

  // 是否启用刷新
  final bool enableRefresh;

  // 是否启用加载
  final bool enableLoad;

  // 子元素构建
  final CustomRefreshWidgetBuilder<T> builder;

  const CustomRefreshView({
    super.key,
    required this.builder,
    required this.controller,
    this.onRefreshLoad,
    this.enableLoad = true,
    this.initRefresh = true,
    this.enableRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).primaryColor.withOpacity(0.4);
    final refreshHeader =
        BezierCircleHeader(backgroundColor: background, triggerOffset: 60);
    final loadFooter =
        BezierFooter(backgroundColor: background, triggerOffset: 60);
    final onLoad = enableLoad ? () => onRefreshLoad?.call(true) : null;
    final onRefresh = enableRefresh ? () => onRefreshLoad?.call(false) : null;
    return EasyRefresh(
      onLoad: onLoad,
      footer: loadFooter,
      onRefresh: onRefresh,
      header: refreshHeader,
      canLoadAfterNoMore: true,
      canRefreshAfterNoMore: true,
      refreshOnStart: initRefresh,
      controller: controller._controller,
      child: _buildContent(context),
    );
  }

  // 构建内容
  Widget _buildContent(BuildContext context) {
    return ValueListenableBuilder<CustomRefreshControllerValue<T>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return LoadingStatusBuilder(
          status: value.loadStatus,
          builder: (_, __) {
            return builder(context, value.data);
          },
        );
      },
    );
  }
}

// 自定义刷新控件控制器值类型元组
typedef CustomRefreshControllerValue<T> = ({
  List<T> data,
  LoadStatus loadStatus
});

/*
* 自定义刷新控件控制器
* @author wuxubaiyang
* @Time 2024/8/11 0:29
*/
class CustomRefreshController<T>
    extends ValueNotifier<CustomRefreshControllerValue<T>> {
  // 刷新控制器
  final _controller = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  CustomRefreshController(
    List<T> data, {
    this.pageSize = 25,
    int initialPageIndex = 1,
    LoadStatus initialLoadStatus = LoadStatus.success,
  })  : _pageIndex = initialPageIndex,
        super((data: data, loadStatus: initialLoadStatus));

  CustomRefreshController.empty({
    this.pageSize = 25,
    int initialPageIndex = 1,
    LoadStatus initialLoadStatus = LoadStatus.success,
  })  : _pageIndex = initialPageIndex,
        super((data: <T>[], loadStatus: initialLoadStatus));

  // 分页下标
  int _pageIndex = 1;

  // 获取当前分页下标
  int get currentPageIndex => _pageIndex;

  // 根据加载状态获取分页下标
  int getPage(bool loadMore) => loadMore ? _pageIndex + 1 : 1;

  // 分页数据量
  final int pageSize;

  // 启动刷新
  void startRefresh([bool force = true]) =>
      _controller.callRefresh(force: force);

  // 结束刷新/加载
  void finish(List<T> data, [bool loadMore = true]) {
    _pageIndex = getPage(loadMore);
    final indicatorResult = data.length < pageSize
        ? IndicatorResult.noMore
        : IndicatorResult.success;
    final loadStatus = loadMore || (!loadMore && data.isNotEmpty)
        ? LoadStatus.success
        : LoadStatus.empty;
    if (loadMore) {
      _controller.finishLoad(indicatorResult, true);
      return _update(data: value.data + data, loadStatus: loadStatus);
    }
    _controller.finishRefresh(indicatorResult, true);
    return _update(data: data, loadStatus: loadStatus);
  }

  // 异常结束刷新/加载
  void finishWithError() {
    if (value.data.isNotEmpty) return;
    return _update(loadStatus: LoadStatus.fail);
  }

  // 更新条件对象
  void updateWhere(T? Function(T) update) {
    final list = List<T>.from(value.data);
    for (var i = 0; i < list.length; i++) {
      final result = update(list[i]);
      if (result != null) list[i] = result;
    }
    _update(data: list, loadStatus: LoadStatus.success);
  }

  // 设置数据
  void setData(List<T> data) =>
      _update(data: data, loadStatus: LoadStatus.success);

  // 添加一条数据
  void add(T data) => addAll([data]);

  // 添加数据
  void addAll(List<T> data) =>
      _update(data: value.data + data, loadStatus: LoadStatus.success);

  // 移除一条数据
  void remove(T data) => removeAll([data]);

  // 移除数据
  void removeAll(List<T> data) {
    final list = List<T>.from(value.data)..removeWhere((e) => data.contains(e));
    final loadState = list.isNotEmpty ? LoadStatus.success : LoadStatus.empty;
    _update(data: list, loadStatus: loadState);
  }

  // 根据条件移除数据
  void removeWhere(bool Function(T) test) {
    final list = List<T>.from(value.data)..removeWhere(test);
    final loadState = list.isNotEmpty ? LoadStatus.success : LoadStatus.empty;
    _update(data: list, loadStatus: loadState);
  }

  // 清空所有数据
  void clear() => _update(data: <T>[], loadStatus: LoadStatus.empty);

  // 更新数据
  void _update({List<T>? data, LoadStatus? loadStatus}) {
    value = (
      data: data ?? value.data,
      loadStatus: loadStatus ?? value.loadStatus,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

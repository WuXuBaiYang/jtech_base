import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
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

  // 头部
  final Header? header;

  // 足部
  final Footer? footer;

  // 子元素构建
  final CustomRefreshWidgetBuilder<T> builder;

  // 报错状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? failBuilder;

  // 空数据状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder;

  // 加载中状态构建
  final ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder;

  // 加载状态样式
  final LoadingStatusStyle? style;

  const CustomRefreshView({
    super.key,
    required this.builder,
    required this.controller,
    this.header,
    this.footer,
    this.onRefreshLoad,
    this.enableLoad = true,
    this.initRefresh = true,
    this.enableRefresh = true,
    this.style,
    this.failBuilder,
    this.noDataBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CustomRefreshThemeData.of(context);
    final footer = this.footer ?? themeData.footer;
    final header = this.header ?? themeData.header;
    final onLoad = enableLoad ? () => onRefreshLoad?.call(true) : null;
    final onRefresh = enableRefresh ? () => onRefreshLoad?.call(false) : null;
    return EasyRefresh(
      onLoad: onLoad,
      header: header,
      footer: footer,
      onRefresh: onRefresh,
      canLoadAfterNoMore: true,
      canRefreshAfterNoMore: true,
      refreshOnStart: initRefresh,
      controller: controller._controller,
      child: _buildContent(context, themeData),
    );
  }

  // 构建内容
  Widget _buildContent(BuildContext context, CustomRefreshThemeData themeData) {
    return ValueListenableBuilder<CustomRefreshControllerValue<T>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return LoadingStatusBuilder(
          status: value.loadStatus,
          style: style ?? themeData.style,
          failBuilder: failBuilder ?? themeData.failBuilder,
          noDataBuilder: noDataBuilder ?? themeData.noDataBuilder,
          loadingBuilder: loadingBuilder ?? themeData.loadingBuilder,
          builder: (_, __) => builder(context, value.data),
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
        : LoadStatus.noData;
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
    final loadState = list.isNotEmpty ? LoadStatus.success : LoadStatus.noData;
    _update(data: list, loadStatus: loadState);
  }

  // 根据条件移除数据
  void removeWhere(bool Function(T) test) {
    final list = List<T>.from(value.data)..removeWhere(test);
    final loadState = list.isNotEmpty ? LoadStatus.success : LoadStatus.noData;
    _update(data: list, loadStatus: loadState);
  }

  // 清空所有数据
  void clear() => _update(data: <T>[], loadStatus: LoadStatus.noData);

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

/*
* 自定义刷新组件样式
* @author wuxubaiyang
* @Time 2024/10/22 11:30
*/
class CustomRefreshThemeData extends LoadingStatusThemeData {
  // 头部
  final Header? header;

  // 足部
  final Footer? footer;

  const CustomRefreshThemeData({
    this.header,
    this.footer,
    super.style,
    super.failBuilder,
    super.noDataBuilder,
    super.loadingBuilder,
  });

  // 获取通知主题
  static CustomRefreshThemeData of(BuildContext context) =>
      maybeOf(context) ?? const CustomRefreshThemeData();

  // 获取通知主题
  static CustomRefreshThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.customRefreshTheme;

  @override
  CustomRefreshThemeData copyWith({
    Header? header,
    Footer? footer,
    LoadingStatusStyle? style,
    ValueWidgetBuilder<LoadingStatusStyle>? failBuilder,
    ValueWidgetBuilder<LoadingStatusStyle>? noDataBuilder,
    ValueWidgetBuilder<LoadingStatusStyle>? loadingBuilder,
  }) {
    return CustomRefreshThemeData(
      header: header ?? this.header,
      footer: footer ?? this.footer,
      style: style ?? this.style,
      failBuilder: failBuilder ?? this.failBuilder,
      noDataBuilder: noDataBuilder ?? this.noDataBuilder,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
    );
  }

  static CustomRefreshThemeData lerp(
      CustomRefreshThemeData? a, CustomRefreshThemeData? b, double t) {
    if (a == null && b == null) return CustomRefreshThemeData();
    return CustomRefreshThemeData(
      header: b?.header,
      footer: b?.footer,
      style: LoadingStatusStyle.lerp(a?.style, b?.style, t),
      failBuilder: t < 0.5 ? a?.failBuilder : b?.failBuilder,
      noDataBuilder: t < 0.5 ? a?.noDataBuilder : b?.noDataBuilder,
      loadingBuilder: t < 0.5 ? a?.loadingBuilder : b?.loadingBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CustomRefreshThemeData &&
      other.header == header &&
      other.footer == footer &&
      other.style == style &&
      other.failBuilder == failBuilder &&
      other.noDataBuilder == noDataBuilder &&
      other.loadingBuilder == loadingBuilder;

  @override
  int get hashCode => Object.hashAll([
        header,
        footer,
        style,
        failBuilder,
        noDataBuilder,
        loadingBuilder,
      ]);
}

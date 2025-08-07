import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/common/theme.dart';
import 'loading/status.dart';

// 刷新控件构造器
typedef CustomRefreshWidgetBuilder<T> =
    Widget Function(BuildContext context, List<T> data, LoadStatus status);

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
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CustomRefreshThemeData.of(context);
    // 获取当前区域
    final footer =
        this.footer ?? themeData.footer ?? _createDefaultFooter(context);
    final header =
        this.header ?? themeData.header ?? _createDefaultHeader(context);
    final onLoad = enableLoad ? () => onRefreshLoad?.call(true) : null;
    final onRefresh = enableRefresh ? () => onRefreshLoad?.call(false) : null;
    return EasyRefresh(
      onLoad: onLoad,
      header: header,
      footer: footer,
      onRefresh: onRefresh,
      // canLoadAfterNoMore: false,
      refreshOnStart: initRefresh,
      canRefreshAfterNoMore: true,
      controller: controller._controller,
      child: _buildContent(context, themeData),
    );
  }

  // 构建内容
  Widget _buildContent(BuildContext context, CustomRefreshThemeData themeData) {
    return ValueListenableBuilder<CustomRefreshControllerValue<T>>(
      valueListenable: controller,
      builder: (_, value, _) {
        return builder(context, value.data, value.loadStatus);
      },
    );
  }
}

// 自定义刷新控件控制器值类型元组
typedef CustomRefreshControllerValue<T> = ({
  List<T> data,
  LoadStatus loadStatus,
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
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  CustomRefreshController(
    List<T> data, {
    this.pageSize = 25,
    int initialPageIndex = 1,
    LoadStatus initialLoadStatus = LoadStatus.success,
  }) : _pageIndex = initialPageIndex,
       super((data: data, loadStatus: initialLoadStatus));

  CustomRefreshController.empty({
    this.pageSize = 25,
    int initialPageIndex = 1,
    LoadStatus initialLoadStatus = LoadStatus.success,
  }) : _pageIndex = initialPageIndex,
       super((data: <T>[], loadStatus: initialLoadStatus));

  // 分页下标
  int _pageIndex = 1;

  // 获取当前分页下标
  int get currentPageIndex => _pageIndex;

  // 根据加载状态获取分页下标
  int getPage(bool loadMore) => loadMore ? _pageIndex + 1 : 1;

  // 分页数据量
  final int pageSize;

  // 是否存在刷新
  bool get loading => isRefreshing || isLoadingMore;

  // 是否正在下拉刷新
  bool get isRefreshing => !_controller.controlFinishRefresh;

  // 是否正在加载更多
  bool get isLoadingMore => !_controller.controlFinishLoad;

  // 启动刷新
  void startRefresh({
    bool force = true,
    double? overOffset,
    Duration? duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    ScrollController? scrollController,
  }) {
    _controller.callRefresh(
      force: force,
      overOffset: overOffset,
      duration: duration,
      curve: curve,
      scrollController: scrollController,
    );
  }

  // 结束刷新/加载
  void finish(List<T> data, [bool loadMore = true]) {
    _pageIndex = getPage(loadMore);
    final indicatorResult = data.length < pageSize
        ? IndicatorResult.noMore
        : IndicatorResult.success;
    final loadStatus = loadMore || (!loadMore && data.isNotEmpty)
        ? LoadStatus.success
        : LoadStatus.noData;
    _finish(indicatorResult);
    return _update(
      data: loadMore ? value.data + data : data,
      loadStatus: loadStatus,
    );
  }

  // 异常结束刷新/加载
  void finishWithError() {
    _finish(IndicatorResult.fail);
    _update(loadStatus: LoadStatus.fail);
  }

  // 结束刷新
  void _finish(IndicatorResult indicatorResult) {
    _controller.finishRefresh(indicatorResult);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.finishLoad(indicatorResult);
    });
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
class CustomRefreshThemeData {
  // 头部
  final Header? header;

  // 足部
  final Footer? footer;

  const CustomRefreshThemeData({this.header, this.footer});

  // 获取通知主题
  static CustomRefreshThemeData of(BuildContext context) =>
      maybeOf(context) ?? CustomRefreshThemeData();

  // 获取通知主题
  static CustomRefreshThemeData? maybeOf(BuildContext context) =>
      CustomTheme.maybeOf(context)?.customRefreshTheme;

  CustomRefreshThemeData copyWith({Header? header, Footer? footer}) {
    return CustomRefreshThemeData(
      header: header ?? this.header,
      footer: footer ?? this.footer,
    );
  }

  static CustomRefreshThemeData lerp(
    CustomRefreshThemeData? a,
    CustomRefreshThemeData? b,
    double t,
  ) {
    if (a == null && b == null) return CustomRefreshThemeData();
    return CustomRefreshThemeData(header: b?.header, footer: b?.footer);
  }

  @override
  bool operator ==(Object other) =>
      other is CustomRefreshThemeData &&
      other.header == header &&
      other.footer == footer;

  @override
  int get hashCode => Object.hashAll([header, footer]);
}

// 默认刷新头
Header _createDefaultHeader(BuildContext context) {
  final local = Localizations.localeOf(context);
  if (local.languageCode != 'zh') return ClassicHeader();
  return ClassicHeader(
    dragText: '下拉刷新',
    armedText: '松开刷新',
    readyText: '刷新中...',
    processingText: '刷新中...',
    processedText: '刷新成功',
    noMoreText: '没有更多数据',
    failedText: '刷新失败',
    messageText: '最后更新时间 %T',
    textStyle: TextTheme.of(context).bodyLarge,
    messageStyle: TextTheme.of(context).bodySmall,
  );
}

// 默认刷新脚
Footer _createDefaultFooter(BuildContext context) {
  final local = Localizations.localeOf(context);
  if (local.languageCode != 'zh') return ClassicFooter();
  return ClassicFooter(
    dragText: '上拉加载',
    armedText: '松开加载',
    readyText: '加载中...',
    processingText: '加载中...',
    processedText: '加载成功',
    noMoreText: '没有更多数据',
    failedText: '加载失败',
    messageText: '最后更新时间 %T',
    textStyle: TextTheme.of(context).bodyLarge,
    messageStyle: TextTheme.of(context).bodySmall,
  );
}

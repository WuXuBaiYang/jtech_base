import 'package:example/common/router.dart';
import 'package:example/page/home/view.dart';
import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';

/*
* 首页
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomePage extends ProviderPage<HomePageProvider> {
  HomePage({super.key, super.state});

  @override
  HomePageProvider createPageProvider(
    BuildContext context,
    GoRouterState? state,
  ) => HomePageProvider(context, state);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      bottomNavigationBar: _buildNavigationBar(context),
    );
  }

  // 构建内容
  Widget _buildContent(BuildContext context) {
    // 页面中直接调用provider则指代下方跟随页面的HomePageProvider
    final children = provider.pages.map((e) => e.child!).toList();
    // ProviderPage与ProviderView皆可以使用createSelector方法
    return createSelector<int>(
      selector: (_, provider) => provider.currentIndex,
      builder: (_, currentIndex, _) {
        return IndexedStack(index: currentIndex, children: children);
      },
    );
  }

  // 构建底部导航
  Widget _buildNavigationBar(BuildContext context) {
    final destinations = provider.pages.map((e) {
      return NavigationDestination(icon: e.icon!, label: e.label);
    }).toList();
    return createSelector<int>(
      selector: (_, provider) => provider.currentIndex,
      builder: (_, currentIndex, _) {
        return NavigationBar(
          destinations: destinations,
          selectedIndex: currentIndex,
          onDestinationSelected: provider.updateCurrentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        );
      },
    );
  }
}

/*
* 首页状态管理
* @author wuxubaiyang
* @Time 2024/7/30 17:00
*/
class HomePageProvider extends PageProvider {
  // 首页分页集合
  late final List<OptionItem> pages = [
    OptionItem(
      label: '模块',
      icon: const Icon(Icons.view_module_rounded),
      child: HomeSubView(title: '模块', options: modules),
    ),
    OptionItem(
      label: '组件',
      icon: const Icon(Icons.widgets_rounded),
      child: HomeSubView(title: '组件', options: widgets),
    ),
    OptionItem(
      label: '工具',
      icon: const Icon(Icons.build_rounded),
      child: HomeSubView(title: '工具', options: tools),
    ),
  ];

  // 模块列表
  final modules = [
    OptionItem(
      label: '数据库',
      subLabel: '接入Objectbox数据库，封装了基本使用方法',
      onTap: router.goModuleDatabase,
      icon: const Icon(Icons.view_module_outlined),
    ),
    OptionItem(
      label: '网络请求',
      subLabel: '演示基本网络请求方法与扩展使用方法',
      onTap: router.goModuleApi,
      icon: const Icon(Icons.view_module_outlined),
    ),
    OptionItem(
      label: '应用配置/缓存',
      subLabel: '封装了应用内零散配置字段与缓存字段的读写方法',
      onTap: router.goModuleConfig,
      icon: const Icon(Icons.view_module_outlined),
    ),
    OptionItem(
      label: '主题样式',
      subLabel: '自定义主题与主题样式更改',
      onTap: router.goModuleTheme,
      icon: const Icon(Icons.view_module_outlined),
    ),
    OptionItem(
      label: '路由管理',
      subLabel: '路由管理与路由跳转方法',
      onTap: router.goModuleRouter,
      icon: const Icon(Icons.view_module_outlined),
    ),
  ];

  // 组件列表
  final widgets = [
    OptionItem(
      label: '列表刷新组件',
      subLabel: '列表下拉刷新、上拉加载，数据管理，分页管理',
      onTap: router.goWidgetRefresh,
      icon: Icon(Icons.widgets_outlined),
    ),
    OptionItem(
      label: '状态/异步状态构造器',
      subLabel: '用于管理状态、异步状态、错误状态、空状态',
      onTap: router.goWidgetLoadStatus,
      icon: Icon(Icons.widgets_outlined),
    ),
    OptionItem(
      label: '异步加载弹层、消息提示',
      subLabel: 'loading、toast、notice等组件演示',
      onTap: router.goWidgetNotice,
      icon: Icon(Icons.widgets_outlined),
    ),
    OptionItem(
      label: '其他组件',
      subLabel: '自定义图片、自定义对话框、组件状态保持',
      onTap: router.goWidgetOther,
      icon: Icon(Icons.widgets_outlined),
    ),
  ];

  // 工具集合
  final tools = [
    OptionItem(
      label: '日期时间工具',
      subLabel: '时间段格式化、时间格式化、解析等',
      onTap: router.goToolDate,
      icon: Icon(Icons.build_outlined),
    ),
    OptionItem(
      label: '防抖、节流',
      subLabel: '演示防抖、节流的使用方法',
      onTap: router.goToolDebounce,
      icon: Icon(Icons.build_outlined),
    ),
    OptionItem(
      label: '日志工具',
      subLabel: '演示日志工具的使用方法',
      onTap: router.goToolLog,
      icon: Icon(Icons.build_outlined),
    ),
    OptionItem(
      label: '文件管理工具、文件选择、路径选择',
      subLabel: '演示文件管理工具的使用方法',
      onTap: router.goToolFile,
      icon: Icon(Icons.build_outlined),
    ),
    OptionItem(
      label: '其他工具',
      subLabel: '列表方法扩展、随机数、加密、生成id等',
      onTap: router.goToolOther,
      icon: Icon(Icons.build_outlined),
    ),
  ];

  HomePageProvider(super.context, super.state);

  // 分页下标
  int _currentIndex = 0;

  // 获取分页下标
  int get currentIndex => _currentIndex;

  // 更新分页下标
  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();

    /// provider中可以直接使用 showNoticeSuccess(message) 与 showToast(message)
    /// provider中可以直接使用context，不需要传入
    /// 如有路由传入参数，可通过find及其扩展方法获取，可以点击PageProvider查看
  }
}

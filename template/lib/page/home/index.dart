import 'package:flutter/material.dart';
import 'package:jtech_base/jtech_base.dart';
import 'package:template/page/home/page.dart';

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
      label: 'page1',
      icon: const Icon(Icons.home),

      /// 如果在tabView/PageView中使用，请使用KeepAliveWrapper包裹，避免页面被回收
      child: KeepAliveWrapper(child: HomeSubView(title: 'page1')),
    ),
    OptionItem(
      label: 'page2',
      icon: const Icon(Icons.favorite),
      child: HomeSubView(title: 'page2'),
    ),
    OptionItem(
      label: 'page3',
      icon: const Icon(Icons.person),
      child: HomeSubView(title: 'page2'),
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

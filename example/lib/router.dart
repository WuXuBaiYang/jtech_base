import 'package:example/tool/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:jtech_base/jtech_base.dart';


import 'main.dart';
import 'tool/loading.dart';
import 'tool/notice.dart';

/*
* 路由管理
* @author wuxubaiyang
* @Time 2024/10/21 13:39
*/
class Router extends BaseRouter {
  static final Router _instance = Router._internal();

  factory Router() => _instance;

  Router._internal();

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/',
          builder: (_, __) => MyHomePage(),
          routes: [
            GoRoute(
              path: '/tool',
              builder: (_, __) => SizedBox(),
              routes: [
                GoRoute(
                  path: '/dialog',
                  builder: (_, state) => ToolDialogPage(state: state),
                ),
                GoRoute(
                  path: '/loading',
                  builder: (_, state) => ToolLoadingPage(state: state),
                ),
                GoRoute(
                  path: '/notice',
                  builder: (_, state) => ToolNoticePage(state: state),
                ),
              ],
            ),
          ],
        ),
      ];

  // 跳转工具-对话框
  Future<void> goToolDialog() => push('/tool/dialog');

  // 跳转工具-加载框
  Future<void> goToolLoading() => push('/tool/loading');

  // 跳转工具-通知
  Future<void> goToolNotice() => push('/tool/notice');
}

// 全局单例
final router = Router();

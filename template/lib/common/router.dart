import 'package:jtech_base/jtech_base.dart';
import 'package:template/page/home/index.dart';

/*
* 路由管理
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class Router extends BaseRouter {
  static final Router _instance = Router._internal();

  factory Router() => _instance;

  Router._internal();

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomePage(state: state),
          routes: [
            /// TODO 在此处添加子路由
          ],
        ),
      ];

  // 跳转首页
  void goHome() => go('/');
}

// 全局单例
final router = Router();

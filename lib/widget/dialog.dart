import 'package:flutter/material.dart';
import 'package:jtech_base/tool/overlay.dart';

// 管理全局dialog
final _customDialogOverlay = CustomOverlay();

// 通过key取消dialog
void cancelCustomDialog(String key) => _customDialogOverlay.cancel(key);

// 展示自定义弹窗
Future<T?> showCustomDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? key,
  bool dismissible = true,
  Curve curve = Curves.easeIn,
  CustomOverlayToken<T>? token,
  Curve reverseCurve = Curves.easeOut,
  Color barrierColor = Colors.black38,
}) {
  token ??= CustomOverlayToken<T>();
  return _customDialogOverlay.insert<T>(
    context,
    key: key,
    token: token,
    dismissible: dismissible,
    barrierColor: barrierColor,
    alignment: Alignment.center,
    animationDuration: Duration(milliseconds: 200),
    builder: (_, animation, __) {
      return FadeTransition(
        opacity: CurvedAnimation(
          curve: curve,
          parent: animation,
          reverseCurve: reverseCurve,
        ),
        child: _CustomDialogScope(
          token: token!,
          child: Builder(builder: builder),
        ),
      );
    },
  );
}

/*
* 自定义弹窗
* @author wuxubaiyang
* @Time 2024/7/31 20:59
*/
class CustomDialog extends StatelessWidget {
  // 标题
  final Widget? title;

  // 内容
  final Widget? content;

  // 操作按钮
  final List<Widget> actions;

  // 是否可滚动
  final bool scrollable;

  // 约束
  final BoxConstraints constraints;

  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
    this.scrollable = false,
    this.constraints = const BoxConstraints.tightFor(width: 280),
  });

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 8);
    return AlertDialog(
      title: title,
      actions: actions,
      scrollable: scrollable,
      contentPadding: contentPadding,
      content: ConstrainedBox(
        constraints: constraints,
        child: content,
      ),
    );
  }

  // 获取控制token
  static CustomOverlayToken? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_CustomDialogScope>();
    return scope?._token;
  }

  // 取消当前dialog
  static void cancel(BuildContext context, [data, bool withAnime = true]) =>
      maybeOf(context)?.cancel(data, withAnime);
}

/*
* 自定义弹窗作用域
* @author wuxubaiyang
* @Time 2024/10/17 16:35
*/
class _CustomDialogScope extends InheritedWidget {
  // 弹窗token
  final CustomOverlayToken _token;

  const _CustomDialogScope({
    required super.child,
    required CustomOverlayToken token,
  }) : _token = token;

  @override
  bool updateShouldNotify(_CustomDialogScope old) => false;
}

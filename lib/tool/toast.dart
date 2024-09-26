import 'package:fluttertoast/fluttertoast.dart';

/*
* toast消息通知
* @author wuxubaiyang
* @Time 2024/9/26 15:54
*/
class Toast {
  // 展示消息通知
  static void show(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}

import 'dart:async';

/*
* 消息总线工具
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
class EventBus {
  static final EventBus _instance = EventBus._internal();

  factory EventBus() => _instance;

  // 流控制器
  final StreamController _streamController;

  EventBus._internal()
      : _streamController = StreamController.broadcast(sync: false);

  // 注册事件
  Stream<T> on<T>() =>
      _streamController.stream.where((event) => event is T).cast<T>();

  // 注册值对比事件
  Stream<T> onValue<T>(T value) =>
      _streamController.stream.where((event) => event == value).cast<T>();

  // 发送事件
  void send<T>(T event) => _streamController.add(event);
}

// 全局单例
final eventBus = EventBus();

import 'package:jtech_base/tool/cache.dart';
import 'provider.dart';

// 配置信息创建回调
typedef ConfigCreator<T> = T Function(dynamic json);

// 配置信息序列化回调
typedef ConfigSerializer<T> = dynamic Function(T config);

/*
* 配置文件基类
* @author wuxubaiyang
* @Time 2024/8/14 14:03
*/
abstract class BaseConfigProvider<T> extends BaseProvider {
  // 配置信息
  late T _config;

  // 获取配置信息
  T get config => _config;

  // 序列化回调
  final ConfigSerializer<T> _serializer;

  // 配置缓存key
  String get configCacheKey => 'app_config_cache_key';

  BaseConfigProvider(super.context,
      {required ConfigCreator<T> creator,
      required ConfigSerializer<T> serializer})
      : _serializer = serializer {
    _config = creator(localCache.getJson(configCacheKey));
  }

  // 保存配置信息
  Future<bool> updateConfig(T config) async {
    final json = _serializer(_config = config);
    final result = await localCache.setJson(configCacheKey, json);
    if (result) notifyListeners();
    return result;
  }
}

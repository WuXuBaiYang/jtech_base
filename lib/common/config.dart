import 'package:jtech_base/tool/cache.dart';

import 'model.dart';
import 'provider/provider.dart';

// 配置信息初始化回调
typedef ConfigValueCreator<T extends BaseConfig> = T Function(dynamic obj);

/*
* 配置文件基类
* @author wuxubaiyang
* @Time 2024/8/14 14:03
*/
abstract class BaseConfigProvider<T extends BaseConfig> extends BaseProvider {
  // 配置信息
  late T _config;

  // 获取配置信息
  T get config => _config;

  BaseConfigProvider(super.context, {required ConfigValueCreator<T> creator}) {
    // 初始化配置文件信息
    _config = creator(localCache.getJson(configCacheKey));
  }

  // 配置缓存key
  String get configCacheKey;

  // 保存配置信息
  Future<bool> updateConfig(T config) async {
    final result = await localCache.setJson(
      configCacheKey,
      (_config = config).to(),
    );
    notifyListeners();
    return result;
  }
}

/*
* 基本配置数据对象
* @author wuxubaiyang
* @Time 2024/8/14 14:20
*/
abstract class BaseConfig extends BaseModel {}

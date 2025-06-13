import 'package:flutter/foundation.dart';

/*
* 静态资源/通用静态变量
* @author wuxubaiyang
* @Time 2022/9/8 14:54
*/
class Common {
  // 数据库名称
  static const String databaseName = '${jtech_base_db_name}$.db';

  // 请求基本地址
  static const String baseUrl = kDebugMode ? devUrl : prodUrl;

  // 开发地址
  static const String devUrl = '${jtech_base_dev_url}$';

  // 生产地址
  static const String prodUrl = '${jtech_base_prod_url}$';
}

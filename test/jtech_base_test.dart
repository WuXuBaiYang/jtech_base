import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test', () {
    final result = handleParameters({
      '1': '',
      '2': 1,
      '3': 1.0,
      '4': true,
      '5': [1, 2, 3],
      '6': {'a': 1, 'b': 2},
    });
    if (kDebugMode) print(result);
  });
}

// 处理路由传参问题（接收多种格式类型）
Map<String, dynamic> handleParameters(Map<String, dynamic> queryParameters) {
  return queryParameters.map((k, v) {
    // 如果是数字、布尔、浮点数、数字类型，则转为字符串
    if ([int, bool, double, num].contains(v.runtimeType)) v = '$v';
    // 如果是列表，则转为字符串列表
    if (v is List) v = v.map((e) => '$e').toList();
    // 如果是Map，则转为字符串Map
    if (v is Map) v = jsonEncode(v);
    return MapEntry(k, v);
  });
}

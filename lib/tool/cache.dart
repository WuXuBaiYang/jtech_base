import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* 本地缓存工具
* @author wuxubaiyang
* @Time 2022/3/29 10:29
*/
class LocalCache {
  static final LocalCache _instance = LocalCache._internal();

  factory LocalCache() => _instance;

  LocalCache._internal();

  // 时效字段后缀
  String _expirationSuffix = 'expiration';

  // sp对象
  SharedPreferences? _sp;

  // 获取sp对象
  SharedPreferences get sp {
    assert(_sp != null, 'need to call initialize() first');
    return _sp!;
  }

  // 初始化
  Future<void> initialize({
    String? expirationSuffix,
    String prefix = 'jtech_base.',
    Set<String>? allowList,
  }) async {
    _expirationSuffix = expirationSuffix ?? _expirationSuffix;
    SharedPreferences.setPrefix(prefix, allowList: allowList);
    _sp = await SharedPreferences.getInstance();
  }

  // 获取int类型
  int? getInt(String key) {
    if (!_check(key)) return null;
    return sp.getInt(key);
  }

  // 获取bool类型
  bool? getBool(String key) {
    if (!_check(key)) return null;
    return sp.getBool(key);
  }

  // 获取double类型
  double? getDouble(String key) {
    if (!_check(key)) return null;
    return sp.getDouble(key);
  }

  // 获取String类型
  String? getString(String key) {
    if (!_check(key)) return null;
    return sp.getString(key);
  }

  // 获取StringList类型
  List<String>? getStringList(String key) {
    if (!_check(key)) return null;
    return sp.getStringList(key);
  }

  // 获取json类型
  T? getJson<T>(String key) {
    try {
      if (!_check(key)) return null;
      final json = sp.getString(key);
      if (json != null) return jsonDecode(json) as T;
    } catch (e) {
      if (kDebugMode) print('getJson $key error:${e.toString()}');
    }
    return null;
  }

  // 设置int类型
  Future<bool> setInt(String key, int value, {Duration? expiration}) async {
    if (!await _setExpiration(key, expiration)) return false;
    return sp.setInt(key, value);
  }

  // 设置double类型
  Future<bool> setDouble(
    String key,
    double value, {
    Duration? expiration,
  }) async {
    if (!await _setExpiration(key, expiration)) return false;
    return sp.setDouble(key, value);
  }

  // 设置bool类型
  Future<bool> setBool(String key, bool value, {Duration? expiration}) async {
    if (!await _setExpiration(key, expiration)) return false;
    return sp.setBool(key, value);
  }

  // 设置string类型
  Future<bool> setString(
    String key,
    String value, {
    Duration? expiration,
  }) async {
    if (!await _setExpiration(key, expiration)) return false;
    return sp.setString(key, value);
  }

  // 设置List<string>类型
  Future<bool> setStringList(
    String key,
    List<String> value, {
    Duration? expiration,
  }) async {
    if (!await _setExpiration(key, expiration)) return false;
    return sp.setStringList(key, value);
  }

  // 设置Json类型(List/Map)泛型必须为基础类型
  Future<bool> setJson(String key, dynamic json, {Duration? expiration}) async {
    try {
      if (!await _setExpiration(key, expiration)) return false;
      return sp.setString(key, jsonEncode(json));
    } catch (e) {
      await _removeExpiration(key);
      if (kDebugMode) print('setJson $key error:${e.toString()}');
    }
    return false;
  }

  // 移除字段
  Future<bool> remove(String key) => sp.remove(key);

  // 移除多个字段
  Future<List<bool>> removeMany(List<String> keys) =>
      Future.wait(keys.map((key) => remove(key)));

  // 清空缓存的所有字段
  Future<bool> clear() => sp.clear();

  // 检查有效期
  bool _check(String key) {
    final expirationKey = _genExpirationKey(key);
    final expiration = sp.getInt(expirationKey);
    if (expiration == null) return true;
    if (expiration > DateTime.now().millisecondsSinceEpoch) return true;
    removeMany([key, expirationKey]);
    return false;
  }

  // 设置有效期
  Future<bool> _setExpiration(String key, [Duration? expiration]) async {
    if (expiration == null) return true;
    final inTime = DateTime.now().add(expiration).millisecondsSinceEpoch;
    return setInt(_genExpirationKey(key), inTime);
  }

  // 移除有效期key
  Future<bool> _removeExpiration(String key) async =>
      remove(_genExpirationKey(key));

  // 生成有效期存储字段
  String _genExpirationKey(String key) => '${key}_$_expirationSuffix';
}

// 全局单例
final localCache = LocalCache();

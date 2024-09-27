import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/*
* 数据库管理
* @author wuxubaiyang
* @Time 2022/3/17 14:14
*/
abstract class BaseDatabase {
  // 数据库对象
  Store? _store;

  // 获取isar
  Store get store {
    assert(_store != null, 'Database is not initialized!');
    return _store!;
  }

  // 初始化
  Future<void> initialize(String databaseName) async {
    final dir = await getApplicationDocumentsDirectory();
    _store = await createStore(join(dir.path, databaseName));
  }

  // 创建数据库对象
  Future<Store> createStore(String directory);

  // 创建指定数据对象的box
  Box<T> getBox<T>() => Box<T>(store);
}
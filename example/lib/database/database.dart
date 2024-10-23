import 'package:jtech_base/jtech_base.dart';
import 'package:example/objectbox.g.dart';
import 'example.dart';

/*
* 数据库入口
* @author wuxubaiyang
* @Time 2023/5/29 16:15
*/
class Database extends BaseDatabase with ExampleDatabase {
  static final Database _instance = Database._internal();

  factory Database() => _instance;

  Database._internal();

  @override
  Future<Store> createStore(String directory) async {
    return openStore(directory: directory);
  }
}

// 全局单例入口
final database = Database();

import 'dart:async';
import 'package:jtech_base/jtech_base.dart';
import 'package:templete/objectbox.g.dart';
import 'model/example.dart';

/// 数据库操作用例（可以按业务分成多个文件，添加到 Database 中）
/// 使用时只需要调用 database.putExample(entity) 即可
mixin ExampleDatabase on BaseDatabase {
  /// 示例表
  late final exampleBox = getBox<DBExampleEntity>();

  /// 添加或替换并返回当前对象（包含数据库id）
  Future<DBExampleEntity> putExample(DBExampleEntity entity) {
    return exampleBox.putAndGetAsync(entity);
  }

  /// 删除
  bool deleteExample(DBExampleEntity entity) {
    return exampleBox.remove(entity.id);
  }

  /// 查询
  List<DBExampleEntity> queryExample() {
    return exampleBox.getAll();
  }

  /// 根据id查询
  DBExampleEntity? queryExampleById(int id) {
    return exampleBox.get(id);
  }

  /// 条件查询
  List<DBExampleEntity> queryExampleWhere(String fieldString) {
    return exampleBox
        // 在这里添加查询条件
        .query(DBExampleEntity_.fieldString.equals(fieldString))
        .build()
        .find();
  }

  /// 其他使用方法请参考 objectbox 的文档{https://pub.dev/packages/objectbox}
}

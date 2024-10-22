import 'package:jtech_base/jtech_base.dart';

/// 示例数据库实体，用于演示数据库操作
/// 所有数据库实体如有修改，必须执行`flutter pub run build_runner build`命令重新生成
@Entity()
class DBExampleEntity {
  /// id必填，不能缺少(0为自增id)
  int id = 0;

  /// int
  int fieldInt = -1;

  /// double
  double fieldDouble = 1.0;

  /// String
  String fieldString = '';

  /// 时间字段
  @Property(type: PropertyType.date)
  DateTime fieldDateTime = DateTime.now();

  /// 一对一关系(通过实现get/set或构造入参的方式更新或取出对象)
  final dbFieldExample2 = ToOne<DBExampleEntity2>();

  @Transient()
  DBExampleEntity2? get fieldExample2 => dbFieldExample2.target;

  @Transient()
  set fieldExample2(DBExampleEntity2? v) => dbFieldExample2.target = v;

  /// 一对多关系(通过实现get/set或构造入参的方式更新或取出对象)
  final dbFieldExample2List = ToMany<DBExampleEntity2>();

  @Transient()
  List<DBExampleEntity2> get fieldExample2List => dbFieldExample2List.toList();

  @Transient()
  set fieldExample2List(List<DBExampleEntity2> v) =>
      dbFieldExample2List.addAll(v);

  /// 如有枚举等特殊字段，需要转换使用
  @Transient()
  EnumExample fieldEnum = EnumExample.field1;

  /// 特殊字段存入数据库(无需手动调用)
  set dbFieldEnum(int v) => fieldEnum = EnumExample.values[v];

  /// 特殊字段从数据库取出(无需手动调用)
  int get dbFieldEnum => fieldEnum.index;

  /// 其他 get/set 方法必须添加 @Transient() 注解，否则会被写入到数据库
  @Transient()
  String get fieldGet => fieldString;

  @Transient()
  set fieldSet(String v) => fieldString = v;

  /// 其他基础类型依次类推，详情可查询objectbox文档{https://docs.objectbox.io/entity-annotations}

  DBExampleEntity();
}

/// 枚举等特殊类型需要转换
enum EnumExample { field1, field2 }

@Entity()
class DBExampleEntity2 {
  int id = 0;

  DBExampleEntity2();
}

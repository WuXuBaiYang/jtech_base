/*
* 基本数据模型
* @author wuxubaiyang
* @Time 2024/8/14 14:00
*/
abstract class BaseModel {
  BaseModel();

  BaseModel.from(obj);

  Map<String, dynamic> to() => {};
}

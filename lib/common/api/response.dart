/*
* 封装接口响应数据结构
* @author wuxubaiyang
* @Time 2024/4/28 10:00
*/
class ResponseModel<T> {
  final int code;
  final String message;
  final T data;

  ResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  ResponseModel.from(dynamic obj)
      : code = obj['code'] ?? 0,
        message = obj['message'] ?? '',
        data = obj['data'] as T;

  // 判断是否成功
  bool get isSuccess => code == 0;
}

import 'package:jtech_base/jtech_base.dart';
import 'package:${jtech_base_project_name}$/common/common.dart';

/*
* 自定义API接口类
* @author wuxubaiyang
* @Time 2024/10/23 10:03
*/
class CustomAPI extends BaseAPI {
  CustomAPI({
    required super.baseUrl,
    super.interceptors,
    super.connectTimeout,
    super.receiveTimeout,
    super.sendTimeout,
    super.maxRedirects,
    super.parameters,
    super.headers,
  });

  // get请求
  Future<T> httpGet<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) => handleRequest<T>(get(path, request: request, cancelToken: cancelToken));

  // post请求
  Future<T> httpPost<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      handleRequest<T>(post(path, request: request, cancelToken: cancelToken));

  // put请求
  Future<T> httpPut<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) => handleRequest<T>(put(path, request: request, cancelToken: cancelToken));

  // delete请求
  Future<T> httpDelete<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) => handleRequest<T>(
    delete(path, request: request, cancelToken: cancelToken),
  );

  // 处理http请求
  Future<T> handleRequest<T>(Future<Response> request) async {
    final resp = await request;
    final result = ResponseModel<T>.from(resp.data);
    if (!result.isSuccess) throw APIException(result);
    return result.data;
  }
}

/*
* 接口入口
* @author wuxubaiyang
* @Time 2023/5/29 16:15
*/
class API extends CustomAPI {
  static final API _instance = API._internal();

  factory API() => _instance;

  API._internal() : super(baseUrl: Common.baseUrl);
}

// 全局单例入口
final api = API();

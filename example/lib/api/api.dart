import 'package:jtech_base/jtech_base.dart';
import 'package:example/common/common.dart';

/*
* 自定义API接口类，可在此处实现请求与响应的统一处理
* 如果存在多个服务器，可以实现多个CustomAPI，分别命名
* 本结构的意义在于合理化管理接口请求，统一处理请求与响应
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
  }) =>
      handleRequest<T>(get(
        path,
        request: request,
        cancelToken: cancelToken,
      ));

  // post请求
  Future<T> httpPost<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      handleRequest<T>(post(
        path,
        request: request,
        cancelToken: cancelToken,
      ));

  // put请求
  Future<T> httpPut<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      handleRequest<T>(put(
        path,
        request: request,
        cancelToken: cancelToken,
      ));

  // delete请求
  Future<T> httpDelete<T>(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      handleRequest<T>(delete(
        path,
        request: request,
        cancelToken: cancelToken,
      ));

  // 处理http请求
  Future<T> handleRequest<T>(Future<Response> request) async {
    /// TODO 此处可以处理请求结果，自行判断业务逻辑，并按需返回数据
    /// 上方的所有http方法都可以修改为自定义方法，以实现更多的业务
    final resp = await request;

    /// 该方法仅为范例，如需自定义处理，请自行修改
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

  API._internal()
      : super(baseUrl: Common.baseUrl, interceptors: [
          exampleInterceptor,
        ]);

  /// 自定义拦截器，可用于添加请求头、处理请求结果（例如401拦截等）
  static final exampleInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      /// TODO 请求拦截，可以添加请求头部字段
      return handler.next(options);
    },
    onResponse: (resp, handler) {
      /// TODO 响应拦截，可以处理请求结果
      return handler.next(resp);
    },
  );
}

// 全局单例入口
final api = API();

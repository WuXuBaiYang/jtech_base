import 'package:dio/dio.dart';
import 'request.dart';
import 'response.dart';

/*
* 接口方法基类
* @author wuxubaiyang
* @Time 2022/3/29 15:05
*/
abstract class BaseAPI {
  // 网路请求库
  final Dio _dio;

  BaseAPI({
    required String baseUrl,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    int? maxRedirects,
    List<Interceptor> interceptors = const [],
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            queryParameters: parameters,
            headers: headers,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeout,
            maxRedirects: maxRedirects,
          ),
        )..interceptors.addAll([...interceptors]);

  // 更新基础地址
  void updateBaseUrl(String baseUrl) => _dio.options.baseUrl = baseUrl;

  // 添加拦截器
  void addInterceptors(List<Interceptor> interceptors) =>
      _dio.interceptors.addAll(interceptors);

  // 附件下载
  Future<Response> download(
    String path, {
    required String savePath,
    Options? options,
    RequestModel? request,
    String method = 'GET',
    CancelToken? cancelToken,
    bool deleteOnError = true,
    ProgressCallback? onReceiveProgress,
    String lengthHeader = Headers.contentLengthHeader,
  }) =>
      _dio.download(
        path,
        savePath,
        data: request?.data,
        cancelToken: cancelToken,
        lengthHeader: lengthHeader,
        deleteOnError: deleteOnError,
        options: (options ?? Options())
          ..method ??= method
          ..headers ??= request?.headers,
        queryParameters: request?.parameters,
        onReceiveProgress: onReceiveProgress,
      );

  // 基本请求方法
  Future<Response> _req(
    String path, {
    Options? options,
    RequestModel? request,
    String method = 'GET',
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _dio.request(
        path,
        data: request?.data,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: (options ?? Options())
          ..method ??= method
          ..headers ??= request?.headers,
        queryParameters: request?.parameters,
        onReceiveProgress: onReceiveProgress,
      );

  // http-get请求
  Future<Response> get(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      _req(
        path,
        method: 'GET',
        request: request,
        cancelToken: cancelToken,
      );

  // http-post请求
  Future<Response> post(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      _req(
        path,
        method: 'POST',
        request: request,
        cancelToken: cancelToken,
      );

  // http-put请求
  Future<Response> put(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      _req(
        path,
        method: 'PUT',
        request: request,
        cancelToken: cancelToken,
      );

  // http-delete请求
  Future<Response> delete(
    String path, {
    RequestModel? request,
    CancelToken? cancelToken,
  }) =>
      _req(
        path,
        method: 'DELETE',
        request: request,
        cancelToken: cancelToken,
      );
}

/*
* api自定义异常
* @author wuxubaiyang
* @Time 2024/4/28 10:08
*/
class APIException implements Exception {
  final int code;
  final String message;

  APIException(ResponseModel model)
      : code = model.code,
        message = model.message;
}

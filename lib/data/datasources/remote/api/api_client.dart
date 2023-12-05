import 'dart:developer';

import 'package:dio/dio.dart';
import 'auth_manager.dart';
import 'response/error/api_response_error.dart';

class AuthClient extends _BaseClient {
  final AuthManager _authManager;

  AuthClient({required AuthManager authManager}) : _authManager = authManager;

  @override
  Future<Map<String, dynamic>> get _defaultHeaders async => {
        "Authorization": await _authManager.authHeader,
      };
}

class UnAuthClient extends _BaseClient {
  UnAuthClient();
}

abstract class _BaseClient {
  final Dio _dio;

  _BaseClient() : _dio = Dio();

  Future<Map<String, dynamic>?> get _defaultHeaders async => null;

  Future<Map<String, dynamic>> _appendDefaultHeader({
    Map<String, dynamic>? customHeaders,
  }) async =>
      {
        ...?customHeaders,
        ...?(await _defaultHeaders),
      };

  Future<dynamic> get(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String contentType = Headers.jsonContentType,
    Map<String, dynamic>? customHeaders,
    int retryCount = 0,
  }) async {
    final headers = await _appendDefaultHeader(customHeaders: customHeaders);

    return await _request(
      url,
      data: data,
      queryParameters: queryParameters,
      method: _HttpMethod.get,
      contentType: contentType,
      customHeaders: headers,
    );
  }

  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String contentType = Headers.jsonContentType,
    Map<String, dynamic>? customHeaders,
  }) async {
    final headers = await _appendDefaultHeader(customHeaders: customHeaders);

    return await _request(
      url,
      method: _HttpMethod.post,
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
      customHeaders: headers,
    );
  }

  Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String contentType = Headers.jsonContentType,
    Map<String, dynamic>? customHeaders,
  }) async {
    final headers = await _appendDefaultHeader(customHeaders: customHeaders);

    return await _request(
      url,
      method: _HttpMethod.put,
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
      customHeaders: headers,
    );
  }

  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String contentType = Headers.jsonContentType,
    Map<String, dynamic>? customHeaders,
  }) async {
    final headers = await _appendDefaultHeader(customHeaders: customHeaders);

    return await _request(
      url,
      method: _HttpMethod.delete,
      data: data,
      queryParameters: queryParameters,
      contentType: contentType,
      customHeaders: headers,
    );
  }

  Future<dynamic> _request(
    String url, {
    required _HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String contentType = Headers.jsonContentType,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      final options = Options(
        contentType: contentType,
        headers: customHeaders,
      );
      final result = await _executeRequest(
        url,
        method: method,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return result;
    } on DioException catch (error) {
      log(error.toString());

      final responseErrorMap = error.response?.data['error'];

      final responseError = APIResponseError.fromJson(responseErrorMap);

      throw responseError;
    } catch (_) {
      rethrow;
    }
  }

  Future<dynamic> _executeRequest(
    String url, {
    required _HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    switch (method) {
      case _HttpMethod.get:
        return _dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      case _HttpMethod.post:
        return _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      case _HttpMethod.put:
        return _dio.put(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      case _HttpMethod.delete:
        return _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
    }
  }
}

enum _HttpMethod {
  get,
  post,
  put,
  delete,
}

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../env.dart';
import 'api_result.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;

  Dio get dio => _dio;

  ApiClient({required this.baseUrl}) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 45),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(AuthInterceptor());
    AppEnviro.enviroment == Enviroment.dev || kDebugMode
        ? _dio.interceptors.add(
            CurlLoggingInterceptor(
              showRequestLog: kDebugMode,
              showResponseLog: kDebugMode,
            ),
          )
        : null;
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (certificate, host, port) => true;
      return client;
    };
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.get(path, queryParameters: query, options: options),
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _request<T>(
      () =>
          _dio.post(path, data: data, queryParameters: query, options: options),
    );
  }

  //post with file
  Future<ApiResponse<T>> postWithFile<T>(
    String path, {
    File? file,
    String? fileField,
    String customMethod = 'POST',
    Map<String, dynamic>? formFields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);

      var request = http.MultipartRequest(customMethod, uri);

      if (headers != null) {
        request.headers.addAll(headers);
      } else {
        request.headers.addAll({
          'Accept': 'application/json',
        });
      }
      Map<String, dynamic>? filteredFields = formFields;
      if (file == null && fileField == 'photo' && formFields != null) {
        filteredFields = Map<String, dynamic>.from(formFields);
        filteredFields.remove('photo');
      }

      if (filteredFields != null) {
        request.fields
            .addAll(filteredFields.map((k, v) => MapEntry(k, v.toString())));
      }

      if (file != null && fileField != null) {
        // Determine MIME type based on file extension
        String mimeType = 'image/jpeg'; // default
        final extension = file.path.toLowerCase();
        if (extension.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (extension.endsWith('.jpg') || extension.endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        } else if (extension.endsWith('.gif')) {
          mimeType = 'image/gif';
        } else if (extension.endsWith('.webp')) {
          mimeType = 'image/webp';
        }

        request.files.add(await http.MultipartFile.fromPath(
          fileField,
          file.path,
          contentType: MediaType.parse(mimeType),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      return ApiResponse<T>(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _request<T>(
      () =>
          _dio.put(path, data: data, queryParameters: query, options: options),
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: options,
      ),
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: query,
        options: options,
      ),
    );
  }

  //stream
  Future<Response> stream(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return Response(
          statusCode: null,
          statusMessage: 'Request cancelled',
          requestOptions: e.requestOptions,
        );
      }
      return Response(
        statusCode: e.response?.statusCode,
        statusMessage: e.message,
        requestOptions: e.requestOptions,
      );
    } catch (e) {
      return Response(
        statusCode: 500,
        statusMessage: 'Unexpected error occurred',
        requestOptions: RequestOptions(path: path),
      );
    }
  }

  Future<ApiResponse<T>> _request<T>(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      log('Request successful: ${response.statusCode}',
          name: 'ApiClient._request');
      return ApiResponse<T>.fromDioResponse(response);
    } on DioException catch (e) {
      log('DioException: ${e.type}, Message: ${e.message}, Response: ${e.response?.statusCode}',
          name: 'ApiClient._request');
      return ApiResponse<T>.fromDioError(e);
    } catch (e) {
      log('Unexpected error: $e', name: 'ApiClient._request');
      return ApiResponse<T>(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }
}

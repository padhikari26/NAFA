import 'package:dio/dio.dart';
import 'package:nafausa/core/controller/bloc/global/global_bloc.dart';

import '../../../shared/services/database/shared_pref.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final customToken = options.headers['X-Custom-Token'];
    if (customToken != null && customToken is String) {
      options.headers['Authorization'] = 'Bearer $customToken';
      options.headers.remove('X-Custom-Token');
    } else {
      final storedToken = await SharedPref.accessToken;
      if (storedToken != null && storedToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $storedToken';
        // options.headers['Authorization'] = 'Bearer ""';
      }
    }
    options.headers["ChannelPlatform"] = "mobileapp";
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _logout();
      return handler.next(err);
    }
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }
  }

  Future<void> _logout() async {
    globalBloc.add(const GlobalAuthLogoutEvent());
  }
}

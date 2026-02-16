import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nafausa/features/auth/models/register_request_model.dart';

import '../../../app/utils/dependencies.dart';
import '../../../features/events/controller/bloc/events_bloc.dart';
import '../../../shared/services/database/shared_pref.dart';
import '../api/api_client.dart';
import '../api/api_constant.dart';
import '../api/api_result.dart';

class ApiRequest {
  final ApiClient _apiClient = getIt<ApiClient>();
  // final NetworkInfo _networkInfo = getIt<NetworkInfo>();

  Future<Map<String, String>> _defaultHeaders({String? contentType}) async {
    final token = await SharedPref.accessToken;
    return {
      HttpHeaders.contentTypeHeader: contentType ?? 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      if (token != null && token.isNotEmpty)
        HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  Future<Map<String, String>> _mergeHeaders({
    String? contentType,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _defaultHeaders(contentType: contentType);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  // Future<bool> _isNetworkConnected() async {
  //   final isConnected = await _networkInfo.isConnected;
  //   if (!isConnected) {
  //     throw NetworkException.getMessage(
  //       SocketException('No internet connection'),
  //     );
  //   }
  //   return true;
  // }

  //register
  Future<ApiResponse> register({
    File? file,
    required RegisterRequestModel data,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final response = await _apiClient.postWithFile(
        file: file,
        APIPathHelper.authAPIs(APIPath.register),
        fileField: "photo",
        formFields: data.toJson(),
      );
      // : await _apiClient.post(
      //     APIPathHelper.authAPIs(APIPath.register),
      //     data: data.toJson(),
      //     options: Options(
      //       headers:
      //           await _mergeHeaders(additionalHeaders: additionalHeaders),
      //     ),
      //   );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.register');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //login
  Future<ApiResponse> login({
    required Map<String, dynamic> data,
    Map<String, String>? additionalHeaders,
  }) async {
    final response = await _apiClient.post(
      APIPathHelper.authAPIs(APIPath.login),
      data: data,
      options: Options(
        headers: await _mergeHeaders(additionalHeaders: additionalHeaders),
      ),
    );

    if (response.isSuccess) {
      return ApiResponse(data: response.data, statusCode: response.statusCode);
    }
    return response;
  }

  //update profile
  Future<ApiResponse> updateProfile({
    File? file,
    required String id,
    required RegisterRequestModel data,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final response = await _apiClient.postWithFile(
        customMethod: "PUT",
        file: file,
        APIPathHelper.profileAPIs(APIPath.updateProfile, id: id),
        fileField: "photo",
        formFields: data.toJson(),
        headers: await _mergeHeaders(
          additionalHeaders: additionalHeaders,
        ),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.updateProfile');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch profile
  Future<ApiResponse> fetchProfile() async {
    try {
      final response = await _apiClient.get(
        APIPathHelper.profileAPIs(APIPath.profile),
      );
      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchProfile');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch featured events
  Future<ApiResponse> fetchFeaturedEvents() async {
    try {
      final response = await _apiClient.get(
        APIPathHelper.eventAPIs(APIPath.featuredEvent),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchFeaturedEvents');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch all events
  Future<ApiResponse> fetchAllEvents({
    DataFilter? filters,
  }) async {
    try {
      final response = await _apiClient.post(
        APIPathHelper.eventAPIs(APIPath.events),
        data: filters?.toJson(),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchAllEvents');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch event by id
  Future<ApiResponse> fetchEventById(String eventId) async {
    try {
      final response = await _apiClient.get(
        APIPathHelper.eventAPIs(APIPath.eventsById, id: eventId),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchEventById');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch all gallery
  Future<ApiResponse> fetchAllGallery({
    DataFilter? filters,
  }) async {
    try {
      final response = await _apiClient.post(
        APIPathHelper.galleryAPIs(APIPath.gallery),
        data: filters?.toJson(),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchAllGallery');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch gallery by id
  Future<ApiResponse> fetchGalleryById(String galleryId) async {
    try {
      final response = await _apiClient.get(
        APIPathHelper.galleryAPIs(APIPath.galleryById, id: galleryId),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchGalleryById');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch teams
  Future<ApiResponse> fetchTeams() async {
    try {
      final response = await _apiClient.get(
        APIPathHelper.teamsAPIs(APIPath.teams),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchTeams');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  //fetch all notification
  Future<ApiResponse> fetchAllNotifications({
    DataFilter? filters,
  }) async {
    try {
      final response = await _apiClient.post(
        APIPathHelper.notificationAPIs(APIPath.notification),
        data: filters?.toJson(),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchAllNotifications');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }

  // get bannerpopup
  Future<ApiResponse> fetchBannerPopup() async {
    try {
      final response = await _apiClient.get(
        APIPathHelper.eventAPIs(APIPath.popup),
      );

      if (response.isSuccess) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      }
      return response;
    } catch (e) {
      log(e.toString(), name: 'ApiRequest.fetchBannerPopup');
      return ApiResponse(
        message: 'Unexpected error occurred',
        errors: [e.toString()],
      );
    }
  }
}

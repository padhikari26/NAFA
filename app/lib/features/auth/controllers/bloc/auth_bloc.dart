import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafausa/features/auth/models/login_response_model.dart';

import '../../../../app/utils/constants.dart';
import '../../../../app/utils/toast.dart';
import '../../../../core/controller/bloc/connectivity/connectivity_bloc.dart';
import '../../../../core/controller/bloc/global/global_bloc.dart';
import '../../../../core/network/api_request/api_request.dart';
import '../../../../shared/services/database/db/db_data.dart';
import '../../models/register_request_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

mixin NetworkEventTransformer<Event, State> on Bloc<Event, State> {
  EventTransformer<E> networkCheckTransformer<E>() {
    return (events, mapper) {
      return events.asyncExpand((event) async* {
        networkBloc.add(const CheckConnectivity());
        await Future.delayed(const Duration(milliseconds: 100));
        if (networkBloc.state.isConnected) {
          yield* mapper(event);
        }
      });
    };
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with NetworkEventTransformer<AuthEvent, AuthState> {
  final ApiRequest _apiRequest;
  Timer? _timer;

  AuthBloc({
    ApiRequest? apiRequest,
    Connectivity? connectivity,
  })  : _apiRequest = apiRequest ?? ApiRequest(),
        super(AuthState.initial()) {
    on<LoginInitialEvent>(_handleInitialState);
    on<LoginSubmitEvent>(
      _handleLoginApi,
      transformer: networkCheckTransformer(),
    );
    on<LoginFailureEvent>(_handleLoginFailure);
    on<ChangeState>((event, emit) {
      emit(event.newState);
    });
    on<UpdateProfileEvent>(_handleUpdateProfile);
    on<FetchProfileEvent>(_handleFetchProfile);
  }

  Future<void> _handleFetchProfile(
    FetchProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _apiRequest.fetchProfile();
      if (!response.isSuccess) {
        return;
      }
      final res = UserData.fromJson(response.data);
      await DbLocalData.updateUserInfo(userInfo: res);
      globalBloc.add(GetUserEvent());
    } catch (e) {
      add(const LoginFailureEvent('Something went wrong'));
    }
  }

  void _handleLoginFailure(LoginFailureEvent event, Emitter<AuthState> emit) {
    showFailureToast(message: event.errorMessage);
    emit(
      state.copyWith(
        errorMessage:
            event.errorMessage?.contains("invalid-credential") ?? false
                ? 'Invalid username or password'
                : event.errorMessage,
        isLoading: false,
      ),
    );
  }

  void _handleInitialState(LoginInitialEvent event, Emitter<AuthState> emit) {
    emit(AuthState.initial());
  }

  Future<void> _handleLoginApi(
    LoginSubmitEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final res = await _apiRequest.login(
      data: {
        'loginCode': event.loginCode.trim(),
        'name': event.name.trim(),
        'phone': event.phone.trim(),
        'city': event.city.trim(),
      },
    );
    if (!res.isSuccess) {
      add(LoginFailureEvent(res.formattedErrorMessage));
      return;
    }
    final response = LoginModel.fromJson(res.data);

    await DbLocalData.updateUserInfo(
      loginResponse: response,
      userInfo: response.user ?? UserData(),
    );
    globalBloc
        .add(const GlobalAuthSetEvent(authState: LoginState.authenticate));
    add(const LoginInitialEvent());
  }

  Future<void> _handleUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final response = await _apiRequest.updateProfile(
        id: event.id,
        data: event.data,
        file: event.photo,
      );
      if (!response.isSuccess) {
        add(LoginFailureEvent(response.formattedErrorMessage));
        return;
      }
      log('Profile updated successfully: ${response.data}');
      final res = LoginModel.fromJson(response.data);
      await DbLocalData.updateUserInfo(
        userInfo: res.user ?? UserData(),
      );
      globalBloc.add(GetUserEvent());
      Navigator.popUntil(cusCtx!, (route) => route.isFirst);
      showSuccessDiaglog(
        title: 'Profile Updated Successfully',
        onOk: () {
          Navigator.popUntil(cusCtx!, (route) => route.isFirst);
        },
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      log('Error updating profile: $e');
      add(const LoginFailureEvent('Something went wrong'));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafausa/app/utils/constants.dart';
import 'package:nafausa/features/auth/models/login_response_model.dart';
import '../../../../shared/services/database/db/db_data.dart';
import '../../../../shared/services/database/shared_pref.dart';
part 'global_event.dart';
part 'global_state.dart';

late GlobalBloc globalBloc;

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  late final StreamSubscription _connectivitySub;

  GlobalBloc() : super(GlobalState.initial()) {
    globalBloc = this;
    on<GlobalEventChangeTheme>(_handleThemeChange);
    on<GlobalEventInit>(_handleInit);
    on<GlobalAuthGetEvent>(_handleAuthGet);
    on<GlobalAuthSetEvent>(_handleAuthSet);
    on<GetUserEvent>(_handleUpdateUser);
    on<GlobalAuthLogoutEvent>(_handleAuthLogout);
  }

  void _handleAuthLogout(
    GlobalAuthLogoutEvent event,
    Emitter<GlobalState> emit,
  ) async {
    Navigator.popUntil(
      cusCtx!,
      (route) => route.isFirst,
    );
    SharedPref.clearAll;
    add(const GlobalAuthSetEvent(authState: LoginState.unauthenticate));
    add(const GlobalAuthGetEvent());
  }

  void _handleUpdateUser(
    GetUserEvent event,
    Emitter<GlobalState> emit,
  ) async {
    final user = await DbLocalData.getUserInfo();
    emit(state.copyWith(user: user));
  }

  void _handleThemeChange(
    GlobalEventChangeTheme event,
    Emitter<GlobalState> emit,
  ) {
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }

  void _handleInit(GlobalEventInit event, Emitter<GlobalState> emit) {
    emit(GlobalState.initial());
  }

  Future<void> _handleAuthGet(
    GlobalAuthGetEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(state.copyWith(authState: LoginState.authenticating));
    final isAuth = await SharedPref.isAuth;
    emit(
      state.copyWith(
        isLoggedIn: isAuth,
        authState: isAuth
            ? LoginState.authenticate
            // : isOnboarding
            // ? LoginState.initial
            : LoginState.unauthenticate,
      ),
    );
    if (isAuth == false) {
      SharedPref.clear;
    } else {
      add(GetUserEvent());
    }
  }

  Future<void> _handleAuthSet(
    GlobalAuthSetEvent event,
    Emitter<GlobalState> emit,
  ) async {
    SharedPref.setAuth = (event.authState == LoginState.authenticate);
    emit(state.copyWith(
        authState: event.authState,
        isLoggedIn: event.authState == LoginState.authenticate));

    if (event.authState == LoginState.authenticate) {
      add(GetUserEvent());
    }
  }

  @override
  void onEvent(GlobalEvent event) {
    super.onEvent(event);
  }

  @override
  void onChange(Change<GlobalState> change) {
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    _connectivitySub.cancel();
    return super.close();
  }
}

enum LoginState {
  initial,
  authenticating,
  authenticate,
  unauthenticate,
  unRegistered,
  deactivated,
  biometric,
}

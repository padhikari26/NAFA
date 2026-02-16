import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/features/notification/model/notification_model.dart';

import '../../../../app/utils/dependencies.dart';
import '../../../../app/utils/pagination_helper.dart';
import '../../../../app/utils/toast.dart';
import '../../../../core/network/api_request/api_request.dart';
import '../../../auth/controllers/bloc/auth_bloc.dart';
import '../../../events/controller/bloc/events_bloc.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>
    with NetworkEventTransformer<NotificationEvent, NotificationState> {
  final ApiRequest apiRequest = getIt<ApiRequest>();
  NotificationBloc() : super(NotificationState.initial()) {
    on<NotificationInitialEvent>(_handleInitialEvent);
    on<FetchAllNotificationEvent>(_handleFetchAllNotification);
    on<RefreshNotificationEvent>(_onRefreshNotification);
  }

  void _handleInitialEvent(
      NotificationInitialEvent event, Emitter<NotificationState> emit) {
    emit(NotificationState.initial());
  }

  void _onRefreshNotification(
      RefreshNotificationEvent event, Emitter<NotificationState> emit) {
    state.searchController.clear();
    emit(state.copyWith(
      notifications: [],
      currentPage: 1,
      hasReachedEnd: false,
      paginationStatus: PaginationStatus.initial,
    ));
    add(const FetchAllNotificationEvent(page: 1, isInitial: true));
  }

  Future<void> _handleFetchAllNotification(
      FetchAllNotificationEvent event, Emitter<NotificationState> emit) async {
    if (PaginationHelper.shouldSkipFetch(
      requestedPage: event.page,
      currentPage: state.currentPage,
      hasReachedEnd: event.isInitial ? false : state.hasReachedEnd,
      paginationStatus: state.paginationStatus,
    )) {
      return;
    }

    if (event.isInitial) {
      emit(state.copyWith(isLoading: true, notifications: []));
    } else {
      emit(state.copyWith(paginationStatus: PaginationStatus.loading));
    }

    try {
      final response = await apiRequest.fetchAllNotifications(
        filters: DataFilter(
          page: event.page,
          limit: 12,
          search: state.searchController.text,
        ),
      );

      if (!response.isSuccess) {
        showFailureToast(message: response.formattedErrorMessage);
        emit(state.copyWith(
          isLoading: false,
          paginationStatus: PaginationStatus.failure,
        ));
        return;
      }

      final newModel = NotificationModel.fromJson(response.data);

      if (newModel.data.isNullOrEmpty) {
        emit(state.copyWith(
          isLoading: false,
          paginationStatus: PaginationStatus.success,
          hasReachedEnd: true,
        ));
        return;
      }
      final updatedState = PaginationHelper.updateStateAfterFetch<
          NotificationState, NotificationData>(
        state: state,
        newData: newModel.data ?? [],
        requestedPage: event.page,
        hasNext: newModel.next ?? false,
        isSame: (a, b) => a.sId == b.sId,
        getExistingData: (s) => s.notifications,
        copyWithState: (s, mergedData, hasReachedEnd, currentPage) =>
            s.copyWith(
          notifications: mergedData,
          hasReachedEnd: hasReachedEnd,
          currentPage: currentPage,
          paginationStatus: PaginationStatus.success,
        ),
      );

      emit(updatedState.copyWith(isLoading: false));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        paginationStatus: PaginationStatus.failure,
      ));
    }
  }
}

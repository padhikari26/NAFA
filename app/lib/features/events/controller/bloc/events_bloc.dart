import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/features/events/model/all_events_model.dart';
import 'package:nafausa/features/events/model/single_event_model.dart';
import '../../../../app/utils/dependencies.dart';
import '../../../../app/utils/pagination_helper.dart';
import '../../../../core/network/api_request/api_request.dart';
import '../../../auth/controllers/bloc/auth_bloc.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState>
    with NetworkEventTransformer<EventsEvent, EventsState> {
  final ApiRequest apiRequest = getIt<ApiRequest>();

  EventsBloc() : super(EventsState.initial()) {
    on<EventsInitialEvent>(_onInitial);
    on<FetchEventsEvent>(_onFetchEvents,
        transformer: networkCheckTransformer());
    on<RefreshEventsEvent>(_onRefreshEvents);
    on<FetchEventByIdEvent>(_onFetchEventById,
        transformer: networkCheckTransformer());
    on<ClearEventDetail>(_onClearEventDetail);
    on<ChangeFilterTypeEvent>(_onChangeFilterType);
  }
  void _onInitial(EventsInitialEvent event, Emitter<EventsState> emit) {
    emit(EventsState.initial());
  }

  Future<void> _onFetchEvents(
      FetchEventsEvent event, Emitter<EventsState> emit) async {
    if (PaginationHelper.shouldSkipFetch(
      requestedPage: event.page,
      currentPage: state.currentPage,
      hasReachedEnd: event.isInitial ? false : state.hasReachedEnd,
      paginationStatus: state.paginationStatus,
    )) {
      return;
    }

    if (event.isInitial) {
      emit(
          state.copyWith(isEventLoading: true, allEventModel: AllEventModel()));
    } else {
      emit(state.copyWith(paginationStatus: PaginationStatus.loading));
    }

    final filters = DataFilter(
      page: event.page,
      limit: 12,
      search: state.searchController.text,
      isUpcoming: _mapFilterTypeToUpcoming(state.currentFilter),
    );

    try {
      final response = await apiRequest.fetchAllEvents(filters: filters);

      if (!response.isSuccess) {
        emit(state.copyWith(
            isEventLoading: false, paginationStatus: PaginationStatus.failure));
        return;
      }

      final newModel = AllEventModel.fromJson(response.data);
      if (newModel.data.isNullOrEmpty) {
        emit(state.copyWith(
          isEventLoading: false,
          paginationStatus: PaginationStatus.success,
          hasReachedEnd: true,
        ));
        return;
      }
      final updatedState =
          PaginationHelper.updateStateAfterFetch<EventsState, AllEventData>(
        state: state,
        newData: newModel.data ?? [],
        requestedPage: event.page,
        hasNext: newModel.next ?? false,
        isSame: (a, b) => a.sId == b.sId,
        getExistingData: (s) => s.allEventModel?.data ?? [],
        copyWithState: (s, mergedData, hasReachedEnd, currentPage) =>
            s.copyWith(
          allEventModel: AllEventModel(data: mergedData, next: !hasReachedEnd),
          hasReachedEnd: hasReachedEnd,
          currentPage: currentPage,
          paginationStatus: PaginationStatus.success,
        ),
      );

      emit(updatedState.copyWith(isEventLoading: false));
    } catch (_) {
      emit(state.copyWith(
          isEventLoading: false, paginationStatus: PaginationStatus.failure));
    }
  }

  void _onRefreshEvents(RefreshEventsEvent event, Emitter<EventsState> emit) {
    state.searchController.clear();
    emit(state.copyWith(
      allEventModel: AllEventModel(),
      currentPage: 1,
      hasReachedEnd: false,
      currentFilter: FilterType.all,
      paginationStatus: PaginationStatus.initial,
    ));
    add(const FetchEventsEvent(page: 1, isInitial: true));
  }

  Future<void> _onFetchEventById(
      FetchEventByIdEvent event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isEventDetailLoading: true));
    try {
      final response = await apiRequest.fetchEventById(event.eventId);
      if (response.isSuccess) {
        emit(state.copyWith(
          eventDetail: SingleEventModel.fromJson(response.data),
        ));
      }
    } catch (_) {
    } finally {
      emit(state.copyWith(isEventDetailLoading: false));
    }
  }

  void _onClearEventDetail(ClearEventDetail event, Emitter<EventsState> emit) {
    emit(state.copyWith(eventDetail: SingleEventModel()));
  }

  void _onChangeFilterType(
      ChangeFilterTypeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(
        currentFilter: event.filterType,
        isEventLoading: true,
        allEventModel: AllEventModel()));
    Helper.debouncedSearch(
      fn: (searchTerm) async {
        add(const FetchEventsEvent(
          page: 1,
          isInitial: true,
        ));
      },
      value: state.searchController.text,
      key: 'event_filter',
    );
  }

  bool? _mapFilterTypeToUpcoming(FilterType filterType) {
    final mapping = {
      FilterType.upcoming: true,
      FilterType.past: false,
      FilterType.all: null,
    };
    return mapping[filterType];
  }
}

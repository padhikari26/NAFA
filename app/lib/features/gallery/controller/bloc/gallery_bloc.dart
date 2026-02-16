import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/toast.dart';

import '../../../../app/utils/dependencies.dart';
import '../../../../app/utils/pagination_helper.dart';
import '../../../../core/network/api_request/api_request.dart';
import '../../../auth/controllers/bloc/auth_bloc.dart';
import '../../../events/controller/bloc/events_bloc.dart';
import '../../model/all_gallery_model.dart';
import '../../model/gallery_detail_model.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState>
    with NetworkEventTransformer<GalleryEvent, GalleryState> {
  final ApiRequest apiRequest = getIt<ApiRequest>();

  GalleryBloc() : super(GalleryState.initial()) {
    on<GalleryInitialEvent>(_handleGalleryInitialEvent);
    on<FetchAllGalleryEvent>(_handleFetchAllGalleryEvent);
    on<RefreshGalleryEvent>(_onRefreshGallery);
    on<FetchGalleryDetailEvent>(_handleFetchGalleryDetailEvent);
    on<ClearGalleryDetailEvent>(_handleClearGalleryDetailEvent);
  }

  void _handleGalleryInitialEvent(
      GalleryInitialEvent event, Emitter<GalleryState> emit) {
    emit(GalleryState.initial());
  }

  void _handleClearGalleryDetailEvent(
      ClearGalleryDetailEvent event, Emitter<GalleryState> emit) {
    emit(state.copyWith(galleryDetail: GalleryDetailModel()));
  }

  void _onRefreshGallery(
      RefreshGalleryEvent event, Emitter<GalleryState> emit) {
    state.searchController.clear();
    emit(state.copyWith(
      galleries: [],
      currentPage: 1,
      hasReachedEnd: false,
      paginationStatus: PaginationStatus.initial,
    ));
    add(const FetchAllGalleryEvent(page: 1, isInitial: true));
  }

  Future<void> _handleFetchAllGalleryEvent(
      FetchAllGalleryEvent event, Emitter<GalleryState> emit) async {
    if (PaginationHelper.shouldSkipFetch(
      requestedPage: event.page,
      currentPage: state.currentPage,
      hasReachedEnd: event.isInitial ? false : state.hasReachedEnd,
      paginationStatus: state.paginationStatus,
    )) {
      return;
    }

    if (event.isInitial) {
      emit(state.copyWith(allGalleryLoading: true, galleries: []));
    } else {
      emit(state.copyWith(paginationStatus: PaginationStatus.loading));
    }

    try {
      final response = await apiRequest.fetchAllGallery(
        filters: DataFilter(
          page: event.page,
          limit: 12,
          search: state.searchController.text,
        ),
      );

      if (!response.isSuccess) {
        showFailureToast(message: response.formattedErrorMessage);
        emit(state.copyWith(
          allGalleryLoading: false,
          paginationStatus: PaginationStatus.failure,
        ));
        return;
      }

      final newModel = AllGalleryModel.fromJson(response.data);

      if (newModel.data.isNullOrEmpty) {
        emit(state.copyWith(
          allGalleryLoading: false,
          paginationStatus: PaginationStatus.success,
          hasReachedEnd: true,
        ));
        return;
      }
      final updatedState =
          PaginationHelper.updateStateAfterFetch<GalleryState, AllGalleryData>(
        state: state,
        newData: newModel.data ?? [],
        requestedPage: event.page,
        hasNext: newModel.next ?? false,
        isSame: (a, b) => a.sId == b.sId,
        getExistingData: (s) => s.galleries,
        copyWithState: (s, mergedData, hasReachedEnd, currentPage) =>
            s.copyWith(
          galleries: mergedData,
          hasReachedEnd: hasReachedEnd,
          currentPage: currentPage,
          paginationStatus: PaginationStatus.success,
        ),
      );

      emit(updatedState.copyWith(allGalleryLoading: false));
    } catch (_) {
      emit(state.copyWith(
        allGalleryLoading: false,
        paginationStatus: PaginationStatus.failure,
      ));
    }
  }

  Future<void> _handleFetchGalleryDetailEvent(
      FetchGalleryDetailEvent event, Emitter<GalleryState> emit) async {
    emit(state.copyWith(isGalleryDetailLoading: true));

    try {
      final response = await apiRequest.fetchGalleryById(event.galleryId);
      if (!response.isSuccess) {
        showFailureToast(message: response.formattedErrorMessage);
        emit(state.copyWith(isGalleryDetailLoading: false));
        return;
      }

      final data = GalleryDetailModel.fromJson(response.data);
      emit(state.copyWith(
        isGalleryDetailLoading: false,
        galleryDetail: data,
      ));
    } catch (_) {
      emit(state.copyWith(isGalleryDetailLoading: false));
    }
  }
}

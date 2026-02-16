import 'package:equatable/equatable.dart';

enum PaginationStatus { initial, loading, success, failure }

class PaginationHelper {
  // Check if we should skip fetching more data
  static bool shouldSkipFetch({
    required int requestedPage,
    required int currentPage,
    required bool hasReachedEnd,
    required PaginationStatus paginationStatus,
  }) {
    return hasReachedEnd ||
        paginationStatus == PaginationStatus.loading ||
        (requestedPage > 1 &&
            requestedPage == currentPage &&
            paginationStatus == PaginationStatus.success);
  }

  // Update state after fetching new data
  static S updateStateAfterFetch<S, T>({
    required S state,
    required List<T> newData,
    required int requestedPage,
    required bool hasNext,
    required bool Function(T a, T b) isSame,
    required List<T> Function(S state) getExistingData,
    required S Function(
            S state, List<T> mergedData, bool hasReachedEnd, int currentPage)
        copyWithState,
  }) {
    final existingData = getExistingData(state);
    final existingIds = existingData;

    final mergedData = [
      ...existingData,
      ...newData.where((n) => !existingIds.any((e) => isSame(e, n))),
    ];

    return copyWithState(state, mergedData, !hasNext, requestedPage);
  }
}

abstract class PaginatedState<T> extends Equatable {
  final List<T>? data;
  final bool isLoading;
  final PaginationStatus paginationStatus;
  final bool hasReachedEnd;
  final int currentPage;

  const PaginatedState({
    this.data,
    this.isLoading = false,
    this.paginationStatus = PaginationStatus.initial,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  PaginatedState<T> copyWith({
    List<T>? data,
    bool? isLoading,
    PaginationStatus? paginationStatus,
    bool? hasReachedEnd,
    int? currentPage,
  });

  @override
  List<Object?> get props => [
        data,
        isLoading,
        paginationStatus,
        hasReachedEnd,
        currentPage,
      ];
}

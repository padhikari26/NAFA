part of 'notification_bloc.dart';

class NotificationState {
  final bool isLoading;
  final int currentPage;
  final List<NotificationData> notifications;
  final TextEditingController searchController;
  final bool hasReachedEnd;
  final PaginationStatus paginationStatus;

  NotificationState({
    this.isLoading = false,
    this.currentPage = 1,
    required this.notifications,
    required this.searchController,
    this.hasReachedEnd = false,
    this.paginationStatus = PaginationStatus.initial,
  });

  NotificationState copyWith({
    bool? isLoading,
    TextEditingController? searchController,
    bool? hasReachedEnd,
    PaginationStatus? paginationStatus,
    List<NotificationData>? notifications,
    int? currentPage,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      searchController: searchController ?? this.searchController,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      notifications: notifications ?? this.notifications,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  factory NotificationState.initial() {
    return NotificationState(
      isLoading: true,
      searchController: TextEditingController(),
      hasReachedEnd: false,
      paginationStatus: PaginationStatus.initial,
      notifications: [],
      currentPage: 1,
    );
  }
}

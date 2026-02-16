part of 'events_bloc.dart';

class EventsState {
  final bool isEventLoading;
  final bool isEventDetailLoading;
  final AllEventModel? allEventModel;
  final SingleEventModel? eventDetail;
  final FilterType currentFilter;
  final List<FilterType> filters;
  final TextEditingController searchController;
  final bool hasReachedEnd;
  final int currentPage;
  final PaginationStatus paginationStatus;

  EventsState({
    this.isEventLoading = false,
    this.isEventDetailLoading = false,
    this.allEventModel,
    this.eventDetail,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.paginationStatus = PaginationStatus.initial,
    this.currentFilter = FilterType.all,
    required this.filters,
    required this.searchController,
  });

  EventsState copyWith({
    bool? isEventLoading,
    bool? isEventDetailLoading,
    AllEventModel? allEventModel,
    SingleEventModel? eventDetail,
    FilterType? currentFilter,
    List<FilterType>? filters,
    TextEditingController? searchController,
    bool? hasReachedEnd,
    int? currentPage,
    PaginationStatus? paginationStatus,
  }) {
    return EventsState(
      isEventLoading: isEventLoading ?? this.isEventLoading,
      isEventDetailLoading: isEventDetailLoading ?? this.isEventDetailLoading,
      allEventModel: allEventModel ?? this.allEventModel,
      eventDetail: eventDetail ?? this.eventDetail,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      currentFilter: currentFilter ?? this.currentFilter,
      filters: filters ?? this.filters,
      searchController: searchController ?? this.searchController,
    );
  }

  factory EventsState.initial() {
    return EventsState(
      isEventLoading: true,
      isEventDetailLoading: true,
      allEventModel: AllEventModel(),
      eventDetail: SingleEventModel(),
      hasReachedEnd: false,
      currentPage: 1,
      paginationStatus: PaginationStatus.initial,
      currentFilter: FilterType.all,
      filters: [FilterType.all, FilterType.upcoming, FilterType.past],
      searchController: TextEditingController(),
    );
  }
}

class DataFilter {
  int? page;
  int? limit;
  String? search;
  bool? isUpcoming;

  DataFilter(
      {this.page = 1, this.limit = 10, this.search = '', this.isUpcoming});

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "search": search,
      if (isUpcoming != null) "isUpcoming": isUpcoming
    };
  }

  //copywith
  DataFilter copyWith({
    int? page,
    int? limit,
    String? search,
    bool? isUpcoming,
  }) {
    return DataFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      isUpcoming: isUpcoming ?? this.isUpcoming,
    );
  }

  factory DataFilter.fromJson(Map<String, dynamic> json) {
    return DataFilter(
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
      search: json["search"] ?? '',
      isUpcoming: json["isUpcoming"] ?? false,
    );
  }
}

enum FilterType {
  all,
  upcoming,
  past,
}

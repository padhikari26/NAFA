part of 'gallery_bloc.dart';

class GalleryState {
  final List<AllGalleryData> galleries;
  final int currentPage;
  final bool allGalleryLoading;
  final bool isGalleryDetailLoading;
  final GalleryDetailModel? galleryDetail;
  final TextEditingController searchController;
  final bool hasReachedEnd;
  final PaginationStatus paginationStatus;

  GalleryState({
    this.galleries = const [],
    this.allGalleryLoading = false,
    this.isGalleryDetailLoading = false,
    this.currentPage = 1,
    this.galleryDetail,
    required this.searchController,
    this.hasReachedEnd = false,
    this.paginationStatus = PaginationStatus.initial,
  });

  GalleryState copyWith({
    List<AllGalleryData>? galleries,
    bool? allGalleryLoading,
    bool? isGalleryDetailLoading,
    int? currentPage,
    GalleryDetailModel? galleryDetail,
    TextEditingController? searchController,
    bool? hasReachedEnd,
    PaginationStatus? paginationStatus,
  }) {
    return GalleryState(
      galleries: galleries ?? this.galleries,
      allGalleryLoading: allGalleryLoading ?? this.allGalleryLoading,
      galleryDetail: galleryDetail ?? this.galleryDetail,
      isGalleryDetailLoading:
          isGalleryDetailLoading ?? this.isGalleryDetailLoading,
      currentPage: currentPage ?? this.currentPage,
      searchController: searchController ?? this.searchController,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      paginationStatus: paginationStatus ?? this.paginationStatus,
    );
  }

  factory GalleryState.initial() {
    return GalleryState(
      galleries: [],
      allGalleryLoading: true,
      galleryDetail: null,
      isGalleryDetailLoading: true,
      currentPage: 1,
      searchController: TextEditingController(),
      hasReachedEnd: false,
      paginationStatus: PaginationStatus.initial,
    );
  }
}

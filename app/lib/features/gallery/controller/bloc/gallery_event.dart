part of 'gallery_bloc.dart';

sealed class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class GalleryInitialEvent extends GalleryEvent {}

class FetchAllGalleryEvent extends GalleryEvent {
  final int page;
  final bool isInitial;

  const FetchAllGalleryEvent({
    required this.page,
    this.isInitial = false,
  });
}

class FetchGalleryDetailEvent extends GalleryEvent {
  final String galleryId;

  const FetchGalleryDetailEvent(this.galleryId);

  @override
  List<Object> get props => [galleryId];
}

class ClearGalleryDetailEvent extends GalleryEvent {}

class RefreshGalleryEvent extends GalleryEvent {}

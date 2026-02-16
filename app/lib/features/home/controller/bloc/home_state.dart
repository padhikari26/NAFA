part of 'home_bloc.dart';

class HomeState {
  final bool isLoading;
  final FeaturedEventModel? featuredEventModel;
  final BannerPopupModel? bannerPopupModel;

  HomeState(
      {this.isLoading = false, this.featuredEventModel, this.bannerPopupModel});

  HomeState copyWith(
      {bool? isLoading,
      FeaturedEventModel? featuredEventModel,
      BannerPopupModel? bannerPopupModel}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      featuredEventModel: featuredEventModel ?? this.featuredEventModel,
      bannerPopupModel: bannerPopupModel ?? this.bannerPopupModel,
    );
  }

  factory HomeState.initial() {
    return HomeState(
      isLoading: false,
      featuredEventModel: FeaturedEventModel(),
      bannerPopupModel: BannerPopupModel(),
    );
  }
}

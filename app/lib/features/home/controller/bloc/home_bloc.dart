import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nafausa/app/utils/constants.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:nafausa/shared/widgets/custom_dialog.dart';
import '../../../../app/utils/dependencies.dart';
import '../../../../core/network/api_request/api_request.dart';
import '../../../../env.dart';
import '../../../auth/controllers/bloc/auth_bloc.dart';
import '../../model/banner_popup_model.dart';
import '../../model/featured_event_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>
    with NetworkEventTransformer<HomeEvent, HomeState> {
  ApiRequest apiRequest = getIt<ApiRequest>();
  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialEvent>(_handleInitialEvent);
    on<FetchFeaturedEvent>(_handleFetchFeaturedEvent,
        transformer: networkCheckTransformer());
    on<FetchPopUpEvent>(_handleFetchPopupEvent,
        transformer: networkCheckTransformer());
  }

  void _handleInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(HomeState.initial());
  }

  void _handleFetchFeaturedEvent(
      FetchFeaturedEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiRequest.fetchFeaturedEvents();
    if (!response.isSuccess) {
      emit(state.copyWith(
        isLoading: false,
      ));
      return;
    }
    final data = FeaturedEventModel.fromJson(response.data);
    emit(state.copyWith(
      isLoading: false,
      featuredEventModel: data,
    ));
  }

  void _handleFetchPopupEvent(
      FetchPopUpEvent event, Emitter<HomeState> emit) async {
    final response = await apiRequest.fetchBannerPopup();
    if (!response.isSuccess) {
      emit(state.copyWith());
      return;
    }
    final data = BannerPopupModel.fromJson(response.data);
    emit(state.copyWith(
      bannerPopupModel: data,
    ));
    if (data.data != null &&
        (data.data?.media?.path.isNotNullOrEmpty ?? false)) {
      CustomDialog.showCustomDialog(
          barrierDismissible: false,
          context: cusCtx!,
          title: "",
          content: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.screenHeight * 0.9,
                  minHeight: SizeConfig.screenHeight * 0.5,
                ),
                child: IntrinsicHeight(
                  child: CustomCachedImageNetwork(
                    fit: BoxFit.contain,
                    imageUrl:
                        "${AppEnviro.imageUrl}/${data.data?.media?.path ?? ""}",
                  ),
                ),
              ),
            ],
          ));
    }
  }
}

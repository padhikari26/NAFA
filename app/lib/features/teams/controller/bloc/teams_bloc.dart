import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nafausa/app/utils/toast.dart';

import '../../../../app/utils/dependencies.dart';
import '../../../../core/network/api_request/api_request.dart';
import '../../../auth/controllers/bloc/auth_bloc.dart';
import '../../model/teams_model.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState>
    with NetworkEventTransformer<TeamsEvent, TeamsState> {
  ApiRequest apiRequest = getIt<ApiRequest>();
  TeamsBloc() : super(TeamsState.initial()) {
    on<TeamsInitialEvent>(_handleInitialEvent);
    on<FetchTeamsEvent>(_fetchTeams);
  }

  void _handleInitialEvent(TeamsInitialEvent event, Emitter<TeamsState> emit) {
    emit(TeamsState.initial());
  }

  void _fetchTeams(FetchTeamsEvent event, Emitter<TeamsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await ApiRequest().fetchTeams();
    if (!response.isSuccess) {
      showFailureToast(message: response.formattedErrorMessage);
      emit(state.copyWith(
        isLoading: false,
      ));
      return;
    }
    final data = TeamsModel.fromJson(response.data);
    emit(state.copyWith(
      isLoading: false,
      teams: data.data,
      executive: (data.data != null &&
              data.data!.any((team) => team.type == 'executive'))
          ? data.data!.firstWhere((team) => team.type == 'executive')
          : TeamsData(),
      advisory: (data.data != null &&
              data.data!.any((team) => team.type == 'advisory'))
          ? data.data!.firstWhere((team) => team.type == 'advisory')
          : TeamsData(),
      pastTeams: (data.data != null &&
              data.data!.any((team) => team.type == 'pastexecutive'))
          ? data.data!.firstWhere((team) => team.type == 'pastexecutive')
          : TeamsData(),
    ));
  }
}

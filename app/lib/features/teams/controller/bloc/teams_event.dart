part of 'teams_bloc.dart';

sealed class TeamsEvent extends Equatable {
  const TeamsEvent();

  @override
  List<Object> get props => [];
}

class TeamsInitialEvent extends TeamsEvent {}

class FetchTeamsEvent extends TeamsEvent {}

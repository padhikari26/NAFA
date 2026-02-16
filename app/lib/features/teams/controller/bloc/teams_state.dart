part of 'teams_bloc.dart';

class TeamsState {
  final bool isLoading;
  final List<TeamsData>? teams;
  final TeamsData executive;
  final TeamsData advisory;
  final TeamsData pastTeams;

  TeamsState({
    this.isLoading = false,
    this.teams,
    required this.executive,
    required this.advisory,
    required this.pastTeams,
  });

  TeamsState copyWith({
    bool? isLoading,
    List<TeamsData>? teams,
    TeamsData? executive,
    TeamsData? advisory,
    TeamsData? pastTeams,
  }) {
    return TeamsState(
      isLoading: isLoading ?? this.isLoading,
      teams: teams ?? this.teams,
      executive: executive ?? this.executive,
      advisory: advisory ?? this.advisory,
      pastTeams: pastTeams ?? this.pastTeams,
    );
  }

  factory TeamsState.initial() {
    return TeamsState(
      isLoading: false,
      teams: [],
      executive: TeamsData(),
      advisory: TeamsData(),
      pastTeams: TeamsData(),
    );
  }
}

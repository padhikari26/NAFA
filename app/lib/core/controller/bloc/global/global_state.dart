part of 'global_bloc.dart';

class GlobalState extends Equatable {
  final bool isDarkTheme;
  final LoginState? authState;
  final bool isLoading;
  final bool? showOnboarding;
  final bool isLoggedIn;
  final UserData? user;

  const GlobalState({
    required this.isDarkTheme,
    required this.authState,
    this.isLoading = false,
    this.showOnboarding,
    this.isLoggedIn = false,
    this.user,
  });

  GlobalState copyWith({
    bool? isDarkTheme,
    LoginState? authState,
    bool? isLoading,
    bool? resumeToken,
    bool? showOnboarding,
    bool? isLoggedIn,
    UserData? user,
  }) {
    return GlobalState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      authState: authState ?? this.authState,
      isLoading: isLoading ?? this.isLoading,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }

  factory GlobalState.initial() {
    return const GlobalState(
      isDarkTheme: false,
      authState: LoginState.unauthenticate,
      isLoading: false,
      showOnboarding: true,
      isLoggedIn: false,
      user: null,
    );
  }
  @override
  List<Object?> get props => [
        isDarkTheme,
        authState,
        isLoading,
        showOnboarding,
        isLoggedIn,
        user,
      ];
}

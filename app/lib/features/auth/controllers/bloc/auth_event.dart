part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginPasswordVisibilityEvent extends AuthEvent {
  final bool isVisible;
  const LoginPasswordVisibilityEvent(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}

class LoginInitialEvent extends AuthEvent {
  const LoginInitialEvent();
}

class LoginSubmitEvent extends AuthEvent {
  final String loginCode;
  final String name;
  final String phone;
  final String city;
  const LoginSubmitEvent({
    required this.loginCode,
    required this.name,
    required this.phone,
    required this.city,
  });
}

class LoginFailureEvent extends AuthEvent {
  final String? errorMessage;
  const LoginFailureEvent(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ConnectivityChangedEvent extends AuthEvent {
  final bool isConnected;
  const ConnectivityChangedEvent(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class ClearErrorEvent extends AuthEvent {
  const ClearErrorEvent();
}

class ChangeState extends AuthEvent {
  final AuthState newState;
  const ChangeState(this.newState);

  @override
  List<Object?> get props => [newState];
}

class RegisterSubmitEvent extends AuthEvent {
  final File? photo;
  final RegisterRequestModel data;

  const RegisterSubmitEvent({required this.data, this.photo});
}

class UpdateProfileEvent extends AuthEvent {
  final String id;
  final File? photo;
  final RegisterRequestModel data;

  const UpdateProfileEvent({this.photo, required this.data, required this.id});

  @override
  List<Object?> get props => [photo, data];
}

class FetchProfileEvent extends AuthEvent {
  const FetchProfileEvent();
}

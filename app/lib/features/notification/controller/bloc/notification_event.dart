part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationInitialEvent extends NotificationEvent {}

class FetchAllNotificationEvent extends NotificationEvent {
  final int page;
  final bool isInitial;

  const FetchAllNotificationEvent({
    required this.page,
    this.isInitial = false,
  });

  @override
  List<Object> get props => [page, isInitial];
}

class RefreshNotificationEvent extends NotificationEvent {
  const RefreshNotificationEvent();
}

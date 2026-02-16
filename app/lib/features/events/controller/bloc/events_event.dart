part of 'events_bloc.dart';

sealed class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class EventsInitialEvent extends EventsEvent {}

class FetchEventsEvent extends EventsEvent {
  final int page;
  final bool isInitial;

  const FetchEventsEvent({required this.page, this.isInitial = false});
}

class FetchEventByIdEvent extends EventsEvent {
  final String eventId;

  const FetchEventByIdEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class ClearEventDetail extends EventsEvent {}

class UpdateFilterEvent extends EventsEvent {
  final DataFilter filter;

  const UpdateFilterEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

class ChangeFilterTypeEvent extends EventsEvent {
  final FilterType filterType;

  const ChangeFilterTypeEvent(this.filterType);

  @override
  List<Object> get props => [filterType];
}

class RefreshEventsEvent extends EventsEvent {}

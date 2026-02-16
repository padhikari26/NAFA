class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final String status;
  final String? image;
  final String category;
  final bool isRegistrationOpen;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    this.image,
    required this.category,
    required this.isRegistrationOpen,
  });
}

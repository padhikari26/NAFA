class TeamMemberModel {
  final String id;
  final String name;
  final String position;
  final String? image;
  final String phone;
  final String email;
  final String teamType; // executive, advisory, past

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.position,
    this.image,
    required this.phone,
    required this.email,
    required this.teamType,
  });

  String get initials => name.split(' ').map((n) => n[0]).join('');
}

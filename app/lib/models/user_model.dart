class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String? profileImage;
  final String membershipId;
  final String membershipType;
  final DateTime memberSince;
  final DateTime membershipExpiry;
  final bool isActive;
  final int eventsAttended;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImage,
    required this.membershipId,
    required this.membershipType,
    required this.memberSince,
    required this.membershipExpiry,
    required this.isActive,
    required this.eventsAttended,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}

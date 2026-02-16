class RegisterRequestModel {
  final String? email;
  final String? name;
  final String? photo;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? country;
  final String? phone;
  final String? state;
  final String? zipCode;

  RegisterRequestModel({
    this.email,
    this.name,
    this.photo,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.phone,
    this.state,
    this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'photo': photo,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'country': country,
      'phone': phone,
      'state': state,
      'zipCode': zipCode,
    };
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      email: json['email'],
      name: json['name'],
      photo: json['photo'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      country: json['country'],
      phone: json['phone'],
      state: json['state'],
      zipCode: json['zipCode'],
    );
  }
}

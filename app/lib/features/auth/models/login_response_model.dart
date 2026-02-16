class LoginModel {
  UserData? user;
  String? token;

  LoginModel({this.user, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class UserData {
  String? id;
  // String? email;
  String? name;
  // String? role;
  // bool? isActive;
  // bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;
  // String? userCode;
  String? lastLogin;
  // bool? isSubscribed;
  // bool? isVerified;
  // Photo? photo;
  // String? addressLine1;
  // String? addressLine2;
  String? city;
  // String? country;
  String? phone;
  // String? state;
  // String? zipCode;
  // String? subscriptionExpiry;
  // String? fcmToken;

  UserData({
    this.id,
    // this.email,
    this.name,
    // this.role,
    // this.isActive,
    // this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    // this.userCode,
    this.lastLogin,
    // this.isSubscribed,
    // this.isVerified,
    // this.photo,
    // this.addressLine1,
    // this.addressLine2,
    this.city,
    // this.country,
    this.phone,
    // this.state,
    // this.zipCode,
    // this.subscriptionExpiry,
    // this.fcmToken,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    // email = json['email'];
    name = json['name'];
    // role = json['role'];
    // isActive = json['isActive'];
    // isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    // userCode = json['userCode'];
    lastLogin = json['lastLogin'];
    // isSubscribed = json['isSubscribed'];
    // isVerified = json['isVerified'];
    // photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
    // addressLine1 = json['addressLine1'];
    // addressLine2 = json['addressLine2'];
    city = json['city'];
    // country = json['country'];
    phone = json['phone'];
    // state = json['state'];
    // zipCode = json['zipCode'];
    // subscriptionExpiry = json['subscriptionExpiry'];
    // fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    // data['email'] = email;
    data['name'] = name;
    // data['role'] = role;
    // data['isActive'] = isActive;
    // data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    // data['userCode'] = userCode;
    data['lastLogin'] = lastLogin;
    // data['isSubscribed'] = isSubscribed;
    // data['isVerified'] = isVerified;
    // if (photo != null) {
    //   data['photo'] = photo!.toJson();
    // }
    // data['addressLine1'] = addressLine1;
    // data['addressLine2'] = addressLine2;
    data['city'] = city;
    // data['country'] = country;
    data['phone'] = phone;
    // data['state'] = state;
    // data['zipCode'] = zipCode;
    // data['subscriptionExpiry'] = subscriptionExpiry;
    // data['fcmToken'] = fcmToken;
    return data;
  }
}

class Photo {
  String? sId;
  String? mimetype;
  String? path;
  String? type;
  String? uploadedFrom;

  Photo({this.sId, this.mimetype, this.path, this.type, this.uploadedFrom});

  Photo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mimetype = json['mimetype'];
    path = json['path'];
    type = json['type'];
    uploadedFrom = json['uploadedFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mimetype'] = mimetype;
    data['path'] = path;
    data['type'] = type;
    data['uploadedFrom'] = uploadedFrom;
    return data;
  }
}

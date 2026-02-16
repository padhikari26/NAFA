class BannerPopupModel {
  Data? data;

  BannerPopupModel({this.data});

  BannerPopupModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  Media? media;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.media,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (media != null) {
      data['media'] = media!.toJson();
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Media {
  String? sId;
  String? mimetype;
  String? path;
  String? type;
  String? uploadedFrom;

  Media({this.sId, this.mimetype, this.path, this.type, this.uploadedFrom});

  Media.fromJson(Map<String, dynamic> json) {
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

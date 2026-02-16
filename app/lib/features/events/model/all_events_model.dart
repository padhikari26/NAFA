class AllEventModel {
  List<AllEventData>? data;
  int? total;
  int? totalPages;
  int? page;
  int? limit;
  bool? next;

  AllEventModel(
      {this.data,
      this.total,
      this.totalPages,
      this.page,
      this.limit,
      this.next});

  AllEventModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllEventData>[];
      json['data'].forEach((v) {
        data!.add(AllEventData.fromJson(v));
      });
    }
    total = json['total'];
    totalPages = json['totalPages'];
    page = json['page'];
    limit = json['limit'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['totalPages'] = totalPages;
    data['page'] = page;
    data['limit'] = limit;
    data['next'] = next;
    return data;
  }
}

class AllEventData {
  String? sId;
  String? title;
  String? description;
  String? date;
  Media? media;
  String? createdAt;
  String? updatedAt;

  AllEventData(
      {this.sId,
      this.title,
      this.description,
      this.date,
      this.media,
      this.createdAt,
      this.updatedAt});

  AllEventData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    if (media != null) {
      data['media'] = media!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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

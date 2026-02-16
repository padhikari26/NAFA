class NotificationModel {
  List<NotificationData>? data;
  int? total;
  int? totalPages;
  int? page;
  int? limit;
  bool? next;

  NotificationModel(
      {this.data,
      this.total,
      this.totalPages,
      this.page,
      this.limit,
      this.next});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
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

class NotificationData {
  String? sId;
  String? title;
  String? body;
  Data? data;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationData(
      {this.sId,
      this.title,
      this.body,
      this.data,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotificationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    body = json['body'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['body'] = body;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Data {
  String? type;
  String? id;
  String? thumbnail;
  String? title;

  Data({this.type, this.id, this.thumbnail, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    thumbnail = json['thumbnail'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['thumbnail'] = thumbnail;
    data['title'] = title;
    return data;
  }
}

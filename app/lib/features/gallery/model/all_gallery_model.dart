import '../../events/model/all_events_model.dart';

class AllGalleryModel {
  List<AllGalleryData>? data;
  int? total;
  int? totalPages;
  int? page;
  int? limit;
  bool? next;

  AllGalleryModel(
      {this.data,
      this.total,
      this.totalPages,
      this.page,
      this.limit,
      this.next});

  AllGalleryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllGalleryData>[];
      json['data'].forEach((v) {
        data!.add(AllGalleryData.fromJson(v));
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

class AllGalleryData {
  String? sId;
  String? title;
  Media? medias;
  String? createdAt;
  String? updatedAt;

  AllGalleryData(
      {this.sId, this.title, this.medias, this.createdAt, this.updatedAt});

  AllGalleryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    medias = json['medias'] != null ? Media.fromJson(json['medias']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    if (medias != null) {
      data['medias'] = medias!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

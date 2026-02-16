import '../../events/model/all_events_model.dart';

class GalleryDetailModel {
  String? sId;
  String? title;
  List<Media>? medias;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GalleryDetailModel(
      {this.sId,
      this.title,
      this.medias,
      this.createdAt,
      this.updatedAt,
      this.iV});

  GalleryDetailModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    if (json['medias'] != null) {
      medias = <Media>[];
      json['medias'].forEach((v) {
        medias!.add(Media.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    if (medias != null) {
      data['medias'] = medias!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

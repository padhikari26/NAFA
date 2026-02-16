import 'all_events_model.dart';

class SingleEventModel {
  String? sId;
  String? title;
  String? description;
  String? date;
  List<Media>? media;
  List<Media>? documents;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SingleEventModel(
      {this.sId,
      this.title,
      this.description,
      this.date,
      this.media,
      this.documents,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SingleEventModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = <Media>[];
      json['documents'].forEach((v) {
        documents!.add(Media.fromJson(v));
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
    data['description'] = description;
    data['date'] = date;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

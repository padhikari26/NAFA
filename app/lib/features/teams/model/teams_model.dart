import '../../events/model/all_events_model.dart';

class TeamsModel {
  List<TeamsData>? data;

  TeamsModel({this.data});

  TeamsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TeamsData>[];
      json['data'].forEach((v) {
        data!.add(TeamsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamsData {
  String? sId;
  String? type;
  String? content;
  List<Media>? media;
  String? createdAt;
  String? updatedAt;
  int? iV;

  TeamsData(
      {this.sId,
      this.type,
      this.content,
      this.media,
      this.createdAt,
      this.updatedAt,
      this.iV});

  TeamsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    content = json['content'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['content'] = content;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

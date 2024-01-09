class SubtitlePathModel {
  String? name;
  String? path;

  SubtitlePathModel({this.name, this.path});

  SubtitlePathModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    return data;
  }
}

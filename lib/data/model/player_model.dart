class PlayerModel {
  String? subtitle;
  PlayerData? data;

  PlayerModel({this.subtitle, this.data});

  PlayerModel.fromJson(Map<String, dynamic> json) {
    subtitle = json['subtitle'];
    data = json['data'] != null ? PlayerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subtitle'] = subtitle;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PlayerData {
  String? file;
  String? type;

  PlayerData({this.file, this.type});

  PlayerData.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file'] = file;
    data['type'] = type;
    return data;
  }
}

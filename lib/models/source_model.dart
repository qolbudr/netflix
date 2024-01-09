class SourceModel {
  String? file;
  String? label;
  String? type;

  SourceModel({this.file, this.label, this.type});

  SourceModel.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    label = json['label'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file'] = file;
    data['label'] = label;
    data['type'] = type;
    return data;
  }
}

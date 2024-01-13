import 'package:netflix/models/tmdb_model.dart';

class ItemModel {
  String? title;
  Tmdb? tmdb;

  ItemModel({this.title, this.tmdb});

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    tmdb = Tmdb.fromJson(json['tmdb']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['tmdb'] = tmdb?.toJson();
    return data;
  }
}

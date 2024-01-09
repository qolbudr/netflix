

import 'package:netflix/models/tmdb_model.dart';

class Movie {
  num? season;
  String? link;
  String? title;
  bool? series;
  Tmdb? tmdb;

  Movie({this.link, this.title, this.series, this.tmdb});

  Movie.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    season = int.tryParse(json['season'].toString());
    title = json['title'];
    series = json['series'];
    tmdb = json['tmdb'] != null ? Tmdb.fromJson(json['tmdb']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['link'] = link;
    data['title'] = title;
    data['series'] = series;
    if (tmdb != null) {
      data['tmdb'] = tmdb!.toJson();
    }
    return data;
  }
}

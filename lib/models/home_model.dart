

import 'package:netflix/models/tmdb_model.dart';

class HomeModel {
  Tmdb? banner;
  List<Tmdb>? trendingMovies;
  List<Tmdb>? trendingTv;

  HomeModel({this.banner, this.trendingMovies, this.trendingTv});

  HomeModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] != null ? Tmdb.fromJson(json['banner']) : null;
    if (json['trendingMovies'] != null) {
      trendingMovies = <Tmdb>[];
      json['trendingMovies'].forEach((v) {
        trendingMovies!.add(Tmdb.fromJson(v));
      });
    }
    if (json['trendingTv'] != null) {
      trendingTv = <Tmdb>[];
      json['trendingTv'].forEach((v) {
        trendingTv!.add(Tmdb.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banner != null) {
      data['banner'] = banner!.toJson();
    }
    if (trendingMovies != null) {
      data['trendingMovies'] = trendingMovies!.map((v) => v.toJson()).toList();
    }
    if (trendingTv != null) {
      data['trendingTv'] = trendingTv!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

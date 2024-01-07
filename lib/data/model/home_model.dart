import 'package:netflix/data/model/movie_model.dart';

class HomeModel {
  Movie? banner;
  List<Movie>? trendingMovies;
  List<Movie>? trendingTv;

  HomeModel({this.banner, this.trendingMovies, this.trendingTv});

  HomeModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] != null ? Movie.fromJson(json['banner']) : null;
    if (json['trendingMovies'] != null) {
      trendingMovies = <Movie>[];
      json['trendingMovies'].forEach((v) {
        trendingMovies!.add(Movie.fromJson(v));
      });
    }
    if (json['trendingTv'] != null) {
      trendingTv = <Movie>[];
      json['trendingTv'].forEach((v) {
        trendingTv!.add(Movie.fromJson(v));
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

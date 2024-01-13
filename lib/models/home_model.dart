

import 'package:netflix/models/item_model.dart';

class HomeModel {
  ItemModel? banner;
  List<ItemModel>? trendingMovies;
  List<ItemModel>? trendingTv;

  HomeModel({this.banner, this.trendingMovies, this.trendingTv});

  HomeModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] != null ? ItemModel.fromJson(json['banner']) : null;
    if (json['trendingMovies'] != null) {
      trendingMovies = <ItemModel>[];
      json['trendingMovies'].forEach((v) {
        trendingMovies!.add(ItemModel.fromJson(v));
      });
    }
    if (json['trendingTv'] != null) {
      trendingTv = <ItemModel>[];
      json['trendingTv'].forEach((v) {
        trendingTv!.add(ItemModel.fromJson(v));
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

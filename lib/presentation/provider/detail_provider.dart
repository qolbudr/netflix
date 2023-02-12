import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/episode_model.dart';
import 'package:netflix/data/model/movie_detail_model.dart';

class DetailProvider extends ChangeNotifier {
  MovieDetailModel? movie;
  bool isLoading = true;
  final getIt = GetIt.instance;

  List<Episodes>? episode;
  bool episodeLoading = true;

  Future<void> getMovieDetail(int id, String type) async {
    try {
      isLoading = true;
      notifyListeners();
      
      final response = await getIt<Api>().getMovieDetail(id, type);
      movie = response;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getEpisode(int id, int season) async {
    try {
      episode = [];
      episodeLoading = true;
      notifyListeners();
      
      final response = await getIt<Api>().getEpisode(id, season);
      episode = response;
      episodeLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
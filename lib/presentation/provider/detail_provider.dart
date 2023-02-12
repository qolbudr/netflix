import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/movie_detail_model.dart';

class DetailProvider extends ChangeNotifier {
  MovieDetailModel? movie;
  bool isLoading = true;
  final getIt = GetIt.instance;

  Future<void> getMovieDetail(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      
      final response = await getIt<Api>().getMovieDetail(id);
      movie = response;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
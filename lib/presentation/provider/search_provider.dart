import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/movie_model.dart';

class SearchProvider extends ChangeNotifier {
  List<Movie>? newest;
  int newestPage = 1;
  bool isLoading = false;
  final getIt = GetIt.instance;

  List<Movie>? search;

  Future<void> getSearch(Map<String, dynamic> data) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await getIt<Api>().getSearch(data['title'], data['page']);
      if (data['page'] == 1) {
        search = response;
      } else {
        search!.addAll(response);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

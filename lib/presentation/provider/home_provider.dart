import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/home_model.dart';

class HomeProvider extends ChangeNotifier {
  HomeModel? data;
  bool isLoading = true;
  final getIt = GetIt.instance;
  String? category;
  List<Movie>? movies;
  bool isLoadingCategory = true;

  Future<void> getData() async {
    try {
      final response = await getIt<Api>().getHome();
      data = response;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void setCategory(String? data) {
    if(data != null) {
      category = data;
      notifyListeners();

      getCategory(1);
    } else {
      category = null;
      notifyListeners();
    }
  }

  Future<void> getCategory(int page) async {
    try {
      if(page == 1) {
        movies = null;
      }
      isLoadingCategory = true;
      notifyListeners();

      final response = await getIt<Api>().getCategory(category!.toLowerCase(), page);

      if(page == 1) {
        movies = response;
      } else {
        movies!.addAll(response);
      }

      isLoadingCategory = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
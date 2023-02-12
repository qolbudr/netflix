import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/home_model.dart';

class SearchProvider extends ChangeNotifier {
  List<Movie>? newest;
  int newestPage = 1;
  bool isLoading = true;
  final getIt = GetIt.instance;

  List<Movie>? search;

  Future<void> getNewest(bool isNext) async {
    try {
      if(!isNext && newestPage != 1) {
        return;
      }

      isLoading = true;
      notifyListeners();
      
      final response = await getIt<Api>().getNewest(newestPage);
      if(newestPage == 1) {
        newest = response;
      } else {
        newest!.addAll(response);
      }
      
      newestPage++;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getSearch(Map<String, dynamic> data) async {
    try {
      isLoading = true;
      notifyListeners();
      
      final response = await getIt<Api>().getSearch(data['title'], data['page']);
      if(data['page'] == 1) {
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
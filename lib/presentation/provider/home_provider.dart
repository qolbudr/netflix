import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/home_model.dart';

class HomeProvider extends ChangeNotifier {
  HomeModel? data;
  bool isLoading = true;
  final getIt = GetIt.instance;

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
}
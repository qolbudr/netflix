import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/episode_model.dart';
import 'package:netflix/data/model/subtitle_path_model.dart';

class DetailProvider extends ChangeNotifier {
  bool isLoading = true;
  final getIt = GetIt.instance;
  
  bool subtitleLoading = true;
  String? subtitleRaw;

  Map<String, List<SubtitlePathModel>>? subtitlePathModel;
  List<Episodes>? episode;
  bool episodeLoading = false;

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

  Future<void> getSubtitlePath(String imdbId) async {
    try {
      subtitleLoading = true;
      notifyListeners();

      final response = await getIt<Api>().getSubtitlePath(imdbId);
      Map<String, List<SubtitlePathModel>> result = {};
      for(var item in response.keys) {
        List<SubtitlePathModel> resultList = [];
        for(var list in response[item]!) {
          if(resultList.where((element) => element.name == list.name).isEmpty) {
            resultList.add(list);
          }
        }
        result[item] = resultList;
      }

      subtitlePathModel = result;
      subtitleLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getSubtitleRawData(String imdbId, String path) async {
    try {
      final response = await getIt<Api>().getSubtitleRawData(imdbId, path);
      subtitleRaw = response;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void resetSubtitle() {
    subtitleLoading = true;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netflix/models/episode_model.dart';
import 'package:netflix/models/home_model.dart';
import 'package:netflix/models/movie_model.dart';
import 'package:netflix/models/subtitle_path_model.dart';

class ApiServices {
  static String baseURL = 'https://netflix-be-six.vercel.app/api';
  
  Future<HomeModel> getHome() async {
    try {
      final response = await http.get(Uri.parse("$baseURL/home"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        HomeModel model = HomeModel.fromJson(data);
        return model;
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Episodes>> getEpisode(int id, int season) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/episode?tmdbId=$id&season=$season"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        EpisodeModel model = EpisodeModel.fromJson(data);
        return model.episodes!.where((element) => element.seasonNumber! > 0).toList();
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getSearch(String title, int page) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/search?keyword=$title&page=$page"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Movie> result = <Movie>[];
        for (Map<String, dynamic> v in data) {
          result.add(Movie.fromJson(v));
        }

        return result;
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getCategory(String category, int page) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/genre?genre=$category&page=$page"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Movie> result = <Movie>[];
        for (Map<String, dynamic> v in data) {
          result.add(Movie.fromJson(v));
        }

        return result;
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, List<SubtitlePathModel>>> getSubtitlePath(String imdbId) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/subtitle?imdb=$imdbId"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, List> newData = data.map((key, value) => MapEntry(key, value));
        final result = newData.map((key, value) => MapEntry(key, value.map((e) => SubtitlePathModel.fromJson(e)).toList()));
        return result;
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getSubtitleRawData(String imdbId, String path) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/subtitle?imdb=$imdbId&path=$path"));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>> getPlayer(String link, String? episode) async {
  //   try {
  //     Response response;

  //     if (episode == null) {
  //       response = await http.get(Uri.parse("$baseURL/link?link=$link"));
  //     } else {
  //       response = await http.get(Uri.parse("$baseURL/link?link=$link&episode=$episode"));
  //     }

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = jsonDecode(response.body);

  //       final newResponse = await http.get(Uri.parse(data['link']), headers: {
  //         'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  //       });

  //       final responseNew = await http.post(
  //         Uri.parse("$baseURL/data"),
  //         headers: {'Content-type': 'application/json'},
  //         body: jsonEncode({"data": newResponse.body}),
  //       );

  //       log(responseNew.body);

  //       return jsonDecode(responseNew.body);
  //     } else {
  //       throw Exception('Maaf server sedang sibuk');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}

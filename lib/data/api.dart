import 'dart:convert';
import 'package:http/http.dart';
import 'package:netflix/data/model/episode_model.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/data/model/movie_detail_model.dart';

class Api {
  Api(this.client);
  final Client client;
  static String baseURL = 'https://netflix-be-six.vercel.app/api';

  Future<HomeModel> getHome() async {
    try {
      final response = await client.get(
        Uri.parse("$baseURL/home")
      );
      
      if(response.statusCode == 200) {
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

  Future<MovieDetailModel> getMovieDetail(int id, String type) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/detail?tmdb=$id&type=$type")
      );
      
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        MovieDetailModel model = MovieDetailModel.fromJson(data);
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
      final response = await client.get(
        Uri.parse("$baseURL/episode?tmdb=$id&season=$season")
      );
      
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        EpisodeModel model = EpisodeModel.fromJson(data);
        return model.episodes!;
      } else {
        throw Exception('Maaf server sedang sibuk');
      }
    } catch (e) {
      rethrow;
    } 
  }

  Future<List<Movie>> getNewest(int page) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/newest?page=$page")
      );
      
      if(response.statusCode == 200) {
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

  Future<List<Movie>> getSearch(String title, int page) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/search?title=$title&page=$page")
      );
      
      if(response.statusCode == 200) {
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
      final response = await client.get(
        Uri.parse("$baseURL/genre?genre=$category&page=$page")
      );
      
      if(response.statusCode == 200) {
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
}
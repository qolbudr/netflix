import 'dart:convert';
import 'package:http/http.dart';
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

  Future<MovieDetailModel> getMovieDetail(int id) async {
   try {
      final response = await client.get(
        Uri.parse("$baseURL/detail?tmdb=$id&type=movie")
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
}
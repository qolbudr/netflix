import 'dart:convert';
import 'package:http/http.dart';
import 'package:netflix/data/model/home_model.dart';

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
}
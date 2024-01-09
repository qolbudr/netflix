import 'package:get/get.dart';
import 'package:netflix/controllers/services/api_services.dart';
import 'package:netflix/models/status_enum.dart';
import 'package:netflix/models/tmdb_model.dart';

class SearchController extends GetxController {
  static SearchController instance = Get.find();
  final ApiServices _apiServices = ApiServices();

  /* state */
  final Rx<List<Tmdb>> _newest = Rx<List<Tmdb>>([]);
  final Rx<List<Tmdb>> _search = Rx<List<Tmdb>>([]);
  final Rx<int> _newestPage = Rx<int>(1);
  final Rx<Status> _status = Rx<Status>(Status.LOADING);

  /* getter */
  List<Tmdb> get newest => _newest.value;
  List<Tmdb> get search => _search.value;
  int get newestPage => _newestPage.value;
  Status get status => _status.value;

  Future<void> getSearch(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.getSearch(data['title'], data['page']);
      _search.value = [ ...search, ...response ];
      _status.value = Status.SUCCESS;
    } catch (e) {
      _status.value = Status.ERROR;
      rethrow;
    }
  }
}
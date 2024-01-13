import 'package:get/get.dart';
import 'package:netflix/controllers/services/api_services.dart';
import 'package:netflix/models/item_model.dart';
import 'package:netflix/models/status_enum.dart';

class SearchController extends GetxController {
  static SearchController instance = Get.find();
  final ApiServices _apiServices = ApiServices();

  /* state */
  final Rx<List<ItemModel>> _newest = Rx<List<ItemModel>>([]);
  final Rx<List<ItemModel>> _search = Rx<List<ItemModel>>([]);
  final Rx<int> _newestPage = Rx<int>(1);
  final Rx<Status> _status = Rx<Status>(Status.LOADING);

  /* getter */
  List<ItemModel> get newest => _newest.value;
  List<ItemModel> get search => _search.value;
  int get newestPage => _newestPage.value;
  Status get status => _status.value;

  Future<void> getSearch(Map<String, dynamic> data) async {
    try {
      _status.value = Status.LOADING;
      final response = await _apiServices.getSearch(data['title'], data['page']);
      if (data['page'] == 1) {
        _search.value = response;
      } else {
        _search.value = [...search, ...response];
      }
      _status.value = Status.SUCCESS;
    } catch (e) {
      _status.value = Status.ERROR;
      rethrow;
    }
  }
}

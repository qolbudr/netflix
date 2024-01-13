import 'package:get/get.dart';
import 'package:netflix/controllers/services/api_services.dart';
import 'package:netflix/models/home_model.dart';
import 'package:netflix/models/item_model.dart';
import 'package:netflix/models/status_enum.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final ApiServices _apiServices = ApiServices();

  /* state */
  final Rx<HomeModel?> _data = Rx<HomeModel?>(null);
  final Rx<Status> _status = Rx<Status>(Status.LOADING);
  final Rx<List<ItemModel>> _movies  = Rx<List<ItemModel>>([]);
  final Rx<String?> _category = Rx<String?>(null);

  /* getter */
  HomeModel? get data => _data.value; 
  Status get status => _status.value; 
  List<ItemModel> get movies => _movies.value;
  String? get category => _category.value;
  

  Future<void> getData() async {
    try {
      final response = await _apiServices.getHome();
      _data.value = response;
      _status.value = Status.SUCCESS;
    } catch (e) {
      _status.value = Status.ERROR;
      rethrow;
    }
  }

  Future<void> getCategory(int page) async {
    try {
      _status.value = Status.LOADING;
      final response = await _apiServices.getCategory(category!.toLowerCase(), page);
      _movies.value = [...movies, ...response];
      _status.value = Status.SUCCESS;
    } catch (e) {
      _status.value = Status.ERROR;
      rethrow;
    }
  }

   void setCategory(String? data) {
    if (data != null) {
      _category.value = data;
      getCategory(1);
    } else {
      _category.value = null;
    }
  }
}
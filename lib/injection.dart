import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/data/api.dart';
import 'package:netflix/presentation/provider/home_provider.dart';
final locator = GetIt.instance;

void init()
{
  locator.registerLazySingleton(() => Api(locator()));
	locator.registerLazySingleton(() => http.Client());
	
	locator.registerFactory(() => HomeProvider());
}
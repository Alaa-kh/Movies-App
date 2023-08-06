import 'package:get/get.dart';

import '../controller/movies_controller.dart';
import '../controller/movies_query_controller.dart';
import '../controller/movies_top_controller.dart';
import '../controller/movies_on_air_controller.dart';

class MoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MoviesController());
    Get.lazyPut(() => MoviesTopRatedController());
    Get.lazyPut(() => MoviesQueryController());
    Get.lazyPut(() => MoviesOnAirController());
  }
}

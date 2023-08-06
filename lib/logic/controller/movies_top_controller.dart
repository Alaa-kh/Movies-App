import 'package:get/get.dart';

import '../model/movies_top_model.dart';
import '../services/movies_top_services.dart';

class MoviesTopRatedController extends GetxController {
  List<Result> moviesTopRatedList = [];
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    getMoviesTopRated();
  }

  void getMoviesTopRated() async {
    final GetTopRatedModel getMoviesTopRated =
        await MoviesTopRatedServices.getMoviesTopRated();
    final List<Result> getMoviesTopRatedResults = getMoviesTopRated.results;
    try {
      isLoading(true);
      if (getMoviesTopRatedResults.isNotEmpty) {
        moviesTopRatedList.addAll(getMoviesTopRatedResults);
      }
    } finally {
      isLoading(false);
    }
  }
}

import 'package:get/get.dart';

import '../model/movies_query_model.dart';
import '../services/movies_query_services.dart';

class MoviesQueryController extends GetxController {
  List<Result> moviesQueryList = [];
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    getMoviesQuery();
  }

  void getMoviesQuery() async {
    final GetMoviesQueryModel getMoviesQuery =
        await MoviesQueryServices.getMoviesQuery();
    final List<Result> getMoviesQueryResults = getMoviesQuery.results;
    try {
      isLoading(true);
      if (getMoviesQueryResults.isNotEmpty) {
        moviesQueryList.addAll(getMoviesQueryResults);
      }
    } finally {
      isLoading(false);
    }
  }
}

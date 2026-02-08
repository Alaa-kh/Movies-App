import 'dart:convert';
import 'package:get/get.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/model/movies_query_model.dart';
import 'package:movies/logic/services/movies_query_services.dart';

class MoviesQueryController extends GetxController {
  final moviesQueryList = <Result>[].obs;
  final isLoading = true.obs;

  late final Worker _localeWorker;

  /// Sets up locale listener and triggers the initial query fetch.
  @override
  void onInit() {
    super.onInit();
    final localeCtrl = Get.find<LocaleController>();
    _localeWorker = ever(localeCtrl.localeRx, (_) => reload());
    reload();
  }

  /// Disposes the locale worker when the controller is removed.
  @override
  void onClose() {
    _localeWorker.dispose();
    super.onClose();
  }

  /// Fetches movies by query for the current locale and updates the list.
  Future<void> reload({String query = 'hell'}) async {
    final localeCtrl = Get.find<LocaleController>();

    try {
      isLoading(true);
      moviesQueryList.clear();

      final data = await MoviesQueryServices.getMoviesQuery(
        language: localeCtrl.tmdbLanguage,
        query: query,
        page: 1,
      );

      final model = getMoviesQueryModelFromJson(jsonEncode(data));
      moviesQueryList.addAll(model.results);
    } finally {
      isLoading(false);
    }
  }
}

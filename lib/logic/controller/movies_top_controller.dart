import 'dart:convert';

import 'package:get/get.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/model/movies_top_model.dart' as top;
import 'package:movies/logic/services/movies_top_services.dart';

class MoviesTopRatedController extends GetxController {
  final isLoading = true.obs;
  final moviesTopRatedList = <top.Result>[].obs;

  late final Worker _localeWorker;

  @override
  void onInit() {
    super.onInit();
    final localeCtrl = Get.find<LocaleController>();
    _localeWorker = ever(localeCtrl.localeRx, (_) => reload());
    reload();
  }

  @override
  void onClose() {
    _localeWorker.dispose();
    super.onClose();
  }

  Future<void> reload() async {
    final localeCtrl = Get.find<LocaleController>();
    try {
      isLoading(true);
      moviesTopRatedList.clear();

      final data = await MoviesTopRatedServices.getMoviesTopRated(
        language: localeCtrl.tmdbLanguage,
      );
      final model = top.getTopRatedModelFromJson(jsonEncode(data));
      moviesTopRatedList.addAll(model.results);
    } finally {
      isLoading(false);
    }
  }
}

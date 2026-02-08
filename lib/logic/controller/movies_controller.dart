import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/model/movies_model.dart';
import 'package:movies/logic/services/movies_services.dart';
import '../../view/screens/discover_screen.dart';
import '../../view/screens/favorite_screen.dart';
import '../../view/screens/logout_screen.dart';
import '../../view/screens/movies_screen.dart';

class MoviesController extends GetxController {
  final isLoading = true.obs;
  final movieList = <Result>[].obs;

  final searchList = <Result>[].obs;
  final searchTextController = TextEditingController();

  RxInt currentIndex = 0.obs;
  late final Worker _localeWorker;

  final tabs = [
    const DiscoverMovies(),
    const MoviesScreen(),
    const FavorieScreen(),
    const LogOutScreen(),
  ].obs;

  /// Sets up locale listener and triggers the initial data load.
  @override
  void onInit() {
    super.onInit();
    final localeCtrl = Get.find<LocaleController>();
    _localeWorker = ever(localeCtrl.localeRx, (_) => reload());
    reload();
  }

  /// Disposes workers/controllers to avoid memory leaks.
  @override
  void onClose() {
    _localeWorker.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  /// Fetches movies based on the current locale and refreshes lists.
  Future<void> reload() async {
    final localeCtrl = Get.find<LocaleController>();
    try {
      isLoading(true);
      movieList.clear();

      final data = await FetchData.getMovies(language: localeCtrl.tmdbLanguage);
      final model = getMoviesModelFromJson(jsonEncode(data));

      if (model.results.isNotEmpty) {
        movieList.addAll(model.results);
      }
      addSearchToList(searchTextController.text);
    } finally {
      isLoading(false);
    }
  }

  /// Filters movieList into searchList using the provided search string.
  void addSearchToList(String searchName) {
    final q = searchName.toLowerCase().trim();
    if (q.isEmpty) {
      searchList.clear();
      update();
      return;
    }

    searchList.value = movieList.where((m) {
      final title = m.title.toLowerCase();
      return title.contains(q);
    }).toList();

    update();
  }

  /// Clears the search field and resets searchList.
  void clearSearch() {
    searchTextController.clear();
    addSearchToList('');
  }
}

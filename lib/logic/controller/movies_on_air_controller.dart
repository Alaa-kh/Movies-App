import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/model/movies_on_air_model.dart';
import 'package:movies/logic/services/movies_on_air_services.dart';

class MoviesOnAirController extends GetxController {
  final moviesOnAirList = <Result>[].obs;
  final searchList = <Result>[].obs;
  final favoriteList = <Result>[].obs;

  final strorage = GetStorage();
  final searchTextController = TextEditingController();
  final isLoading = true.obs;

  late final Worker _localeWorker;

  @override
  void onInit() {
    super.onInit();

    final stored = strorage.read<List>('isFavoritesList');
    if (stored != null) {
      final items = stored.whereType<Map>().map((e) {
        return Result.fromJson(Map<String, dynamic>.from(e));
      }).toList();
      favoriteList.assignAll(items);
    }

    final localeCtrl = Get.find<LocaleController>();
    _localeWorker = ever(localeCtrl.localeRx, (_) => reload());
    reload();
  }

  @override
  void onClose() {
    _localeWorker.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> reload() async {
    final localeCtrl = Get.find<LocaleController>();

    try {
      isLoading(true);
      moviesOnAirList.clear();

      final data = await MoviesOnAirServices.getMoviesOnAir(
        language: localeCtrl.tmdbLanguage,
        page: 1,
      );

      final model = getMoviesOnAirModelFromJson(jsonEncode(data));
      moviesOnAirList.addAll(model.results);

      addSearchToList(searchTextController.text);
    } finally {
      isLoading(false);
    }
  }

  void addSearchToList(String searchName) {
    final q = searchName.toLowerCase().trim();
    if (q.isEmpty) {
      searchList.clear();
      update();
      return;
    }

    searchList.value = moviesOnAirList.where((value) {
      final name = value.name.toLowerCase();
      return name.contains(q);
    }).toList();

    update();
  }

  void clearSearch() {
    searchTextController.clear();
    addSearchToList('');
  }

  Future<void> _persistFavorites() async {
    final list = favoriteList.map((e) => e.toJson()).toList();
    await strorage.write('isFavoritesList', list);
  }

  void favoriteMovie(int movieId) async {
    final existingIndex = favoriteList.indexWhere((e) => e.id == movieId);

    if (existingIndex >= 0) {
      favoriteList.removeAt(existingIndex);
      await _persistFavorites();
      return;
    }

    final item = moviesOnAirList.firstWhereOrNull((e) => e.id == movieId);
    if (item == null) return;

    favoriteList.add(item);
    await _persistFavorites();
  }

  bool isFavorite(int movieId) {
    return favoriteList.any((element) => element.id == movieId);
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/model/movies_on_air_model.dart';
import 'package:movies/logic/services/movies_on_air_services.dart';

class MoviesOnAirController extends GetxController {
  final moviesOnAirList = <Result>[].obs;
  final searchList = <Result>[].obs;
  final favoriteList = <Result>[].obs;

  final isLoading = false.obs;
  final query = ''.obs;

  final hasLoadedOnce = false.obs;
  final errorMessage = RxnString();

  final _storage = GetStorage();
  late final Worker _localeWorker;

  /// Initializes favorites, listens to locale changes, and triggers the initial load.
  @override
  void onInit() {
    super.onInit();

    final stored = _storage.read<List>('isFavoritesList');
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

  /// Disposes the locale worker when the controller is removed.
  @override
  void onClose() {
    _localeWorker.dispose();
    super.onClose();
  }

  /// Updates the search query and filters the current list.
  void setQuery(String v) {
    query.value = v;
    _applySearch();
  }

  /// Fetches on-air movies from the service and updates local state.
  Future<void> reload() async {
    final localeCtrl = Get.find<LocaleController>();
    final currentQuery = query.value;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await MoviesOnAirServices.getMoviesOnAir(
        language: localeCtrl.tmdbLanguage,
        page: 1,
      ).timeout(const Duration(seconds: 20));

      if (isClosed) return;

      final model = getMoviesOnAirModelFromJson(jsonEncode(data));
      moviesOnAirList.assignAll(model.results);

      query.value = currentQuery;
      _applySearch();
    } catch (e) {
      if (isClosed) return;
      moviesOnAirList.clear();
      searchList.clear();
      errorMessage.value = e.toString();
    } finally {
      if (!isClosed) {
        hasLoadedOnce.value = true;
        isLoading.value = false;
      }
    }
  }

  /// Filters moviesOnAirList into searchList based on the current query.
  void _applySearch() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      searchList.clear();
      return;
    }

    searchList.assignAll(
      moviesOnAirList.where((m) => m.name.toLowerCase().contains(q)),
    );
  }

  /// Clears the search query and resets searchList.
  void clearSearch() {
    query.value = '';
    searchList.clear();
  }

  /// Persists the current favoriteList to local storage.
  Future<void> _persistFavorites() async {
    final list = favoriteList.map((e) => e.toJson()).toList();
    await _storage.write('isFavoritesList', list);
  }

  /// Toggles a movie in favorites and persists the updated list.
  Future<void> favoriteMovie(int movieId) async {
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

  /// Checks whether a movie is currently marked as favorite.
  bool isFavorite(int movieId) {
    return favoriteList.any((e) => e.id == movieId);
  }
}

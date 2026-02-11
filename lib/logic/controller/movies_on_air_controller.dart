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

  Worker? _localeWorker;
  bool _reloading = false;

  @override
  void onInit() {
    super.onInit();

    final stored = _storage.read<List<dynamic>>('isFavoritesList');
    if (stored != null) {
      final items = stored.whereType<Map>().map((e) {
        return Result.fromJson(Map<String, dynamic>.from(e));
      }).toList();
      favoriteList.assignAll(items);
    }

    final localeCtrl = Get.find<LocaleController>();
    _localeWorker = ever(localeCtrl.localeRx, (_) => reload(force: true));
  }

  @override
  void onReady() {
    super.onReady();
    reload(force: true);
  }

  @override
  void onClose() {
    _localeWorker?.dispose();
    super.onClose();
  }

  void setQuery(String v) {
    query.value = v;
    _applySearch();
  }

  Future<void> reload({bool force = false}) async {
    if (_reloading && !force) return;
    _reloading = true;

    final currentQuery = query.value;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final localeCtrl = Get.find<LocaleController>();

      final data = await MoviesOnAirServices.getMoviesOnAir(
        language: localeCtrl.tmdbLanguage,
        page: 1,
      ).timeout(const Duration(seconds: 20));

      final model = getMoviesOnAirModelFromJson(jsonEncode(data));
      moviesOnAirList.assignAll(model.results);

      query.value = currentQuery;
      _applySearch();
    } catch (e) {
      moviesOnAirList.clear();
      searchList.clear();
      errorMessage.value = e.toString();
    } finally {
      hasLoadedOnce.value = true;
      isLoading.value = false;
      _reloading = false;
    }
  }

  void _applySearch() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      searchList.clear();
      return;
    }

    searchList.assignAll(
      moviesOnAirList.where(
        (m) => (m.name).toLowerCase().contains(q),
      ),
    );
  }

  void clearSearch() {
    query.value = '';
    searchList.clear();
  }

  Future<void> _persistFavorites() async {
    final list = favoriteList.map((e) => e.toJson()).toList();
    await _storage.write('isFavoritesList', list);
  }

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

  bool isFavorite(int movieId) {
    return favoriteList.any((e) => e.id == movieId);
  }
}

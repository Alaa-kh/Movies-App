import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movies/logic/model/movies_on_air_model.dart';
import 'package:movies/logic/services/movies_on_air_services.dart';

class MoviesOnAirController extends GetxController {
  var moviesOnAirList = <Result>[].obs;
  var searchList = <Result>[].obs;
  var favoriteList = <Result>[].obs;
  var strorage = GetStorage();
  TextEditingController searchTextController = TextEditingController();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    List? storedShoppings = strorage.read<List>('isFavoritesList');
    if (storedShoppings != null) {
      favoriteList =
          storedShoppings.map((value) => Result.fromJson(value)).toList().obs;
    }

    getOnAirMovies();
  }

  void getOnAirMovies() async {
    final GetMoviesOnAirModel movies =
        await MoviesOnAirServices.getMoviesOnAir();
    final List<Result> getMoviesResults = movies.results;

    try {
      isLoading(true);
      if (getMoviesResults.isNotEmpty) {
        moviesOnAirList.addAll(getMoviesResults);
      }
    } finally {
      isLoading(false);
    }
  }

// Search Bar Logic

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();

    searchList.value = moviesOnAirList.where((value) {
      var searchTitle = value.name.toLowerCase();
      return searchTitle.contains(searchName);
    }).toList();

    update();
  }

  void clearSearch() {
    searchTextController.clear();
    addSearchToList('');
  }

  void favoriteMovie(int movieId) async {
    var existingIndex =
        favoriteList.indexWhere((element) => element.id == movieId);
    if (existingIndex >= 0) {
      favoriteList.removeAt(existingIndex);
      await strorage.remove('isFavoritesList');
    } else {
      favoriteList
          .add(moviesOnAirList.firstWhere((element) => element.id == movieId));

      await strorage.write('isFavoritesList', favoriteList);
    }
  }

  bool isFavorite(int movieId) {
    return favoriteList.any((element) => element.id == movieId);
  }
}

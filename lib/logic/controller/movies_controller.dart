import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/logic/model/movies_model.dart';

import '../../view/screens/favorite_screen.dart';
import '../../view/screens/logout_screen.dart';
import '../../view/screens/discover_screen.dart';
import '../../view/screens/movies_screen.dart';
import '../services/movies_services.dart';

class MoviesController extends GetxController {
  List<Result> movieList = [];
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    getMovies();
  }

  void getMovies() async {
    final GetMoviesModel movies = await FetchData.getMovies();
    final List<Result> getMoviesResults = movies.results;

    try {
      isLoading(true);
      if (getMoviesResults.isNotEmpty) {
        movieList.addAll(getMoviesResults);
      }
    } finally {
      isLoading(false);
    }
  }

  var searchList = <Result>[].obs;
  TextEditingController searchTextController = TextEditingController();

// Search Bar Logic

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();

    searchList.value = movieList.where((value) {
      var searchTitle = value.title.toLowerCase();
      return searchTitle.contains(searchName);
    }).toList();

    update();
  }

  void clearSearch() {
    searchTextController.clear();
    addSearchToList('');
  }

  RxInt currentIndex = 0.obs;

  final tabs = [
    DiscoverMovies(),
    MoviesScreen(),
    FavorieScreen(),
    LogOutScreen(),
  ].obs;
}

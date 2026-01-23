import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../logic/controller/movies_controller.dart';
import '../../logic/controller/movies_query_controller.dart';
import '../../logic/controller/movies_top_controller.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart';
import '../widgets/text_utils.dart';
import 'main_screen.dart';
import 'movie_details.dart';

final controller = Get.find<MoviesController>();
final moviesTopRatedController = Get.find<MoviesTopRatedController>();
final moviesQueryController = Get.find<MoviesQueryController>();

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUtils(
                      text: various,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  TextUtils(
                      text: titleApp,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade400.withValues(alpha: .2),
                  ),
                  width: 50,
                  child: const Icon(
                    Icons.star,
                    size: 50,
                  )),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextUtils(
                text: popularTxt,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () {
                      if (moviesTopRatedController.isLoading.value == true) {
                        return Center(
                          child: Lottie.asset(loadingAnimate),
                        );
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          height: 320,
                          child: ListView.builder(
                              itemCount: controller.movieList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => buildContainer(
                                    onTap: () {
                                      return Get.to(
                                          MovieDetails(
                                              getMovies:
                                                  controller.movieList[index]),
                                          transition: Transition.size,
                                          duration: const Duration(
                                              milliseconds: 400));
                                    },
                                    rate: controller
                                            .movieList[index].voteAverage /
                                        2,
                                    height: 190,
                                    width: 400,
                                    image: urlImage +
                                        controller
                                            .movieList[index].backdropPath!,
                                    title: controller.movieList[index].title,
                                    voteAverage: controller
                                        .movieList[index].voteAverage
                                        .toString(),
                                  )),
                        );
                      }
                    },
                  ),
                  TextUtils(
                      text: topRatedTxt,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (moviesTopRatedController.isLoading.value == true) {
                      return Center(
                        child: Lottie.asset(loadingAnimate),
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: moviesTopRatedController
                                .moviesTopRatedList.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 400,
                                    childAspectRatio: 2,
                                    mainAxisSpacing: 6,
                                    crossAxisSpacing: 6),
                            itemBuilder: (context, index) => buildContainer(
                                  width: 200,
                                  height: 190,
                                  onTap: () => Get.to(
                                      () => MovieDetails(
                                          getMovies: moviesTopRatedController
                                              .moviesTopRatedList[index]),
                                      transition: Transition.size,
                                      duration:
                                          const Duration(milliseconds: 500)),
                                  image: urlImage +
                                      moviesTopRatedController
                                          .moviesTopRatedList[index].posterPath,
                                  title: moviesTopRatedController
                                      .moviesTopRatedList[index].title,
                                  rate: moviesTopRatedController
                                          .moviesTopRatedList[index]
                                          .voteAverage /
                                      2,
                                  voteAverage: moviesTopRatedController
                                      .moviesTopRatedList[index].voteAverage
                                      .toString(),
                                )),
                      );
                    }
                  }),
                  TextUtils(
                      text: queryMoviesTxt,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (moviesQueryController.isLoading.value == true) {
                      return Center(
                        child: Lottie.asset(loadingAnimate),
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                moviesQueryController.moviesQueryList.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 400,
                                    childAspectRatio: 2,
                                    mainAxisSpacing: 6,
                                    crossAxisSpacing: 6),
                            itemBuilder: (context, index) => buildContainer(
                                  width: 200,
                                  height: 190,
                                  onTap: () => Get.to(
                                      () => MovieDetails(
                                          getMovies: moviesQueryController
                                              .moviesQueryList[index]),
                                      transition: Transition.size,
                                      duration:
                                          const Duration(milliseconds: 500)),
                                  image: urlImage +
                                      moviesQueryController
                                          .moviesQueryList[index].posterPath,
                                  title: moviesQueryController
                                      .moviesQueryList[index].title,
                                  rate: moviesQueryController
                                          .moviesQueryList[index].voteAverage /
                                      2,
                                  voteAverage: moviesQueryController
                                      .moviesQueryList[index].voteAverage
                                      .toString(),
                                )),
                      );
                    }
                  }),
                ],
              ),
            )
          ]),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/animation/motions.dart';

import '../../logic/controller/movies_controller.dart';
import '../../logic/controller/movies_query_controller.dart';
import '../../logic/controller/movies_top_controller.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart';
import '../widgets/text_utils.dart';
import 'movie_details.dart';
import 'main_screen.dart';

final controller = Get.find<MoviesController>();
final moviesTopRatedController = Get.find<MoviesTopRatedController>();
final moviesQueryController = Get.find<MoviesQueryController>();

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final popularCardW = (screenW * 0.9).clamp(240.0, 340.0);
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
                    Row(
                      children: [
                        TextUtils(
                          text: various,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ).fadeUp()
                      ],
                    ),
                    TextUtils(
                      text: titleApp,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).fadeUp(),
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
                  ),
                ).fadeUp(),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  text: popularTxt,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).fadeUp(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (moviesTopRatedController.isLoading.value == true) {
                        return Center(child: Lottie.asset(loadingAnimate));
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          height: 320,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(right: 12),
                            itemCount: controller.movieList.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    Colors.grey.shade700.withValues(alpha: .1),
                              ),
                              child: buildContainer(
                                onTap: () {
                                  return Get.to(
                                    MovieDetails(
                                        getMovies: controller.movieList[index]),
                                    transition: Transition.size,
                                    duration: const Duration(milliseconds: 400),
                                  );
                                },
                                rate:
                                    controller.movieList[index].voteAverage / 2,
                                height: 190,
                                width: popularCardW,
                                image: urlImage +
                                    controller.movieList[index].backdropPath!,
                                title: controller.movieList[index].title,
                                voteAverage: controller
                                    .movieList[index].voteAverage
                                    .toString(),
                              ),
                            ),
                          ).fadeUp(),
                        );
                      }
                    }),
                    const SizedBox(height: 40),
                    TextUtils(
                      text: topRatedTxt,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).fadeUp(),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (moviesTopRatedController.isLoading.value == true) {
                        return Center(child: Lottie.asset(loadingAnimate));
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(right: 12),
                            itemCount: moviesTopRatedController
                                .moviesTopRatedList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) => SizedBox(
                              width: 210,
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade400
                                      .withValues(alpha: .12),
                                ),
                                child: buildContainer(
                                  width: 210,
                                  height: 190,
                                  onTap: () => Get.to(
                                    () => MovieDetails(
                                      getMovies: moviesTopRatedController
                                          .moviesTopRatedList[index],
                                    ),
                                    transition: Transition.size,
                                    duration: const Duration(milliseconds: 500),
                                  ),
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
                                ),
                              ),
                            ),
                          ).fadeUp(),
                        );
                      }
                    }),
                    SizedBox(
                      height: 40,
                    ),
                    TextUtils(
                      text: queryMoviesTxt,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).fadeUp(),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (moviesQueryController.isLoading.value == true) {
                        return Center(child: Lottie.asset(loadingAnimate));
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(right: 12),
                            itemCount:
                                moviesQueryController.moviesQueryList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) => SizedBox(
                              width: 210,
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade400
                                      .withValues(alpha: .12),
                                ),
                                child: buildContainer(
                                  width: 210,
                                  height: 190,
                                  onTap: () => Get.to(
                                    () => MovieDetails(
                                      getMovies: moviesQueryController
                                          .moviesQueryList[index],
                                    ),
                                    transition: Transition.size,
                                    duration: const Duration(milliseconds: 500),
                                  ),
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
                                ),
                              ),
                            ),
                          ).fadeUp(),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

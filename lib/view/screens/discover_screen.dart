import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/logic/controller/movies_controller.dart';
import 'package:movies/logic/controller/movies_query_controller.dart';
import 'package:movies/logic/controller/movies_top_controller.dart';
import 'package:movies/utils/animation/motions.dart';
import 'package:movies/utils/animations_string.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/screens/movie_details.dart';
import 'package:movies/view/widgets/text_utils.dart';

const tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';

String? buildTmdbImageUrl(String? path, {String size = 'w500'}) {
  final p = path?.trim();
  if (p == null || p.isEmpty) return null;
  final normalized = p.startsWith('/') ? p : '/$p';
  return '$tmdbImageBaseUrl$size$normalized';
}

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesCtrl = Get.find<MoviesController>();
    final topCtrl = Get.find<MoviesTopRatedController>();
    final queryCtrl = Get.find<MoviesQueryController>();

    final screenW = MediaQuery.of(context).size.width;
    final popularCardW = (screenW * 0.9).clamp(240.0, 340.0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'various'.tr,
                      style: const TextStyle(
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                      ),
                    ).fadeUp(),
                    Text(
                      'titleApp'.tr,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ).fadeUp(),
                  ],
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade400.withValues(alpha: .2),
                  ),
                  child: const Icon(Icons.star, size: 50),
                ).fadeUp(),
              ],
            ),
            const SizedBox(height: 25),
            TextUtils(
              text: 'popularMovies'.tr,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ).fadeUp(),
            const SizedBox(height: 10),
            Obx(() {
              if (moviesCtrl.isLoading.value) {
                return Center(child: Lottie.asset(loadingAnimate));
              }

              return SizedBox(
                width: double.infinity,
                height: 320,
                child: ListView.separated(
                  padding: const EdgeInsets.only(right: 12),
                  itemCount: moviesCtrl.movieList.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = moviesCtrl.movieList[index];

                    final imgPath = (item.backdropPath?.isNotEmpty == true)
                        ? item.backdropPath
                        : (item.posterPath.isNotEmpty == true
                            ? item.posterPath
                            : null);

                    return _MediaCard(
                      width: popularCardW,
                      imageUrl: buildTmdbImageUrl(imgPath),
                      title: item.title,
                      voteAverage: item.voteAverage.toStringAsFixed(1),
                      rating: item.voteAverage / 2,
                      onTap: () => Get.to(
                        () => MovieDetails(getMovies: item),
                        transition: Transition.size,
                        duration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                ).fadeUp(),
              );
            }),
            const SizedBox(height: 40),
            TextUtils(
              text: 'topRatedMovies'.tr,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ).fadeUp(),
            const SizedBox(height: 10),
            Obx(() {
              if (topCtrl.isLoading.value) {
                return Center(child: Lottie.asset(loadingAnimate));
              }

              return SizedBox(
                width: double.infinity,
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 12),
                  itemCount: topCtrl.moviesTopRatedList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = topCtrl.moviesTopRatedList[index];

                    return _MediaCard(
                      width: 210,
                      imageUrl: buildTmdbImageUrl(item.posterPath),
                      title: item.title,
                      voteAverage: item.voteAverage.toStringAsFixed(1),
                      rating: item.voteAverage / 2,
                      onTap: () => Get.to(
                        () => MovieDetails(getMovies: item),
                        transition: Transition.size,
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ).fadeUp(),
              );
            }),
            const SizedBox(height: 40),
            TextUtils(
              text: 'queryMovies'.tr,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ).fadeUp(),
            const SizedBox(height: 10),
            Obx(() {
              if (queryCtrl.isLoading.value) {
                return Center(child: Lottie.asset(loadingAnimate));
              }

              return SizedBox(
                width: double.infinity,
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 12),
                  itemCount: queryCtrl.moviesQueryList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = queryCtrl.moviesQueryList[index];

                    return _MediaCard(
                      width: 210,
                      imageUrl: buildTmdbImageUrl(item.posterPath),
                      title: item.title,
                      voteAverage: item.voteAverage.toStringAsFixed(1),
                      rating: item.voteAverage / 2,
                      onTap: () => Get.to(
                        () => MovieDetails(getMovies: item),
                        transition: Transition.size,
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ).fadeUp(),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.width,
    required this.imageUrl,
    required this.title,
    required this.voteAverage,
    required this.rating,
    required this.onTap,
  });

  final double width;
  final String? imageUrl;
  final String title;
  final String voteAverage;
  final double rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade400.withValues(alpha: .12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: imageUrl == null
                    ? const _ImagePlaceholder()
                    : Image.network(
                        imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        voteAverage,
                        style: const TextStyle(
                          color: gryClr,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    RatingBarIndicator(
                      unratedColor: gryClr,
                      itemSize: 14,
                      itemCount: 5,
                      rating: rating,
                      itemBuilder: (_, __) =>
                          const Icon(Icons.star, color: amberClr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade400.withValues(alpha: .12),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: gryClr,
      ),
    );
  }
}

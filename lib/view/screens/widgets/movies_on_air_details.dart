import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/movies_on_air_controller.dart';
import 'package:movies/logic/model/movies_on_air_model.dart';
import 'package:movies/logic/services/trailer_service.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/comments_section.dart';
import 'package:movies/view/widgets/trailer_section.dart';
import 'package:readmore/readmore.dart';

class MoviesOnAirDetails extends StatelessWidget {
  const MoviesOnAirDetails({
    super.key,
    required this.getMovies,
    required this.movieId,
  });

  final Result getMovies;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoviesOnAirController>();
    final scheme = Theme.of(context).colorScheme;

    final posterUrl = '$urlImageW780${getMovies.posterPath}';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(posterUrl, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.35),
                  Colors.black.withOpacity(.92),
                ],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: Text(
                  getMovies.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  Obx(() {
                    final fav = controller.isFavorite(movieId);
                    return IconButton(
                      onPressed: () => controller.favoriteMovie(movieId),
                      icon: Icon(
                        fav ? Icons.favorite : Icons.favorite_outline,
                        color: fav ? Colors.red : Colors.white,
                      ),
                    );
                  }),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: scheme.surface.withOpacity(.70),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RatingBarIndicator(
                                  unratedColor: scheme.outlineVariant,
                                  itemSize: 20,
                                  itemCount: 5,
                                  rating: getMovies.voteAverage / 2,
                                  itemBuilder: (_, __) => const Icon(Icons.star, color: amberClr),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  getMovies.voteAverage.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: scheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'description'.tr,
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ReadMoreText(
                              getMovies.overview,
                              trimLength: 220,
                              trimCollapsedText: 'showMore'.tr,
                              trimExpandedText: 'showLess'.tr,
                              moreStyle: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              lessStyle: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TrailerSection(
                              type: MediaType.movie,
                              id: movieId,
                              posterUrl: posterUrl,
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'comments'.tr,
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CommentsSection(type: MediaType.tv, id: movieId),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

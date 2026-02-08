import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/movies_on_air_controller.dart';
import 'package:movies/logic/model/movies_on_air_model.dart';
import 'package:movies/logic/services/trailer_service.dart';
import 'package:movies/view/widgets/comments_section.dart';
import 'package:movies/view/widgets/trailer_section.dart';
import 'package:readmore/readmore.dart';

const tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';

String? buildTmdbImageUrl(String? path, {String size = 'w780'}) {
  final p = path?.trim();
  if (p == null || p.isEmpty) return null;
  final normalized = p.startsWith('/') ? p : '/$p';
  return '$tmdbImageBaseUrl$size$normalized';
}

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

    final posterUrl = buildTmdbImageUrl(getMovies.posterPath, size: 'w780');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (posterUrl != null)
            Image.network(
              posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _BackdropPlaceholder(),
            )
          else
            const _BackdropPlaceholder(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .35),
                  Colors.black.withValues(alpha: .92),
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
                          color: scheme.surface.withValues(alpha: .70),
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
                                  itemBuilder: (_, __) =>
                                      Icon(Icons.star, color: scheme.tertiary),
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

class _BackdropPlaceholder extends StatelessWidget {
  const _BackdropPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white70,
        size: 64,
      ),
    );
  }
}

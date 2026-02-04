import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/services/trailer_service.dart';
import 'package:movies/view/widgets/comments_section.dart';
import 'package:movies/view/widgets/trailer_section.dart';
import 'package:readmore/readmore.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    super.key,
    required this.getMovies,
  });

  final dynamic getMovies;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final id = getMovies.id as int;
    final title = (getMovies.title as String?) ?? '';
    final poster = (getMovies.posterPath as String?) ?? '';
    final overview = (getMovies.overview as String?) ?? '';
    final vote = (getMovies.voteAverage as num?)?.toDouble() ?? 0;
    final posterUrl = 'https://image.tmdb.org/t/p/w780$poster';

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
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
                                  rating: vote / 2,
                                  itemBuilder: (_, __) => Icon(Icons.star, color: scheme.tertiary),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  vote.toStringAsFixed(1),
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
                              overview,
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
                              id: id,
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
                            CommentsSection(type: MediaType.movie, id: id),
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

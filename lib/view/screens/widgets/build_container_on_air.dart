import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/movies_on_air_controller.dart';
import 'package:movies/utils/animation/motions.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/text_utils.dart';

class BuildContainerOnAir extends StatelessWidget {
  const BuildContainerOnAir({
    super.key,
    required this.image,
    required this.title,
    required this.voteAverage,
    required this.rate,
    required this.movieId,
    required this.onTap,
  });

  final String image;
  final String title;
  final String voteAverage;
  final double rate;
  final int movieId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoviesOnAirController>();
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.surfaceContainerHighest.withOpacity(.35),
          border: Border.all(color: scheme.outlineVariant.withOpacity(.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ).fadeUp(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: TextUtils(
                        text: voteAverage,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        onPressed: () => controller.favoriteMovie(movieId),
                        icon: controller.isFavorite(movieId)
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : Icon(Icons.favorite_outline,
                                color: scheme.onSurface),
                      ),
                    ),
                  ],
                ).fadeUp(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RatingBarIndicator(
                  unratedColor: gryClr,
                  itemSize: 14,
                  itemCount: 5,
                  rating: rate,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: amberClr,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

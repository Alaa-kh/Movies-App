import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/movies_on_air_controller.dart';
import 'package:movies/utils/animation/motions.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/text_utils.dart';

final MoviesOnAirController controller = Get.put(MoviesOnAirController());

class BuildContainerOnAir extends StatelessWidget {
  const BuildContainerOnAir({
    Key? key,
    required this.image,
    required this.title,
    required this.voteAverage,
    required this.rate,
    required this.movieId,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final String voteAverage;
  final double rate;
  final int movieId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.shade400.withValues(alpha: .12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ).fadeUp(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: TextUtils(
                        text: voteAverage,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: gryClr,
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
                            : const Icon(Icons.favorite_outline,
                                color: Colors.white),
                      ),
                    ),
                  ],
                ).fadeUp(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
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

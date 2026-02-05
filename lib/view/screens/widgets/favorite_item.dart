import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/movies_on_air_controller.dart';
import 'package:movies/utils/theme.dart';
import '../../widgets/text_utils.dart';

Widget buildFavItem({
  required BuildContext context,
  required String image,
  required double voteAverage,
  required String title,
  required double rate,
  required VoidCallback onTap,
  required int productid,
}) {
  final controller = Get.find<MoviesOnAirController>();
  final scheme = Theme.of(context).colorScheme;

  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(image, fit: BoxFit.fill),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                TextUtils(
                  text: voteAverage.toStringAsFixed(1),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: scheme.onSurfaceVariant,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                RatingBarIndicator(
                  unratedColor: gryClr,
                  itemSize: 16,
                  itemCount: 5,
                  rating: rate,
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: amberClr),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.favoriteMovie(productid),
            icon: const Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
    ),
  );
}

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
    required this.width,
    required this.height,
    required this.rate,
    required this.movieId,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final String voteAverage;
  final double width;
  final double height;
  final double rate;
  final int movieId;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ).fadeUp(),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextUtils(
                    text: voteAverage,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: gryClr,
                  ),
                  IconButton(
                    iconSize: 25,
                    onPressed: () {
                      controller.favoriteMovie(movieId);
                    },
                    icon: controller.isFavorite(movieId)
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          ),
                  ),
                ],
              ).fadeUp(),
            ),
            RatingBarIndicator(
              unratedColor: gryClr,
              itemSize: 17,
              itemCount: 5,
              rating: rate,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: amberClr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

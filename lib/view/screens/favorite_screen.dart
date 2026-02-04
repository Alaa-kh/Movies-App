import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/animation/motions.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/view/screens/widgets/favorite_item.dart';
import 'package:movies/view/screens/widgets/movies_on_air_details.dart';
import '../../logic/controller/movies_on_air_controller.dart';
import '../../utils/animations_string.dart' hide favoriteAnimate;

class FavorieScreen extends StatelessWidget {
  const FavorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoviesOnAirController>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Obx(() {
        if (controller.favoriteList.isEmpty) {
          return Center(
            child: Lottie.asset(
              favoriteAnimate,
              width: 200,
              repeat: false,
            ),
          );
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            final item = controller.favoriteList[index];
            return buildFavItem(
              context: context,
              onTap: () => Get.to(
                () => MoviesOnAirDetails(
                  getMovies: item,
                  movieId: item.id,
                ).fadeUp(),
                transition: Transition.size,
                duration: const Duration(milliseconds: 500),
              ),
              image: '$urlImageW500${item.posterPath}',
              voteAverage: item.voteAverage,
              title: item.name,
              productid: item.id,
              rate: item.voteAverage / 2,
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: scheme.outlineVariant.withOpacity(.5),
            thickness: .6,
            height: 18,
          ),
          itemCount: controller.favoriteList.length,
        ).fadeUp();
      }),
    );
  }
}

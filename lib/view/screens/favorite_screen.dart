import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/view/screens/movies_screen.dart';
import 'package:movies/view/screens/widgets/favorite_item.dart';

import '../../logic/controller/movies_on_air_controller.dart';
import '../../utils/animations_string.dart';

final controller = Get.put(MoviesOnAirController());

class FavorieScreen extends StatelessWidget {
  const FavorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.favoriteList.isEmpty) {
        return Center(child: Lottie.asset(favoriteAnimate, width: 200));
      } else {
        return Container(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return buildFavItem(
                      onTap: () => Get.to(
                          () => MoviesOnAirDetails(
                                getMovies: controller.favoriteList[index],
                                movieId: controller.favoriteList[index].id,
                              ),
                          transition: Transition.size,
                          duration: const Duration(milliseconds: 500)),
                      image:
                          urlImage + controller.favoriteList[index].posterPath,
                      voteAverage: controller.favoriteList[index].voteAverage,
                      title: controller.favoriteList[index].name,
                      productid: controller.favoriteList[index].id,
                      rate: controller.favoriteList[index].voteAverage / 2);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  );
                },
                itemCount: controller.favoriteList.length));
      }
    });
  }
}

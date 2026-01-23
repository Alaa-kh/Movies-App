import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/animation/motions.dart';
import 'package:movies/view/screens/widgets/build_container_on_air.dart';
import 'package:movies/view/screens/widgets/movies_on_air_details.dart';
import '../../logic/controller/movies_on_air_controller.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';

final MoviesOnAirController controller = Get.put(MoviesOnAirController());

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 900 ? 4 : (width >= 600 ? 3 : 2);

    return SingleChildScrollView(
      child: Column(
        children: [
          GetBuilder<MoviesOnAirController>(
            builder: (c) => Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade400.withValues(alpha: .2),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: c.searchTextController,
                        onChanged: (searchName) {
                          c.addSearchToList(searchName);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: c.searchTextController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: c.clearSearch,
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.all(12),
                          hintText: searchTxt,
                          hintStyle: const TextStyle(color: gryClr),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade400.withValues(alpha: .2),
                    ),
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.star,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isLoading.value == true) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.searchList.isEmpty &&
                controller.searchTextController.text.isNotEmpty) {
              return Center(child: Lottie.asset(emptyAnimate));
            }

            final list = controller.searchList.isEmpty
                ? controller.moviesOnAirList
                : controller.searchList;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return BuildContainerOnAir(
                    width: double.infinity,
                    height: 190,
                    onTap: () => Get.to(
                      () => MoviesOnAirDetails(
                        getMovies: item,
                        movieId: item.id,
                      ),
                      transition: Transition.size,
                      duration: const Duration(milliseconds: 500),
                    ),
                    image: urlImage + item.posterPath,
                    title: item.name,
                    rate: item.voteAverage / 2,
                    voteAverage: item.voteAverage.toString(),
                    movieId: item.id,
                  ).fadeUp();
                },
              ),
            );
          }),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}

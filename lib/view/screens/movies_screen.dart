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

  int _cols(double w) {
    if (w >= 1200) return 6;
    if (w >= 900) return 5;
    if (w >= 700) return 4;
    if (w >= 520) return 3;
    return 2;
  }

  double _mainExtent(double w) {
    if (w >= 1200) return 330;
    if (w >= 900) return 320;
    if (w >= 700) return 310;
    if (w >= 520) return 300;
    return 290;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final crossAxisCount = _cols(w);
        final gap = w >= 700 ? 14.0 : 12.0;
        final edge = w >= 700 ? 16.0 : 12.0;
        final iconBox = w >= 700 ? 54.0 : 48.0;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(edge, edge, edge, gap),
                  child: GetBuilder<MoviesOnAirController>(
                    builder: (ctr) => Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: iconBox,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    Colors.grey.shade400.withValues(alpha: .2),
                              ),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: ctr.searchTextController,
                                onChanged: ctr.addSearchToList,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  hintText: searchTxt,
                                  hintStyle: const TextStyle(color: gryClr),
                                  suffixIcon:
                                      ctr.searchTextController.text.isNotEmpty
                                          ? IconButton(
                                              onPressed: ctr.clearSearch,
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white),
                                            )
                                          : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: gap),
                        SizedBox(
                          width: iconBox,
                          height: iconBox,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade400.withValues(alpha: .2),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.star,
                                  size: 28, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (controller.searchList.isEmpty &&
                  controller.searchTextController.text.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Lottie.asset(emptyAnimate)),
                );
              }

              final list = controller.searchList.isEmpty
                  ? controller.moviesOnAirList
                  : controller.searchList;

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: edge),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = list[index];
                      return BuildContainerOnAir(
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
                    childCount: list.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: _mainExtent(w),
                    crossAxisSpacing: gap,
                    mainAxisSpacing: gap,
                  ),
                ),
              );
            }),
            SliverToBoxAdapter(child: SizedBox(height: edge)),
          ],
        );
      },
    );
  }
}

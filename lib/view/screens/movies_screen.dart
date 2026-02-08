import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/animation/motions.dart';
import 'package:movies/view/screens/widgets/build_container_on_air.dart';
import 'package:movies/view/screens/widgets/movies_on_air_details.dart';
import '../../logic/controller/movies_on_air_controller.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart' hide emptyAnimate;

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late final MoviesOnAirController controller;
  late final TextEditingController _searchCtr;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<MoviesOnAirController>()
        ? Get.find<MoviesOnAirController>()
        : Get.put(MoviesOnAirController(), permanent: true);

    _searchCtr = TextEditingController(text: controller.query.value);
    _searchCtr.addListener(() => controller.setQuery(_searchCtr.text));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reload();
    });
  }

  @override
  void dispose() {
    _searchCtr.dispose();
    super.dispose();
  }

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

  Widget _statusSliver({
    required double topPadding,
    required Widget child,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
                  child: SizedBox(
                    height: iconBox,
                    child: Obx(() {
                      final hasText = controller.query.value.trim().isNotEmpty;

                      return TextField(
                        controller: _searchCtr,
                        decoration: InputDecoration(
                          hintText: 'search'.tr,
                          suffixIcon: hasText
                              ? IconButton(
                                  onPressed: () {
                                    _searchCtr.clear();
                                    controller.clearSearch();
                                  },
                                  icon: Icon(Icons.close,
                                      color: scheme.onSurface),
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Obx(() {
              final isFirstLoad =
                  !controller.hasLoadedOnce.value && controller.isLoading.value;

              if (isFirstLoad) {
                return _statusSliver(
                  topPadding: 40,
                  child: CircularProgressIndicator(),
                );
              }

              if (!controller.isLoading.value &&
                  controller.moviesOnAirList.isEmpty) {
                return _statusSliver(
                  topPadding: 40,
                  child: Text(
                    'No data available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ).fadeUp(),
                );
              }

              final isSearching = controller.query.value.trim().isNotEmpty;

              if (isSearching && controller.searchList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Lottie.asset(emptyAnimate)),
                );
              }

              final list = isSearching
                  ? controller.searchList
                  : controller.moviesOnAirList;

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
                        image: '$urlImageW500${item.posterPath}',
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

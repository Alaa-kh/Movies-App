import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

import '../../logic/controller/movies_on_air_controller.dart';
import '../../logic/model/movies_on_air_model.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';
import '../widgets/text_utils.dart';

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
                        color: Colors.grey.shade400.withOpacity(.2),
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
                      color: Colors.grey.shade400.withOpacity(.2),
                    ),
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: () {
                       
                      },
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
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

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
            ),
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
              ),
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

class MoviesOnAirDetails extends StatelessWidget {
  const MoviesOnAirDetails({
    Key? key,
    required this.getMovies,
    required this.movieId,
  }) : super(key: key);

  final Result getMovies;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(urlImage + getMovies.posterPath),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextUtils(
                              text: getMovies.name,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100.withOpacity(.2),
                            ),
                            child: IconButton(
                              iconSize: 30,
                              onPressed: () {
                                controller.favoriteMovie(movieId);
                              },
                              icon: controller.isFavorite(movieId)
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                  : const Icon(Icons.favorite_outline,
                                      color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          unratedColor: gryClr,
                          itemSize: 20,
                          itemCount: 5,
                          rating: getMovies.voteAverage / 2,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: amberClr,
                          ),
                        ),
                        const SizedBox(width: 13),
                        TextUtils(
                          text: getMovies.voteAverage.toString(),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 37),
                    const TextUtils(
                      text: description,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    ReadMoreText(
                      getMovies.overview,
                      trimExpandedText: showLess,
                      lessStyle: const TextStyle(color: Colors.red),
                      trimCollapsedText: showMore,
                      moreStyle: const TextStyle(color: Colors.red),
                      trimLength: 200,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

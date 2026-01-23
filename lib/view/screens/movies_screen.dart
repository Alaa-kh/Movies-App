import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/view/screens/favorite_screen.dart';
import 'package:readmore/readmore.dart';

import '../../logic/model/movies_on_air_model.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';
import '../widgets/text_utils.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Row(
        children: [
         Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade400.withOpacity(.2),
              ),
              width: 300,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: controller.searchTextController,
                onChanged: (searchName) {
                  controller.addSearchToList(searchName);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder:
                      InputBorder.none,
                  focusedBorder: InputBorder.none, 
                  suffixIcon: controller.searchTextController.text.isEmpty
                      ? IconButton(
                          onPressed: controller.clearSearch,
                          icon: const Icon(Icons.close, color: Colors.white),
                        )
                      : null,
                  contentPadding: const EdgeInsets.all(12),
                  hintText: searchTxt,
                  hintStyle: const TextStyle(color: gryClr),
                ),
              ),
            ),
          ),

          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade400.withOpacity(.2),
              ),
              width: 50,
              child: IconButton(
                onPressed: () {
                  Get.to(FavorieScreen(), transition: Transition.leftToRight);
                },
                icon: Icon(
                  Icons.star,
                  size: 30,
                ),
              )),
        ],
      ),
      Obx(() {
        if (controller.isLoading.value == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            height: 600,
            child: controller.searchList.isEmpty &&
                    controller.searchTextController.text.isNotEmpty
                ? Center(
                    child: Lottie.asset(emptyAnimate),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.searchList.isEmpty
                        ? controller.moviesOnAirList.length
                        : controller.searchList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 1),
                    itemBuilder: (context, index) {
                      if (controller.searchList.isEmpty) {
                        return buildContainerOnAir(
                          width: 200,
                          height: 190,
                          onTap: () => Get.to(
                              MoviesOnAirDetails(
                                  getMovies: controller.moviesOnAirList[index],
                                  movieId:
                                      controller.moviesOnAirList[index].id),
                              transition: Transition.size,
                              duration: const Duration(milliseconds: 500)),
                          image: urlImage +
                              controller.moviesOnAirList[index].posterPath,
                          title: controller.moviesOnAirList[index].name,
                          rate:
                              controller.moviesOnAirList[index].voteAverage / 2,
                          voteAverage: controller
                              .moviesOnAirList[index].voteAverage
                              .toString(),
                          movieId: controller.moviesOnAirList[index].id,
                        );
                      } else {
                        return buildContainerOnAir(
                          width: 200,
                          height: 190,
                          onTap: () => Get.to(
                              () => MoviesOnAirDetails(
                                    getMovies: controller.searchList[index],
                                    movieId: controller.searchList[index].id,
                                  ),
                              transition: Transition.size,
                              duration: const Duration(milliseconds: 500)),
                          image: urlImage +
                              controller.searchList[index].posterPath,
                          title: controller.searchList[index].name,
                          rate: controller.searchList[index].voteAverage / 2,
                          voteAverage: controller.searchList[index].voteAverage
                              .toString(),
                          movieId: controller.searchList[index].id,
                        );
                      }
                    }),
          );
        }
      })
    ]));
  }
}

class buildContainerOnAir extends StatelessWidget {
  const buildContainerOnAir({
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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextUtils(
                        text: voteAverage.toString(),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: gryClr),
                    IconButton(
                        iconSize: 25,
                        onPressed: () {
                          controller.favoriteMovie(movieId);
                        },
                        icon: controller.isFavorite(movieId)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                color: Colors.white,
                              )),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MoviesOnAirDetails extends StatelessWidget {
  MoviesOnAirDetails({
    Key? key,
    required this.getMovies,
    required this.movieId,
  }) : super(key: key);
  Result getMovies;
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
              Image.network(
                urlImage + getMovies.posterPath,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextUtils(
                              text: getMovies.name,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100.withOpacity(.2)),
                              child: IconButton(
                                  iconSize: 30,
                                  onPressed: () {
                                    controller.favoriteMovie(movieId);
                                  },
                                  icon: controller.isFavorite(movieId)
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.white,
                                        ))),
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
                        const SizedBox(
                          width: 13,
                        ),
                        TextUtils(
                            text: getMovies.voteAverage.toString(),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ],
                    ),
                    const SizedBox(
                      height: 37,
                    ),
                    TextUtils(
                        text: description,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    const SizedBox(
                      height: 8,
                    ),
                    ReadMoreText(
                      getMovies.overview,
                      trimExpandedText: showLess,
                      lessStyle: TextStyle(color: Colors.red),
                      trimCollapsedText: showMore,
                      moreStyle: TextStyle(color: Colors.red),
                      trimLength: 200,
                      style: TextStyle(
                          color: Colors.white, fontSize: 16, height: 1.6),
                    )
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

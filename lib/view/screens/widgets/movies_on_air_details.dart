import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movies/logic/model/movies_on_air_model.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/screens/widgets/build_container_on_air.dart';
import 'package:movies/view/widgets/text_utils.dart';
import 'package:readmore/readmore.dart';

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

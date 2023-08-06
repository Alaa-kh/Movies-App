import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:movies/view/widgets/text_utils.dart';
import 'package:readmore/readmore.dart';

import '../../utils/strings.dart';
import '../../utils/theme.dart';

class MovieDetails extends StatelessWidget {
  MovieDetails({
    Key? key,
    required this.getMovies,
  }) : super(key: key);
  final getMovies;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: mainClr,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(urlImage + getMovies.posterPath),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getMovies.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

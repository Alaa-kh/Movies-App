
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../utils/theme.dart';
import '../../widgets/text_utils.dart';
import '../favorite_screen.dart';

Widget buildFavItem(
    {required String image,
    required double voteAverage,
    required String title,
    required final double rate,
    required Function() onTap,
    required int productid}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Row(
          children: [
            SizedBox(
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        image,
                        fit: BoxFit.fill,
                      ))),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUtils(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  TextUtils(
                      text: voteAverage.toString(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
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
            const Spacer(),
            IconButton(
                onPressed: () {
                  controller.favoriteMovie(productid);
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                ))
          ],
        ),
      ),
    ),
  );
}

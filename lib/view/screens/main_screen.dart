import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/movies_controller.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';

final controller = Get.find<MoviesController>();

class MainScreen extends StatelessWidget {
  MainScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: mainClr,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            titleApp,
            style: TextStyle(color: Colors.white),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
            onTap: (value) {
              controller.currentIndex.value = value;
            },
            height: 50,
            backgroundColor: Colors.black.withValues(alpha: .1),
            color: Colors.white.withValues(alpha: .1),
            buttonBackgroundColor: Colors.white.withValues(alpha: .2),
            items: [
              Icon(
                Icons.home,
                color: Colors.white.withValues(alpha: .7),
                size: 30,
              ),
              Icon(
                Icons.movie_creation_outlined,
                color: Colors.white.withValues(alpha: .7),
                size: 30,
              ),
              Icon(
                Icons.favorite,
                color: Colors.white.withValues(alpha: .7),
                size: 30,
              ),
              Icon(
                Icons.logout,
                color: Colors.white.withValues(alpha: .7),
                size: 30,
              ),
            ]),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: controller.tabs,
        ),
      ),
    );
  }
}

class buildContainer extends StatelessWidget {
  const buildContainer({
    Key? key,
    required this.image,
    required this.title,
    required this.voteAverage,
    required this.width,
    required this.height,
    required this.rate,
    required this.onTap,
  }) : super(key: key);
  final String image;
  final String title;
  final String voteAverage;
  final double width;
  final double height;
  final double rate;
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 7,
              ),
              TextUtils(
                  text: voteAverage.toString(),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: gryClr),
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

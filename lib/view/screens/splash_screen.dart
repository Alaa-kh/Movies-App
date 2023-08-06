import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../router/routers.dart';
import '../../utils/animations_string.dart';
import '../../utils/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 6), () => Get.offNamed(Routes.loginScreen));
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(urlSplashAnimate),
              const SizedBox(
                height: 20,
              ),
              const TextUtils(
                  text: splashTitle,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: mainClr)
            ],
          )),
    );
  }
}

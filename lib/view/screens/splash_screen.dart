import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../router/routers.dart';
import '../../utils/animations_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieCtr;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _lottieCtr = AnimationController(vsync: this);
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Get.offAllNamed(Routes.authGate);
  }

  @override
  void dispose() {
    _lottieCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                urlSplashAnimate,
                controller: _lottieCtr,
                onLoaded: (comp) {
                  _lottieCtr
                    ..duration = comp.duration
                    ..forward().whenComplete(_goNext);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'appName'.tr,
                style: TextStyle(
                  color: Colors.black.withOpacity(.8),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

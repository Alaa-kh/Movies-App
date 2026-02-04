import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/controller/theme_controller.dart';
import '../../logic/controller/movies_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final moviesCtrl = Get.find<MoviesController>();
  final localeCtrl = Get.find<LocaleController>();
  final themeCtrl = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Obx(
      () => Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('appName'.tr),
          actions: [
            IconButton(
              onPressed: localeCtrl.toggleLanguage,
              icon: const Icon(Icons.language),
              tooltip: 'language'.tr,
            ),
            IconButton(
              onPressed: themeCtrl.toggleLightDark,
              icon: const Icon(Icons.dark_mode_outlined),
              tooltip: 'theme'.tr,
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (value) => moviesCtrl.currentIndex.value = value,
          height: 52,
          backgroundColor: Colors.transparent,
          color: scheme.surfaceContainerHighest.withValues(alpha: .55),
          buttonBackgroundColor: scheme.primary.withValues(alpha: .25),
          items: [
            Icon(Icons.home, color: scheme.onSurface, size: 28),
            Icon(Icons.movie_creation_outlined,
                color: scheme.onSurface, size: 28),
            Icon(Icons.favorite, color: scheme.onSurface, size: 28),
            Icon(Icons.logout, color: scheme.onSurface, size: 28),
          ],
        ),
        body: IndexedStack(
          index: moviesCtrl.currentIndex.value,
          children: moviesCtrl.tabs,
        ),
      ),
    );
  }
}

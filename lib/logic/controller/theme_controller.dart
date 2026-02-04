import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const _kTheme = 'themeMode';
  final _box = GetStorage();

  final Rx<ThemeMode> modeRx = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<String>(_kTheme);

    modeRx.value = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    Get.changeThemeMode(modeRx.value);
  }

  void toggleLightDark() {
    final next =
        modeRx.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    modeRx.value = next;
    _box.write(_kTheme, next == ThemeMode.dark ? 'dark' : 'light');
    Get.changeThemeMode(next);
  }
}

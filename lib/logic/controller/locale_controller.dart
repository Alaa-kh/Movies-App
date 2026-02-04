import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  static const _kLocale = 'locale';
  final _box = GetStorage();

  final Rx<Locale> localeRx = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();

    final saved = _box.read<String>(_kLocale);
    if (saved != null && saved.isNotEmpty) {
      localeRx.value = _parse(saved);
    } else {
      localeRx.value = _normalizeDevice(Get.deviceLocale);
    }

    Get.updateLocale(localeRx.value);
  }

  Locale _parse(String value) {
    final parts = value.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return const Locale('en', 'US');
  }

  Locale _normalizeDevice(Locale? device) {
    if ((device?.languageCode ?? '').toLowerCase() == 'ar') {
      return const Locale('ar', 'SA');
    }
    return const Locale('en', 'US');
  }

  void toggleLanguage() {
    final next = localeRx.value.languageCode == 'ar'
        ? const Locale('en', 'US')
        : const Locale('ar', 'SA');

    localeRx.value = next;
    _box.write(_kLocale, '${next.languageCode}_${next.countryCode}');
    Get.updateLocale(next);
  }

  String get tmdbLanguage =>
      localeRx.value.languageCode == 'ar' ? 'ar-SA' : 'en-US';
}

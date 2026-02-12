import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movies/localization/app_translations.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/controller/theme_controller.dart';
import 'package:movies/router/routers.dart';
import 'package:movies/theme/app_theme.dart';

import 'firebase_options.dart';
import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await NotificationServices.initializenoti();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(LocaleController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCtrl = Get.find<LocaleController>();
    final themeCtrl = Get.find<ThemeController>();
    return Obx(() {
      final locale = localeCtrl.localeRx.value;
      final isArabic = locale.languageCode == 'ar';

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: locale,
        fallbackLocale: const Locale('en', 'US'),
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light(isArabic: isArabic),
        darkTheme: AppTheme.dark(isArabic: isArabic),
        themeMode: themeCtrl.modeRx.value,
        initialRoute: Routes.splashScreen,
        getPages: AppRoutes.routes,
      );
    });
  }
}

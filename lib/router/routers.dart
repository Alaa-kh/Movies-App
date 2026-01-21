import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/logic/binding/movies_binding.dart';
import 'package:movies/view/auth/login_screen.dart';
import 'package:movies/view/screens/main_screen.dart';
import 'package:movies/view/screens/splash_screen.dart';
import '../logic/binding/auth_binding.dart';
import '../view/auth/signup_screen.dart';

class AppRoutes {
  static const splash = Routes.splashScreen;
  static const main = Routes.mainScreen;
  static const logIn = Routes.loginScreen;

  static final routes = [
    GetPage(
      name: Routes.authGate,
      page: () => const AuthGate(),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => MainScreen(),
      binding: MoviesBinding(),
    ),
    GetPage(
      name: Routes.signupScreen,
      page: () => SignUpScreen(),
      bindings: [AuthBinding(), MoviesBinding()],
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LogInScreen(),
      bindings: [AuthBinding(), MoviesBinding()],
    ),
  ];
}

class Routes {
  static const authGate = '/AuthGate';
  static const splashScreen = '/SplashScreen';
  static const mainScreen = '/MainScreen';
  static const signupScreen = '/SignupScreen';
  static const loginScreen = '/LoginScreen';
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          Future.microtask(() {
            Get.offAllNamed(Routes.mainScreen);
          });
        } else {
          Future.microtask(() {
            Get.offAllNamed(Routes.loginScreen);
          });
        }

        return const SizedBox();
      },
    );
  }
}

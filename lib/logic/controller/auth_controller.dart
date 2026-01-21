import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../notification.dart';
import '../../router/routers.dart';
import 'package:intl/intl.dart';

class AuthController extends GetxController {
  final GetStorage authBox = GetStorage();
  var displayUserName = ''.obs;
  bool isSignedIn = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isVisibility = false;

  void visibility() {
    isVisibility = !isVisibility;

    update();
  }

  void signUpUsingFirebase(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        displayUserName.value = name;
        auth.currentUser!.updateDisplayName(displayUserName.value);
      });
      update();
      Get.offNamed(Routes.mainScreen);
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (error.code == 'weak-password') {
        message = 'The password provided is too weak..';
      } else if (error.code == 'email-already-in-use') {
        message = 'The account already exists for that email..';
      } else {
        message = error.message.toString();
      }

      Get.snackbar(title, message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar('Error !', error.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logInUsingFirebase(
      {required String email, required String password}) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        displayUserName.value = auth.currentUser!.displayName!;
        isSignedIn = true;
        authBox.write('auth', isSignedIn);
        update();
        Get.offNamed(Routes.mainScreen);

        NotificationServices.showNotification(
          title: 'You Are Logged In Movies App',
          body: 'logged in at :' +
              DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now()),
        );
      });
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';
      if (error.code == 'user-not-found') {
        message =
            "Account doesn't exists for that $email.. Create your account by signing up..";
      } else if (error.code == 'wrong-password') {
        message = 'Invalid Password... Please try again!';
      } else {
        message = error.message.toString();
      }

      Get.snackbar(title, message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar('Error !', error.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      update();
      Get.back();
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';
      if (error.code == 'user-not-found') {
        message =
            "Account doesn't exists for that $email.. Create your account by signing up..";
      } else {
        message = error.message.toString();
      }

      Get.snackbar(title, message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar('Error !', error.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

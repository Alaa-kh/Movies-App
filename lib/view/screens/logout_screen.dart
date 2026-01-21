import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/router/routers.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../utils/strings.dart';

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Center(
        child: InkWell(
          onTap: () {
            Get.defaultDialog(
              title: 'Logout From App',
              middleText: 'Are you sure you need to logout?',
              titleStyle: const TextStyle(fontSize: 16),
              buttonColor: Colors.grey,
              confirmTextColor: mainClr,
              cancelTextColor: mainClr,
              onCancel: () => Get.back(),
              cancel: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'NO',
                  style: TextStyle(color: mainClr),
                ),
              ),
              confirm: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(Routes.authGate);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'YES',
                  style: TextStyle(color: mainClr),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: gryClr),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.7),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                TextUtils(
                  text: logOut,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

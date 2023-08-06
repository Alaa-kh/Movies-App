import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../router/routers.dart';
import '../../utils/strings.dart';

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Get.defaultDialog(
              title: 'Logout From App',
              middleText: 'Are you sure you need to logout ?',
              textCancel: ' NO ',
              textConfirm: ' YES ',
              buttonColor: Colors.grey,
              confirmTextColor: mainClr,
              cancelTextColor: mainClr,
              onCancel: () => Get.back(),
              onConfirm: () => Get.offNamed(Routes.loginScreen));
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(border: Border.all(color: gryClr)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.7)),
                child: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              TextUtils(
                  text: logOut,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
            ],
          ),
        ),
      ),
    );

  }
}

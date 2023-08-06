import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';
import '../../utils/animations_string.dart';

final emailController = TextEditingController();
final controller = Get.find<AuthController>();
final fromKey = GlobalKey<FormState>();

class ForgotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 18, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      text: forgot,
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextUtils(
                      text: password,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: mainClr,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(00),
                      bottomRight: Radius.circular(400))),
            ),
            Form(
              key: fromKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  children: [
                    Lottie.asset(forgotAnimate),
                    AuthTextFormField(
                      hintText: enterEmail,
                      controller: emailController,
                      obscureText: false,
                      validator: (value) {
                        if (!RegExp(validationEmail).hasMatch(value)) {
                          return 'Invalid Email';
                        } else {
                          return null;
                        }
                      },
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: gryClr,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(mainClr),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ))),
                          onPressed: () {
                            if (fromKey.currentState!.validate()) {
                              controller
                                  .resetPassword(emailController.text.trim());
                            }
                          },
                          child: const TextUtils(
                              text: send,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

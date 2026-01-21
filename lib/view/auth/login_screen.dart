import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/auth/forgot_pass.dart';
import 'package:movies/view/auth/signup_screen.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';
import '../../utils/strings.dart';

final controller = Get.find<AuthController>();
final fromKey = GlobalKey<FormState>();
final emailController = TextEditingController();
final passwordController = TextEditingController();

class LogInScreen extends StatelessWidget {
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
                child: TextUtils(
                  text: logIn,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(00),
                      bottomRight: Radius.circular(400))),
            ),
            Form(
              key: fromKey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    GetBuilder<AuthController>(
                      builder: (_) => AuthTextFormField(
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<AuthController>(
                        builder: (_) => AuthTextFormField(
                            hintText: password,
                            controller: passwordController,
                            obscureText: controller.isVisibility ? false : true,
                            validator: (value) {
                              if (value.toString().length < 6) {
                                return 'Password should be longer or equal to 6 characters';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: gryClr,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.visibility();
                                },
                                icon: controller.isVisibility
                                    ? const Icon(
                                        Icons.visibility,
                                        color: gryClr,
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                        color: gryClr,
                                      )))),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ForgotScreen(),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 500));
                        },
                        child: const TextUtils(
                            text: forgotPass,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: gryClr),
                      ),
                    ),
                    const SizedBox(
                      height: 72,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: GetBuilder<AuthController>(
                        builder: (_) => ElevatedButton(
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
                                controller.logInUsingFirebase(
                                    email: emailController.text.trim(),
                                    password: passwordController.text);
                              }
                            },
                            child: const TextUtils(
                                text: logIn,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      or,
                      style: TextStyle(height: 2.5),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: const BorderSide(color: gryClr)))),
                          child: const TextUtils(
                              text: signUp,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: mainClr),
                          onPressed: () {
                            Get.offAll(SignUpScreen(),
                                transition: Transition.zoom,
                                duration: const Duration(seconds: 1));
                          },
                        ))
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
